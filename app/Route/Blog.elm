module Route.Blog exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Blogpost exposing (Metadata, TagWithCount)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout
import Layout.Blogpost
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import UrlPath
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { blogposts :
        List Metadata
    , tags : List TagWithCount
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.map2 Data
        (Content.Blogpost.allBlogposts
            |> BackendTask.map (List.map .metadata)
        )
        Content.Blogpost.allTags


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
    { title = "Blog"
    , body =
        Layout.Blogpost.viewPostList app.data.tags app.data.blogposts Nothing
    }
