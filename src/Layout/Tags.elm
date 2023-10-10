module Layout.Tags exposing (view, viewTag)

import Content.Blogpost exposing (TagWithCount)
import Html exposing (Html)
import Html.Attributes as Attrs
import Route
import String.Normalize


viewTagWithCount : TagWithCount -> Html msg
viewTagWithCount { slug, title, count } =
    Html.div
        [ Attrs.class "mb-2 mr-5 mt-2"
        ]
        [ Route.Tags__Slug_ { slug = String.Normalize.slug slug }
            |> Route.link
                [ Attrs.class "text-sm font-medium uppercase text-primary-700 dark:text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                , Attrs.attribute "aria-label" ("View posts tagged " ++ title)
                ]
                [ Html.text title
                , Html.span
                    [ Attrs.class "ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                    ]
                    [ Html.text <| "(" ++ String.fromInt count ++ ")" ]
                ]
        ]


viewTag : String -> Html msg
viewTag slug =
    Route.Tags__Slug_ { slug = String.Normalize.slug slug }
        |> Route.link
            [ Attrs.class "text-sm font-medium uppercase text-primary-700 dark:text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
            ]
            [ Html.text slug ]


view : List TagWithCount -> Html msg
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
