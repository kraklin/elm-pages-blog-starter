module Api exposing (manifest, routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Pages.Manifest as Manifest
import Route exposing (Route)
import Settings


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    []


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = Settings.title
        , description = Settings.subtitle
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
