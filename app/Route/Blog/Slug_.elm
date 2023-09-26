module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Content.About exposing (Author)
import Content.Blogpost exposing (Blogpost)
import Dict exposing (Dict)
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
    Content.Blogpost.allBlogposts
        |> BackendTask.allowFatal
        |> BackendTask.map
            (\blogposts ->
                List.map (\{ metadata } -> { slug = metadata.slug }) blogposts
            )


type alias Data =
    { blogpost : Blogpost
    , authors : Dict String Author
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    BackendTask.map2 Data
        (Content.Blogpost.blogpostFromSlug routeParams.slug)
        Content.About.allAuthors


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        imagePath =
            app.data.blogpost.metadata.image
                |> Maybe.withDefault "/media/logo.svg"
    in
    Seo.summaryLarge
        { canonicalUrlOverride = Just Settings.canonicalUrl
        , siteName = Settings.title
        , image =
            { url = Pages.Url.external <| Settings.canonicalUrl ++ imagePath
            , alt = app.data.blogpost.metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Maybe.withDefault "" app.data.blogpost.metadata.description
        , locale = Nothing
        , title = app.data.blogpost.metadata.title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = app.data.blogpost.metadata.title
    , body = [ Layout.Blogpost.viewBlogpost app.data.authors app.data.blogpost ]
    }
