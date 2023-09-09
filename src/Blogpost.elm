module Blogpost exposing (Blogpost, Metadata, viewListItem)

import Date exposing (Date)
import Html
import Html.Attributes as Attrs
import Route


type alias Blogpost =
    { metadata : Metadata
    , body : String
    }


type alias Metadata =
    { title : String
    , publishedDate : Date
    , slug : String
    , description : String
    , tags : List String
    }


viewTag tag =
    Html.a
        [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
        , Attrs.href ""
        ]
        [ Html.text tag ]


viewListItem metadata =
    Html.article [ Attrs.class "my-12" ]
        [ Html.div
            [ Attrs.class "space-y-2 xl:grid xl:grid-cols-4 xl:items-baseline xl:space-y-0"
            ]
            [ Html.dl []
                [ Html.dt
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text "Published on" ]
                , Html.dd
                    [ Attrs.class "text-base font-medium leading-6 text-gray-500 dark:text-gray-400"
                    ]
                    [ Html.time
                        [ Attrs.datetime <| Date.toIsoString metadata.publishedDate
                        ]
                        [ Html.text <| Date.format "d MMMM YYYY" metadata.publishedDate ]
                    ]
                ]
            , Html.div
                [ Attrs.class "space-y-5 xl:col-span-3"
                ]
                [ Html.div
                    [ Attrs.class "space-y-6"
                    ]
                    [ Html.div []
                        [ Html.h2
                            [ Attrs.class "text-2xl font-bold leading-8 tracking-tight"
                            ]
                            [ Route.Blog__Slug_ { slug = metadata.slug }
                                |> Route.link
                                    [ Attrs.class "text-gray-900 hover:underline decoration-primary-600 dark:text-gray-100"
                                    ]
                                    [ Html.text metadata.title ]
                            ]
                        , Html.div
                            [ Attrs.class "flex flex-wrap"
                            ]
                          <|
                            List.map viewTag metadata.tags
                        ]
                    , Html.div
                        [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                        ]
                        [ Html.text metadata.description ]
                    ]
                , Html.div
                    [ Attrs.class "text-base font-medium leading-6"
                    ]
                    [ Route.Blog__Slug_ { slug = metadata.slug }
                        |> Route.link
                            [ Attrs.class "text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                            , Attrs.attribute "aria-label" ("Read \"" ++ metadata.title ++ "\"")
                            ]
                            [ Html.text "Read more ->" ]
                    ]
                ]
            ]
        ]
