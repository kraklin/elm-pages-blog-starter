module Route.TechBlog exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.TechBlogpost
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout
import Layout.TechBlogpost
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route.BlogCommon
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import UrlPath
import View exposing (View)


type alias ActionData =
    Route.BlogCommon.ActionData


type alias Data =
    Route.BlogCommon.Data


type alias Model =
    Route.BlogCommon.Model


type alias Msg =
    Route.BlogCommon.Msg


type alias RouteParams =
    Route.BlogCommon.RouteParams


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.map2 Route.BlogCommon.Data
        (Content.TechBlogpost.allBlogposts
            |> BackendTask.map (List.map .metadata)
        )
        Content.TechBlogpost.allTags


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Layout.seoHeaders


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "Tech Blog"
    , body =
        Layout.TechBlogpost.viewPostList app.data.tags app.data.blogposts Nothing
    }
