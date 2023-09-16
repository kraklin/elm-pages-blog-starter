module Route.Tags.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask, allowFatal)
import BackendTask.File as File
import BackendTask.Glob as Glob
import BlogList
import Blogpost exposing (Blogpost, TagWithCount)
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
import Settings
import Shared
import String.Normalize
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


pages : BackendTask FatalError (List RouteParams)
pages =
    Blogpost.allTags
        |> BackendTask.allowFatal
        |> BackendTask.map
            (List.map (\tag -> { slug = tag.title |> String.Normalize.slug }))


type alias Data =
    { blogposts : List Blogpost.Metadata
    , tags : List TagWithCount
    , selectedTag : Maybe TagWithCount
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    BackendTask.map2 (\blogposts tags -> Data blogposts tags (List.filter (\tag -> tag.slug == routeParams.slug) tags |> List.head))
        (Blogpost.allMetadata
            |> BackendTask.map
                (\metadata ->
                    List.filter
                        (\{ tags } ->
                            List.map String.Normalize.slug tags
                                |> List.member routeParams.slug
                        )
                        metadata
                )
        )
        Blogpost.allTags
        |> BackendTask.allowFatal


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "List of Tags: TODO"
        , locale = Nothing
        , title = "Tags: TODO"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = "Tag: TODO"
    , body = BlogList.view app.data.tags app.data.blogposts app.data.selectedTag
    }
