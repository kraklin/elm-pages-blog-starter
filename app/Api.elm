module Api exposing (manifest, routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Content.About
import FatalError exposing (FatalError)
import Html exposing (Html)
import Iso8601
import Pages
import Pages.Manifest as Manifest
import Route exposing (Route(..))
import Settings
import Sitemap


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ sitemap <| makeSitemapEntries getStaticRoutes ]


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = Settings.title
        , description = Settings.subtitle
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }


sitemap :
    BackendTask FatalError (List Sitemap.Entry)
    -> ApiRoute.ApiRoute ApiRoute.Response
sitemap entriesSource =
    ApiRoute.succeed
        (entriesSource
            |> BackendTask.map
                (\entries ->
                    [ """<?xml version="1.0" encoding="UTF-8"?>"""
                    , Sitemap.build { siteUrl = Settings.baseUrl } entries
                    ]
                        |> String.join "\n"
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single


makeSitemapEntries : BackendTask FatalError (List Route) -> BackendTask FatalError (List Sitemap.Entry)
makeSitemapEntries getStaticRoutes =
    let
        build route =
            let
                routeSource lastMod =
                    BackendTask.succeed
                        { path = String.join "/" (Route.routeToPath route)
                        , lastMod = Just lastMod
                        }
            in
            case route of
                Index ->
                    Just <| routeSource <| Iso8601.fromTime <| Pages.builtAt

                About ->
                    Just <| routeSource <| Content.About.updatedAt

                TechBlog ->
                    Just <| BackendTask.andThen routeSource <| BackendTask.succeed <| Iso8601.fromTime <| Pages.builtAt

                TechBlog__Slug_ routeParams ->
                    Just <| routeSource <| Iso8601.fromTime <| Pages.builtAt

                LifeBlog ->
                    Just <| BackendTask.andThen routeSource <| BackendTask.succeed <| Iso8601.fromTime <| Pages.builtAt

                LifeBlog__Slug_ routeParams ->
                    Just <| routeSource <| Iso8601.fromTime <| Pages.builtAt

                Tags ->
                    Just <| BackendTask.andThen routeSource <| BackendTask.succeed <| Iso8601.fromTime <| Pages.builtAt

                Tags__Slug_ routeParams ->
                    Just <| routeSource <| Iso8601.fromTime <| Pages.builtAt
    in
    getStaticRoutes
        |> BackendTask.map (List.filterMap build)
        |> BackendTask.resolve
