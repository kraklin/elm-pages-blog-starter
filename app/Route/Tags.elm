module Route.Tags exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.BlogpostCommon
import Content.LifeBlogpost
import Content.TechBlogpost
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.Tags
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
    {}


type alias Data =
    List Content.BlogpostCommon.TagWithCount


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
    BackendTask.map2 (++) Content.TechBlogpost.allTags Content.LifeBlogpost.allTags


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image = Settings.logoImageForSeo
        , description = "List of Tags."
        , locale = Settings.locale
        , title = "Tags"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "Tags"
    , body =
        [ Layout.Tags.view app.data ]
    }
