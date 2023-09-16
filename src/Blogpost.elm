module Blogpost exposing
    ( Blogpost
    , Metadata
    , TagWithCount
    , allMetadata
    , allTags
    , blogpostFiles
    , blogpostFromSlug
    )

import BackendTask exposing (BackendTask)
import BackendTask.File as File exposing (FileReadError)
import BackendTask.Glob as Glob
import Date exposing (Date)
import Dict
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Attributes as Attrs
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import List.Extra
import Markdown.Parser
import Markdown.Renderer
import Route
import String.Normalize


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


type alias TagWithCount =
    { slug : String, title : String, count : Int }


allTags : BackendTask { fatal : FatalError, recoverable : FileReadError Decode.Error } (List TagWithCount)
allTags =
    allMetadata
        |> BackendTask.map
            (\metadata ->
                metadata
                    |> List.concatMap .tags
                    |> List.map (\tag -> ( String.Normalize.slug tag, tag ))
                    |> (\tags ->
                            ( Dict.fromList tags
                            , tags
                                |> List.map Tuple.first
                                |> List.Extra.frequencies
                                |> List.map (\( slug, frequency ) -> { slug = slug, count = frequency })
                            )
                       )
                    |> (\( names, slugCount ) ->
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
    Decode.map5 Metadata
        (Decode.field "title" Decode.string)
        (Decode.field "published" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string))
        (Decode.succeed slug)
        (Decode.field "description" Decode.string)
        (Decode.field "tags" <| Decode.list Decode.string)


allMetadata : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } (List Metadata)
allMetadata =
    blogpostFiles
        |> BackendTask.map
            (List.map
                (\file -> File.onlyFrontmatter (metadataDecoder file.slug) <| file.filePath)
            )
        |> BackendTask.resolve
        |> BackendTask.map
            (List.sortBy (.publishedDate >> Date.toRataDie) >> List.reverse)


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
