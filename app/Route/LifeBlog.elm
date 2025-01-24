module Route.LifeBlog exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.LifeBlogpost
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.LifeBlogpost
import PagesMsg exposing (PagesMsg)
import Route.BlogCommon
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
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
        (Content.LifeBlogpost.allBlogposts
            |> BackendTask.map (List.map .metadata)
        )
        Content.LifeBlogpost.allTags


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image = Settings.logoImageForSeo
        , description = "Life Blog posts."
        , locale = Settings.locale
        , title = "Life Blog"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "Life Blog"
    , body =
        Layout.LifeBlogpost.viewPostList app.data.tags app.data.blogposts Nothing
    }
