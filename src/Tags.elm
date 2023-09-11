module Tags exposing (Tag, allTags, view, viewTag)

import BackendTask exposing (BackendTask)
import BackendTask.File exposing (FileReadError)
import Blogpost
import Browser.Dom exposing (Error)
import Dict
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Attributes as Attrs
import Json.Decode as Decode
import List.Extra
import String.Normalize


type alias Tag =
    { slug : String, title : String, count : Int }


allTags : BackendTask { fatal : FatalError, recoverable : FileReadError Decode.Error } (List Tag)
allTags =
    Blogpost.allMetadata
        |> BackendTask.map
            (\metadata ->
                metadata
                    |> List.concatMap .tags
                    |> List.map (\tag -> ( String.Normalize.slug tag, tag ))
                    |> (\tags ->
                            ( Dict.fromList tags
                            , tags
                                |> List.map Tuple.first
                                |> List.Extra.frequencies
                                |> List.map (\( slug, frequency ) -> { slug = slug, count = frequency })
                            )
                       )
                    |> (\( names, slugCount ) ->
                            List.map
                                (\{ slug, count } ->
                                    { slug = slug
                                    , count = count
                                    , title = Dict.get slug names |> Maybe.withDefault slug
                                    }
                                )
                                slugCount
                       )
            )


viewTagWithCount : Tag -> Html msg
viewTagWithCount { slug, title, count } =
    Html.div
        [ Attrs.class "mb-2 mr-5 mt-2"
        ]
        [ Html.a
            [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
            , Attrs.href slug
            ]
            [ Html.text title ]
        , Html.a
            [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
            , Attrs.attribute "aria-label" ("View posts tagged " ++ title)
            , Attrs.href slug
            ]
            [ Html.text <| "(" ++ String.fromInt count ++ ")" ]
        ]


viewTag : String -> Html msg
viewTag slug =
    Html.a
        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
        , Attrs.href ""
        ]
        [ Html.text slug ]


view : List Tag -> Html msg
view tags =
    Html.main_
        [ Attrs.class "mb-auto"
        ]
        [ Html.div
            [ Attrs.class "flex flex-col items-start justify-start divide-y divide-gray-200 dark:divide-gray-700 md:mt-24 md:flex-row md:items-center md:justify-center md:space-x-6 md:divide-y-0"
            ]
            [ Html.div
                [ Attrs.class "space-x-2 pb-8 pt-6 md:space-y-5"
                ]
                [ Html.h1
                    [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:border-r-2 md:px-6 md:text-6xl md:leading-14"
                    ]
                    [ Html.text "Tags" ]
                ]
            , Html.div
                [ Attrs.class "flex max-w-lg flex-wrap"
                ]
              <|
                List.map viewTagWithCount tags
            ]
        ]
