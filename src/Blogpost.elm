module Blogpost exposing
    ( Blogpost
    , Metadata
    , TagWithCount
    , allBlogposts
    , allTags
    , blogpostFiles
    , blogpostFromSlug
    )

import Array
import BackendTask exposing (BackendTask)
import BackendTask.File as File exposing (FileReadError)
import BackendTask.Glob as Glob
import Date exposing (Date)
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import List.Extra
import String.Normalize


type alias Blogpost =
    { metadata : Metadata
    , body : String
    , previousPost : Maybe Metadata
    , nextPost : Maybe Metadata
    }


type alias Metadata =
    { title : String
    , publishedDate : Date
    , slug : String
    , image : Maybe String
    , description : Maybe String
    , tags : List String
    }


type alias TagWithCount =
    { slug : String, title : String, count : Int }


allTags : BackendTask { fatal : FatalError, recoverable : FileReadError Decode.Error } (List TagWithCount)
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


metadataDecoder : String -> Decoder Metadata
metadataDecoder slug =
    Decode.map6 Metadata
        (Decode.field "title" Decode.string)
        (Decode.field "published" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string))
        (Decode.succeed slug)
        (Decode.maybe (Decode.field "image" Decode.string))
        (Decode.maybe (Decode.field "description" Decode.string))
        (Decode.map (Maybe.withDefault []) (Decode.maybe (Decode.field "tags" <| Decode.list Decode.string)))


allBlogposts : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } (List Blogpost)
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
    in
    blogpostFiles
        |> BackendTask.map
            (List.map
                (\file ->
                    file.filePath
                        |> File.bodyWithFrontmatter
                            (\markdownString ->
                                Decode.map2 (\metadata body -> Blogpost metadata body Nothing Nothing)
                                    (metadataDecoder file.slug)
                                    (Decode.succeed markdownString)
                            )
                )
            )
        |> BackendTask.resolve
        |> BackendTask.map
            (List.sortBy (.metadata >> .publishedDate >> Date.toRataDie) >> List.reverse)
        |> addPreviousNextPosts


allBlogpostsDict : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } (Dict String Blogpost)
allBlogpostsDict =
    allBlogposts |> BackendTask.map (\blogposts -> List.map (\blogpost -> ( blogpost.metadata.slug, blogpost )) blogposts |> Dict.fromList)


blogpostFiles : BackendTask error (List { filePath : String, path : List String, slug : String })
blogpostFiles =
    Glob.succeed
        (\filePath path fileName ->
            { filePath = filePath
            , path = path
            , slug = fileName
            }
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.recursiveWildcard
        |> Glob.match (Glob.literal "/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


blogpostFromSlug : String -> BackendTask FatalError Blogpost
blogpostFromSlug slug =
    allBlogpostsDict
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\blogpostDict ->
                Dict.get slug blogpostDict
                    |> Maybe.map BackendTask.succeed
                    |> Maybe.withDefault (BackendTask.fail <| FatalError.fromString <| "Unable to find post with slug " ++ slug)
            )
