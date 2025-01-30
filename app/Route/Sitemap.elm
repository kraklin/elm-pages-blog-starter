module Route.Sitemap exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.File
import BackendTask.Glob as Glob
import FatalError exposing (FatalError)
import Html exposing (text)
import Json.Decode as Decode
import Route
import RouteBuilder exposing (StatelessRoute)
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias ActionData =
    {}


type alias Data =
    { sitemapXml : String
    }


type alias Metadata =
    { updated : Maybe String
    , published : String
    }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = \_ -> []
        , data = data
        }
        |> RouteBuilder.buildNoState { view = \app shared -> view app.data }


data : BackendTask FatalError Data
data =
    generateSitemap
        |> BackendTask.map
            (\sitemapXml ->
                { sitemapXml = sitemapXml }
            )


generateSitemap : BackendTask FatalError String
generateSitemap =
    let
        sitemapEntry filePath metadata =
            let
                lastmod =
                    metadata.updated
                        |> Maybe.withDefault metadata.published
            in
            if String.contains "/tech-blog/" filePath then
                Just
                    (String.join "\n"
                        [ "    <url>"
                        , "        <loc>https://yoursite.com/tech-blog/" ++ extractSlug filePath ++ "</loc>"
                        , "        <lastmod>" ++ lastmod ++ "</lastmod>"
                        , "    </url>"
                        ]
                    )

            else if String.contains "/life-blog/" filePath then
                Just
                    (String.join "\n"
                        [ "    <url>"
                        , "        <loc>https://yoursite.com/life-blog/" ++ extractSlug filePath ++ "</loc>"
                        , "        <lastmod>" ++ lastmod ++ "</lastmod>"
                        , "    </url>"
                        ]
                    )

            else
                Nothing
    in
    Glob.succeed identity
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.recursiveWildcard
        |> Glob.match (Glob.literal "/index.md")
        |> Glob.toBackendTask
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\files ->
                files
                    |> List.map
                        (\segments ->
                            let
                                filePath =
                                    "content/" ++ String.join "/" segments ++ "/index.md"
                            in
                            BackendTask.File.onlyFrontmatter frontmatterDecoder filePath
                                |> BackendTask.allowFatal
                                |> BackendTask.map (\metadata -> ( filePath, metadata ))
                        )
                    |> BackendTask.combine
            )
        |> BackendTask.map
            (\files ->
                String.join "\n"
                    [ """<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://yoursite.com/</loc>
        <lastmod>2024-01-01</lastmod>
    </url>"""
                    , files
                        |> List.filterMap (\( filePath, metadata ) -> sitemapEntry filePath metadata)
                        |> String.join "\n"
                    , "</urlset>"
                    ]
            )


frontmatterDecoder : Decode.Decoder Metadata
frontmatterDecoder =
    Decode.map2 Metadata
        (Decode.maybe (Decode.field "updated" Decode.string))
        (Decode.field "published" Decode.string)


extractSlug : String -> String
extractSlug path =
    path
        |> String.split "/"
        |> List.reverse
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""


view : Data -> View msg
view static =
    { body =
        [ Html.node "xml"
            []
            [ text static.sitemapXml ]
        ]
    , title = ""
    }
