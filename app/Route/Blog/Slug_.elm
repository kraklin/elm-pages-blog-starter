module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Blogpost exposing (Blogpost)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.Blogpost
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
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


pages : BackendTask FatalError (List RouteParams)
pages =
    Blogpost.blogpostFiles
        |> BackendTask.map
            (\slugs ->
                List.map (\{ slug } -> { slug = slug }) slugs
            )


type alias Data =
    Blogpost


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    Blogpost.blogpostFromSlug routeParams.slug


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
        , description = app.data.metadata.description
        , locale = Nothing
        , title = app.data.metadata.title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = app.data.metadata.title
    , body = [ Layout.Blogpost.viewBlogpost app.data ]
    }
