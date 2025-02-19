module Content.AllBlogpost exposing
    ( allBlogposts
    , allTags
    , blogpostFromSlug
    )

import Array
import BackendTask exposing (BackendTask)
import BackendTask.Env
import BackendTask.File as File
import BackendTask.Glob as Glob
import Content.About exposing (Author)
import Content.BlogpostCommon exposing (Blogpost, Category(..), Metadata, Status(..), TagWithCount)
import Date exposing (Date)
import DateOrDateTime exposing (DateOrDateTime)
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import List.Extra
import String.Normalize


allTags : BackendTask FatalError (List TagWithCount)
allTags =
    allBlogposts
        |> BackendTask.map
            (List.concatMap
                (\{ metadata } ->
                    metadata.tags
                        |> List.map (\tag -> ( String.Normalize.slug tag, tag ))
                )
                >> (\tags ->
                        ( Dict.fromList tags
                        , tags
                            |> List.map Tuple.first
                            |> List.Extra.frequencies
                            |> List.map (\( slug, frequency ) -> { slug = slug, count = frequency })
                        )
                   )
                >> (\( names, slugCount ) ->
                        List.map
                            (\{ slug, count } ->
                                { slug = slug
                                , count = count
                                , title = Dict.get slug names |> Maybe.withDefault slug
                                }
                            )
                            slugCount
                   )
            )


decodeCategory : Decoder Category
decodeCategory =
    Decode.field "category" Decode.string
        |> Decode.andThen
            (\categoryString ->
                case categoryString of
                    "tech" ->
                        Decode.succeed Tech

                    "life" ->
                        Decode.succeed Life

                    _ ->
                        Decode.succeed Unknown
            )


decodeStatus : Decoder Status
decodeStatus =
    Decode.map3
        (\publishedDate updatedDate statusString ->
            case ( statusString, publishedDate, updatedDate ) of
                ( Just "draft", _, _ ) ->
                    Draft

                ( _, Just date, Nothing ) ->
                    PublishedWithDate date

                ( _, Just date1, Just date2 ) ->
                    PublishedAndUpdatedWithDate date1 date2

                _ ->
                    Published
        )
        (Decode.maybe (Decode.field "published" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string)))
        (Decode.maybe (Decode.field "updated" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string)))
        (Decode.maybe (Decode.field "status" Decode.string))


dateOrDateTimeDecoder : Decoder DateOrDateTime
dateOrDateTimeDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case Date.fromIsoString str of
                    Ok date ->
                        Decode.succeed (DateOrDateTime.Date date)

                    Err _ ->
                        Decode.fail "Invalid date format"
            )


metadataDecoder : Dict String Author -> String -> Decoder Metadata
metadataDecoder authorsDict slug =
    Decode.succeed Metadata
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault slug >> String.Normalize.slug)
                (Decode.maybe (Decode.field "slug" Decode.string))
            )
        |> Decode.andMap (Decode.maybe (Decode.field "image" Decode.string))
        |> Decode.andMap (Decode.maybe (Decode.field "description" Decode.string))
        |> Decode.andMap decodeCategory
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault [])
                (Decode.maybe (Decode.field "tags" <| Decode.list Decode.string))
            )
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault [ "default" ])
                (Decode.maybe (Decode.field "authors" <| Decode.list Decode.string))
                |> Decode.map (\authors -> List.filterMap (\authorSlug -> Dict.get authorSlug authorsDict) authors)
            )
        |> Decode.andMap decodeStatus
        |> Decode.andMap (Decode.maybe (Decode.field "published" dateOrDateTimeDecoder))
        |> Decode.andMap (Decode.maybe (Decode.field "updated" dateOrDateTimeDecoder))
        |> Decode.andMap (Decode.succeed 1)


getPublishedDate : Metadata -> Date
getPublishedDate { status } =
    case status of
        PublishedWithDate date ->
            date

        _ ->
            Date.fromRataDie 1


allBlogposts : BackendTask FatalError (List Blogpost)
allBlogposts =
    let
        addPreviousNextPosts orderedBlogposts =
            orderedBlogposts
                |> BackendTask.map Array.fromList
                |> BackendTask.map
                    (\blogposts ->
                        Array.indexedMap
                            (\index blogpost ->
                                { blogpost
                                    | previousPost = Array.get (index + 1) blogposts |> Maybe.map .metadata
                                    , nextPost = Array.get (index - 1) blogposts |> Maybe.map .metadata
                                }
                            )
                            blogposts
                    )
                |> BackendTask.map Array.toList

        updateReadingTime blogposts =
            let
                updatedMetadata blogpost metadata =
                    { metadata | readingTimeInMin = String.split " " blogpost |> List.length |> (\words -> words // 200) }
            in
            blogposts
                |> BackendTask.map (List.map (\blogpost -> { blogpost | metadata = updatedMetadata blogpost.body blogpost.metadata }))

        addDraftTag metadata =
            case metadata.status of
                Draft ->
                    { metadata | tags = "draft" :: metadata.tags }

                _ ->
                    metadata
    in
    BackendTask.map2
        (\blogposts authorsDict ->
            List.map
                (\file ->
                    file.filePath
                        |> File.bodyWithFrontmatter
                            (\markdownString ->
                                Decode.map2 (\metadata body -> Blogpost metadata body Nothing Nothing)
                                    (metadataDecoder authorsDict file.slug)
                                    (Decode.succeed markdownString)
                            )
                        |> BackendTask.map (\blogpost -> { blogpost | metadata = addDraftTag blogpost.metadata })
                        |> BackendTask.allowFatal
                )
                blogposts
        )
        allBlogPostFiles
        Content.About.allAuthors
        |> BackendTask.resolve
        |> BackendTask.andThen
            (\blogposts ->
                BackendTask.Env.get "INCLUDE_DRAFTS"
                    |> BackendTask.map
                        (\includeDrafts ->
                            case includeDrafts of
                                Just "true" ->
                                    blogposts

                                _ ->
                                    List.filter (\{ metadata } -> metadata.status /= Draft) blogposts
                        )
            )
        |> BackendTask.map
            (List.sortBy (.metadata >> getPublishedDate >> Date.toRataDie) >> List.reverse)
        |> addPreviousNextPosts
        |> updateReadingTime


allBlogpostsDict : BackendTask FatalError (Dict String Blogpost)
allBlogpostsDict =
    allBlogposts |> BackendTask.map (\blogposts -> List.map (\blogpost -> ( blogpost.metadata.slug, blogpost )) blogposts |> Dict.fromList)


allBlogPostFiles : BackendTask FatalError (List { filePath : String, path : List String, slug : String })
allBlogPostFiles =
    Glob.succeed
        (\filePath blogType slug ->
            { filePath = filePath
            , path = [ blogType ]
            , slug = slug
            }
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture
            (Glob.oneOf
                ( ( "tech-blog", "tech-blog" )
                , [ ( "life-blog", "life-blog" ) ]
                )
            )
        |> Glob.match (Glob.literal "/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


blogpostFromSlug : String -> BackendTask FatalError Blogpost
blogpostFromSlug slug =
    allBlogpostsDict
        |> BackendTask.andThen
            (\blogpostDict ->
                Dict.get slug blogpostDict
                    |> Maybe.map BackendTask.succeed
                    |> Maybe.withDefault (BackendTask.fail <| FatalError.fromString <| "Unable to find post with slug " ++ slug)
            )
