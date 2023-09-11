module Blogpost exposing
    ( Blogpost
    , Metadata
    , allMetadata
    , blogpostFiles
    , blogpostFromSlug
    , viewBlogpost
    , viewListItem
    )

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import Date exposing (Date)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Attributes as Attrs
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import Markdown.Parser
import Markdown.Renderer
import Route


type alias Blogpost =
    { metadata : Metadata
    , body : String
    }


type alias Metadata =
    { title : String
    , publishedDate : Date
    , slug : String
    , description : String
    , tags : List String
    }


metadataDecoder : String -> Decoder Metadata
metadataDecoder slug =
    Decode.map5 Metadata
        (Decode.field "title" Decode.string)
        (Decode.field "published" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString << Debug.log "date") Decode.string))
        (Decode.succeed slug)
        (Decode.field "description" Decode.string)
        (Decode.field "tags" <| Decode.list Decode.string)


allMetadata : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } (List Metadata)
allMetadata =
    blogpostFiles
        |> BackendTask.map
            (List.map
                (\slug -> File.onlyFrontmatter (metadataDecoder slug) <| "content/blog/" ++ slug ++ ".md")
            )
        |> BackendTask.resolve
        |> BackendTask.map
            (List.sortBy (.publishedDate >> Date.toRataDie) >> List.reverse)


blogpostFiles : BackendTask error (List String)
blogpostFiles =
    Glob.succeed (\slug -> slug)
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


blogpostFromSlug : String -> BackendTask FatalError Blogpost
blogpostFromSlug slug =
    ("content/blog/" ++ slug ++ ".md")
        |> File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map2 Blogpost
                    (metadataDecoder slug)
                    (Decode.succeed markdownString)
            )
        |> BackendTask.allowFatal


markdownToView :
    String
    -> List (Html msg)
markdownToView markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    Markdown.Renderer.defaultHtmlRenderer
                    blocks
            )
        |> Result.withDefault [ Html.text "failed to read markdown" ]



-- VIEW


viewBlogpost : Blogpost -> Html msg
viewBlogpost { metadata, body } =
    Html.div []
        [ Html.h1 [ Attrs.class "my-16 font-bold text-5xl text-gray-900 dark:text-gray-100" ] [ Html.text metadata.title ]
        , Html.p [ Attrs.class "my-4 font-bold text-xl text-gray-900 dark:text-gray-100" ] [ Html.text metadata.description ]
        , Html.div
            [ Attrs.class "prose  lg:prose-xl dark:prose-invert" ]
            (markdownToView body)
        ]


viewPublishedDate date =
    Html.dl []
        [ Html.dt
            [ Attrs.class "sr-only"
            ]
            [ Html.text "Published on" ]
        , Html.dd
            [ Attrs.class "text-base font-medium leading-6 text-gray-500 dark:text-gray-400"
            ]
            [ Html.time
                [ Attrs.datetime <| Date.toIsoString date
                ]
                [ Html.text <| Date.format "d. MMM YYYY" date ]
            ]
        ]


viewTag : String -> Html msg
viewTag slug =
    Html.a
        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
        , Attrs.href ""
        ]
        [ Html.text slug ]


viewListItem : Metadata -> Html.Html msg
viewListItem metadata =
    Html.article [ Attrs.class "my-12" ]
        [ Html.div
            [ Attrs.class "space-y-2 xl:grid xl:grid-cols-4 xl:items-baseline xl:space-y-0"
            ]
            [ viewPublishedDate metadata.publishedDate
            , Html.div
                [ Attrs.class "space-y-5 xl:col-span-3"
                ]
                [ Html.div
                    [ Attrs.class "space-y-6"
                    ]
                    [ Html.div []
                        [ Html.h2
                            [ Attrs.class "text-2xl font-bold leading-8 tracking-tight"
                            ]
                            [ Route.Blog__Slug_ { slug = metadata.slug }
                                |> Route.link
                                    [ Attrs.class "text-gray-900 hover:underline decoration-primary-600 dark:text-gray-100"
                                    ]
                                    [ Html.text metadata.title ]
                            ]
                        , Html.div
                            [ Attrs.class "flex flex-wrap"
                            ]
                          <|
                            List.map viewTag metadata.tags
                        ]
                    , Html.div
                        [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                        ]
                        [ Html.text metadata.description ]
                    ]
                , Html.div
                    [ Attrs.class "text-base font-medium leading-6"
                    ]
                    [ Route.Blog__Slug_ { slug = metadata.slug }
                        |> Route.link
                            [ Attrs.class "text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                            , Attrs.attribute "aria-label" ("Read \"" ++ metadata.title ++ "\"")
                            ]
                            [ Html.text "Read more ->" ]
                    ]
                ]
            ]
        ]
