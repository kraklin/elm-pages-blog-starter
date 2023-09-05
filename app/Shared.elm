module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import BackendTask exposing (BackendTask)
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Svg
import Svg.Attributes as SvgAttrs
import UrlPath exposing (UrlPath)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type Msg
    = SharedMsg SharedMsg
    | MenuClicked


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMenu : Bool
    }


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( { showMenu = False }
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SharedMsg globalMsg ->
            ( model, Effect.none )

        MenuClicked ->
            ( { model | showMenu = not model.showMenu }, Effect.none )


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


title : String
title =
    "elm-pages blog template"


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (Html msg), title : String }
view sharedData page model toMsg pageView =
    { body =
        [ Html.div
            [ Attrs.class "absolute z-20 top-0 inset-x-0 flex justify-center overflow-hidden pointer-events-none"
            ]
            [ Html.div
                [ Attrs.class "w-[108rem] flex-none flex justify-end"
                ]
                [ Html.node "picture"
                    []
                    [ Html.source
                        [ Attrs.attribute "srcset" "/public/media/docs@30.8b9a76a2.avif"
                        , Attrs.type_ "image/avif"
                        ]
                        []
                    , Html.img
                        [ Attrs.src "/public/media/docs@tinypng.d9e4dcdc.png"
                        , Attrs.alt ""
                        , Attrs.class "w-[71.75rem] flex-none max-w-none dark:hidden"
                        , Attrs.attribute "decoding" "async"
                        ]
                        []
                    ]
                , Html.node "picture"
                    []
                    [ Html.source
                        [ Attrs.attribute "srcset" "/public/media/docs-dark@30.1a9f8cbf.avif"
                        , Attrs.type_ "image/avif"
                        ]
                        []
                    , Html.img
                        [ Attrs.src "/public/media/docs-dark@tinypng.1bbe175e.png"
                        , Attrs.alt ""
                        , Attrs.class "w-[90rem] flex-none max-w-none hidden dark:block"
                        , Attrs.attribute "decoding" "async"
                        ]
                        []
                    ]
                ]
            ]
        , Html.section [ Attrs.class "mx-auto max-w-3xl px-4 sm:px-6 xl:max-w-5xl xl:px-0" ]
            [ Html.header
                [ Attrs.class "flex items-center justify-between py-10"
                ]
                [ Html.div []
                    [ Html.a
                        [ Attrs.attribute "aria-label" title
                        , Attrs.href "/"
                        ]
                        [ Html.div
                            [ Attrs.class "flex items-center justify-between"
                            ]
                            [ Html.div
                                [ Attrs.class "mr-1 text-blue-400"
                                ]
                                [ Svg.svg
                                    [ SvgAttrs.width "80"
                                    , SvgAttrs.height "80"
                                    , SvgAttrs.viewBox "0 0 700 351"
                                    ]
                                    [ Svg.g
                                        [ SvgAttrs.fill "currentColor"
                                        , SvgAttrs.fillRule "evenodd"
                                        ]
                                        [ Svg.path
                                            [ SvgAttrs.d "M529.5 169 700 0H359zM349.7 349l79.7-79H270zM266.2 86.5l79 79.7V6.8zM352 180h168l-82 82H270zM175.77 176.5l84.85-84.85 84.85 84.85-84.85 84.85zM353.03 173.3l166.87-1.4L354.44 6.42zM170.5 182 341 351H0z"
                                            ]
                                            []
                                        ]
                                    ]
                                ]
                            , Html.div
                                [ Attrs.class "hidden h-6 text-2xl font-semibold sm:block dark:text-white"
                                ]
                                [ Html.text title ]
                            ]
                        ]
                    ]
                , Html.div
                    [ Attrs.class "flex items-center leading-5 space-x-4 sm:space-x-6"
                    ]
                    [ Html.a
                        [ Attrs.class "hidden sm:block font-medium text-gray-900 dark:text-gray-100"
                        , Attrs.href "/blog"
                        ]
                        [ Html.text "Blog" ]
                    , Html.a
                        [ Attrs.class "hidden sm:block font-medium text-gray-900 dark:text-gray-100"
                        , Attrs.href "/tags"
                        ]
                        [ Html.text "Tags" ]
                    , Html.a
                        [ Attrs.class "hidden sm:block font-medium text-gray-900 dark:text-gray-100"
                        , Attrs.href "/projects"
                        ]
                        [ Html.text "Projects" ]
                    , Html.a
                        [ Attrs.class "hidden sm:block font-medium text-gray-900 dark:text-gray-100"
                        , Attrs.href "/about"
                        ]
                        [ Html.text "About" ]
                    , Html.button
                        [ Attrs.attribute "aria-label" "Toggle Menu"
                        , Attrs.class "sm:hidden"
                        , Events.onClick MenuClicked
                        ]
                        [ Svg.svg
                            [ SvgAttrs.viewBox "0 0 20 20"
                            , SvgAttrs.fill "currentColor"
                            , SvgAttrs.class "text-gray-900 dark:text-gray-100 h-8 w-8"
                            ]
                            [ Svg.path
                                [ SvgAttrs.fillRule "evenodd"
                                , SvgAttrs.d "M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                                , SvgAttrs.clipRule "evenodd"
                                ]
                                []
                            ]
                        ]
                    , Html.div
                        [ Attrs.class "fixed left-0 top-0 z-10 h-full w-full transform opacity-95 dark:opacity-[0.98] bg-white duration-300 ease-in-out dark:bg-gray-950"
                        , Attrs.classList
                            [ ( "translate-x-0", model.showMenu )
                            , ( "translate-x-full", not model.showMenu )
                            ]
                        ]
                        [ Html.div
                            [ Attrs.class "flex justify-end"
                            ]
                            [ Html.button
                                [ Attrs.class "mr-8 mt-11 h-8 w-8"
                                , Attrs.attribute "aria-label" "Toggle Menu"
                                , Events.onClick MenuClicked
                                ]
                                [ Svg.svg
                                    [ SvgAttrs.viewBox "0 0 20 20"
                                    , SvgAttrs.fill "currentColor"
                                    , SvgAttrs.class "text-gray-900 dark:text-gray-100"
                                    ]
                                    [ Svg.path
                                        [ SvgAttrs.fillRule "evenodd"
                                        , SvgAttrs.d "M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                        , SvgAttrs.clipRule "evenodd"
                                        ]
                                        []
                                    ]
                                ]
                            ]
                        , Html.nav
                            [ Attrs.class "fixed mt-8 h-full"
                            ]
                            [ Html.div
                                [ Attrs.class "px-12 py-4"
                                ]
                                [ Html.a
                                    [ Attrs.class "text-2xl font-bold tracking-widest text-gray-900 dark:text-gray-100"
                                    , Attrs.href "/"
                                    ]
                                    [ Html.text "Home" ]
                                ]
                            , Html.div
                                [ Attrs.class "px-12 py-4"
                                ]
                                [ Html.a
                                    [ Attrs.class "text-2xl font-bold tracking-widest text-gray-900 dark:text-gray-100"
                                    , Attrs.href "/blog"
                                    ]
                                    [ Html.text "Blog" ]
                                ]
                            , Html.div
                                [ Attrs.class "px-12 py-4"
                                ]
                                [ Html.a
                                    [ Attrs.class "text-2xl font-bold tracking-widest text-gray-900 dark:text-gray-100"
                                    , Attrs.href "/tags"
                                    ]
                                    [ Html.text "Tags" ]
                                ]
                            , Html.div
                                [ Attrs.class "px-12 py-4"
                                ]
                                [ Html.a
                                    [ Attrs.class "text-2xl font-bold tracking-widest text-gray-900 dark:text-gray-100"
                                    , Attrs.href "/projects"
                                    ]
                                    [ Html.text "Projects" ]
                                ]
                            , Html.div
                                [ Attrs.class "px-12 py-4"
                                ]
                                [ Html.a
                                    [ Attrs.class "text-2xl font-bold tracking-widest text-gray-900 dark:text-gray-100"
                                    , Attrs.href "/about"
                                    ]
                                    [ Html.text "About" ]
                                ]
                            ]
                        ]
                    ]
                    |> Html.map toMsg
                ]
            , Html.main_ [ Attrs.class "prose prose-slate dark:prose-invert" ] pageView.body
            ]
        ]
    , title = pageView.title
    }
