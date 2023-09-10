module Tags exposing (view)

import Html exposing (Html)
import Html.Attributes as Attrs


view : Html msg
view =
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
                [ Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/next-js"
                        ]
                        [ Html.text "next-js" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged next-js"
                        , Attrs.href "/tags/next-js"
                        ]
                        [ Html.text "(6)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/guide"
                        ]
                        [ Html.text "guide" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged guide"
                        , Attrs.href "/tags/guide"
                        ]
                        [ Html.text "(5)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/tailwind"
                        ]
                        [ Html.text "tailwind" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged tailwind"
                        , Attrs.href "/tags/tailwind"
                        ]
                        [ Html.text "(3)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/feature"
                        ]
                        [ Html.text "feature" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged feature"
                        , Attrs.href "/tags/feature"
                        ]
                        [ Html.text "(2)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/markdown"
                        ]
                        [ Html.text "markdown" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged markdown"
                        , Attrs.href "/tags/markdown"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/code"
                        ]
                        [ Html.text "code" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged code"
                        , Attrs.href "/tags/code"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/features"
                        ]
                        [ Html.text "features" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged features"
                        , Attrs.href "/tags/features"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/math"
                        ]
                        [ Html.text "math" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged math"
                        , Attrs.href "/tags/math"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/ols"
                        ]
                        [ Html.text "ols" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged ols"
                        , Attrs.href "/tags/ols"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/github"
                        ]
                        [ Html.text "github" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged github"
                        , Attrs.href "/tags/github"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/holiday"
                        ]
                        [ Html.text "holiday" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged holiday"
                        , Attrs.href "/tags/holiday"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/canada"
                        ]
                        [ Html.text "canada" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged canada"
                        , Attrs.href "/tags/canada"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/images"
                        ]
                        [ Html.text "images" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged images"
                        , Attrs.href "/tags/images"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/writings"
                        ]
                        [ Html.text "writings" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged writings"
                        , Attrs.href "/tags/writings"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/book"
                        ]
                        [ Html.text "book" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged book"
                        , Attrs.href "/tags/book"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/reflection"
                        ]
                        [ Html.text "reflection" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged reflection"
                        , Attrs.href "/tags/reflection"
                        ]
                        [ Html.text "(1)" ]
                    ]
                , Html.div
                    [ Attrs.class "mb-2 mr-5 mt-2"
                    ]
                    [ Html.a
                        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                        , Attrs.href "/tags/multi-author"
                        ]
                        [ Html.text "multi-author" ]
                    , Html.a
                        [ Attrs.class "-ml-2 text-sm font-semibold uppercase text-gray-600 dark:text-gray-300"
                        , Attrs.attribute "aria-label" "View posts tagged multi-author"
                        , Attrs.href "/tags/multi-author"
                        ]
                        [ Html.text "(1)" ]
                    ]
                ]
            ]
        ]
