module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Blogpost exposing (Blogpost)
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
        |> BackendTask.map
            (\blogposts ->
                List.map (\{ metadata } -> { slug = metadata.slug }) blogposts
            )


type alias Data =
    { blogpost : Blogpost
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    BackendTask.map Data
        (Content.Blogpost.blogpostFromSlug routeParams.slug)


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        imagePath =
            app.data.blogpost.metadata.image
                |> Maybe.withDefault "/media/blog-image.png"

        authorsHeader =
            case app.data.blogpost.metadata.authors of
                [] ->
                    []

                [ author ] ->
                    [ Head.metaName "twitter:label1" <| Head.raw "Author"
                    , Head.metaName "twitter:data1" <| Head.raw author.name
                    ]

                authors ->
                    [ Head.metaName "twitter:label1" <| Head.raw "Authors"
                    , Head.metaName "twitter:data1" <| Head.raw <| String.join ", " <| List.map .name authors
                    ]
    in
    (Seo.summaryLarge
        { canonicalUrlOverride = Just Settings.canonicalUrl
        , siteName = Settings.title
        , image =
            { url = Pages.Url.fromPath [ imagePath ]
            , alt = app.data.blogpost.metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Maybe.withDefault Settings.subtitle app.data.blogpost.metadata.description
        , locale = Nothing
        , title = app.data.blogpost.metadata.title
        }
        |> Seo.website
    )
        ++ authorsHeader
        ++ [ Head.metaName "twitter:label2" <| Head.raw "Reading time"
           , Head.metaName "twitter:data2" <| Head.raw <| String.fromInt app.data.blogpost.metadata.readingTimeInMin ++ " min"
           ]


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = app.data.blogpost.metadata.title
    , body = [ Layout.Blogpost.viewBlogpost app.data.blogpost ]
    }
