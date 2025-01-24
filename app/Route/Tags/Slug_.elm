module Route.Tags.Slug_ exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.AllBlogpost
import Content.BlogpostCommon exposing (Metadata, TagWithCount)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.Blogpost
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
import String.Normalize
import Url
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
    Content.AllBlogpost.allTags
        |> BackendTask.map
            (List.map
                (\tag ->
                    { slug =
                        tag.title
                            |> String.Normalize.slug
                            |> Url.percentEncode
                    }
                )
            )


type alias Data =
    { blogposts : List Metadata
    , tags : List TagWithCount
    , selectedTag : Maybe TagWithCount
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    let
        decodedSlug =
            routeParams.slug
                |> Url.percentDecode
                |> Maybe.withDefault routeParams.slug
    in
    BackendTask.map2
        (\blogposts tags ->
            Data blogposts tags (List.filter (\tag -> tag.slug == decodedSlug) tags |> List.head)
        )
        (Content.AllBlogpost.allBlogposts
            |> BackendTask.map
                (\blogposts ->
                    blogposts
                        |> List.map .metadata
                        |> List.filter
                            (\{ tags } ->
                                List.map String.Normalize.slug tags
                                    |> List.member decodedSlug
                            )
                )
        )
        Content.AllBlogpost.allTags


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image = Settings.logoImageForSeo
        , description =
            case app.data.selectedTag of
                Just tag ->
                    "List of posts with tag: " ++ tag.title

                Nothing ->
                    ""
        , locale = Settings.locale
        , title =
            case app.data.selectedTag of
                Just tag ->
                    tag.title ++ " Posts"

                Nothing ->
                    ""
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "Tag: TODO"
    , body = Layout.Blogpost.viewPostList app.data.tags app.data.blogposts app.data.selectedTag
    }
