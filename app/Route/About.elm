module Route.About exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask
import Content.About exposing (Author)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.About
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
    { author : Author }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask.BackendTask FatalError Data
data =
    Content.About.defaultAuthor
        |> BackendTask.allowFatal
        |> BackendTask.map Data


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Layout.About.seoHeaders app.data.author


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "About"
    , body =
        [ Layout.About.view app.data.author ]
    }
