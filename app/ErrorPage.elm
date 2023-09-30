module ErrorPage exposing (ErrorPage(..), Model, Msg, init, internalError, notFound, statusCode, update, view)

import Effect exposing (Effect)
import Html
import View exposing (View)


type Msg
    = NoOp


type alias Model =
    {}


init : ErrorPage -> ( Model, Effect Msg )
init _ =
    ( {}, Effect.none )


update : ErrorPage -> Msg -> Model -> ( Model, Effect Msg )
update _ _ model =
    ( model, Effect.none )


type ErrorPage
    = NotFound
    | InternalError String


notFound : ErrorPage
notFound =
    NotFound


internalError : String -> ErrorPage
internalError =
    InternalError


view : ErrorPage -> Model -> View Msg
view error _ =
    case error of
        NotFound ->
            { body =
                [ Html.div []
                    [ Html.p [] [ Html.text "Page not found. Maybe try another URL?" ]
                    ]
                ]
            , title = "This is a NotFound Error"
            }

        InternalError reason ->
            { body =
                [ Html.div []
                    [ Html.p [] [ Html.text <| "Internal error: " ++ reason ]
                    ]
                ]
            , title = "This is an Internal Error"
            }


statusCode : ErrorPage -> number
statusCode error =
    case error of
        NotFound ->
            404

        InternalError _ ->
            500
