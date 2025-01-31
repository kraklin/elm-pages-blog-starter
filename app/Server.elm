module Main exposing (routes)

import Api.Sitemap
import ApiRoute
import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Server.Request exposing (Request)
import Server.Response exposing (Response)


routes :
    List
        { path : String
        , handler : Request -> BackendTask FatalError Response
        }
routes =
    [ ApiRoute.succeed Api.Sitemap.route
    ]
