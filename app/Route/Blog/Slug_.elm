module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Json.Decode as Decode
import Json.Decode.Extra as Decode
import Markdown.Parser
import Markdown.Renderer
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


blogpostFiles =
    Glob.succeed (\slug -> slug)
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


pages : BackendTask FatalError (List RouteParams)
pages =
    blogpostFiles
        |> BackendTask.map
            (\slugs ->
                List.map (\slug -> { slug = slug }) slugs
            )


type alias Data =
    { title : String

    --, tags : List String
    --, description : String
    , body : String
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    ("content/blog/" ++ routeParams.slug ++ ".md")
        |> File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map2
                    (\title renderedMarkdown ->
                        { title = title
                        , body = markdownString
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (markdownString
                        |> markdownToView
                        |> Decode.fromResult
                    )
            )
        |> BackendTask.allowFatal


markdownToView :
    String
    -> Result String (List (Html msg))
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


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = "Placeholder - Blog.Slug_"
    , body = Result.withDefault [ Html.text "unable to parse to markdown" ] <| markdownToView app.data.body
    }
