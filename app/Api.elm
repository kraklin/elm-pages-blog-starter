module Api exposing (manifest, routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Content.Blogpost
import FatalError exposing (FatalError)
import Html exposing (Html)
import Pages
import Pages.Manifest as Manifest
import Route exposing (Route)
import Rss
import Settings


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ rssRoute ]


rssRoute : ApiRoute ApiRoute.Response
rssRoute =
    ApiRoute.succeed
        (Content.Blogpost.allBlogposts
            |> BackendTask.map
                (\blogposts ->
                    Rss.generate
                        { title = Settings.title
                        , description = Settings.subtitle
                        , url = Settings.canonicalUrl ++ "/blog"
                        , lastBuildTime = Pages.builtAt
                        , generator = Just "elm-pages"
                        , items = List.map blogpostToRssItem blogposts
                        , siteUrl = Settings.canonicalUrl
                        }
                )
        )
        |> ApiRoute.literal "blog"
        |> ApiRoute.slash
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.single


blogpostToRssItem : Content.Blogpost.Blogpost -> Rss.Item
blogpostToRssItem { metadata } =
    { title = metadata.title
    , description = metadata.description |> Maybe.withDefault ""
    , url = "/blog/" ++ metadata.slug
    , categories = metadata.tags
    , author = metadata.authors |> List.map .name |> String.join ", "
    , pubDate = Rss.Date (Content.Blogpost.getPublishedDate metadata)
    , content = Nothing
    , contentEncoded = Nothing
    , enclosure = Nothing
    }


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = Settings.title
        , description = Settings.subtitle
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
