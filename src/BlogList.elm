module BlogList exposing (view)

import BackendTask
import BackendTask.File exposing (FileReadError)
import Blogpost exposing (Metadata, viewBlogpost)
import Browser.Dom exposing (Error)
import Date exposing (Date)
import Dict
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Attributes as Attrs
import List.Extra
import Route
import String.Normalize
import Tags


viewPublishedDate date =
    Html.dl []
        [ Html.dt
            [ Attrs.class "sr-only"
            ]
            [ Html.text "Published on" ]
        , Html.dd
            [ Attrs.class "text-base font-medium leading-6 text-gray-500 dark:text-gray-400"
            ]
            [ Html.time
                [ Attrs.datetime <| Date.toIsoString date
                ]
                [ Html.text <| Date.format "d. MMM YYYY" date ]
            ]
        ]


viewBlogpostMetadata metadata =
    Html.article
        [ Attrs.class "space-y-2 flex flex-col xl:space-y-0"
        ]
        [ viewPublishedDate metadata.publishedDate
        , Html.div
            [ Attrs.class "space-y-3"
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
                    List.map Tags.viewTag metadata.tags
                ]
            , Html.div
                [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                ]
                [ Html.text metadata.description ]
            ]
        ]


view : List Tags.Tag -> List Blogpost.Metadata -> Maybe Tags.Tag -> List (Html msg)
view tags metadata selectedTag =
    let
        header =
            case selectedTag of
                Just tag ->
                    Html.h1
                        [ Attrs.class "sm:hidden text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                        ]
                        [ Html.text <| tag.title ]

                Nothing ->
                    Html.h1
                        [ Attrs.class "sm:hidden text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                        ]
                        [ Html.text "All Posts" ]

        allPostsLink =
            case selectedTag of
                Just _ ->
                    Route.Blog
                        |> Route.link
                            []
                            [ Html.h3
                                [ Attrs.class "text-gray-900 dark:text-gray-100 hover:text-primary-500 font-bold uppercase"
                                ]
                                [ Html.text "All Posts" ]
                            ]

                Nothing ->
                    Html.h3
                        [ Attrs.class "text-primary-500 font-bold uppercase"
                        ]
                        [ Html.text "All Posts" ]
    in
    [ Html.div [ Attrs.class "pb-6 pt-6" ] [ header ]
    , Html.div [ Attrs.class "flex sm:space-x-24" ]
        [ Html.div [ Attrs.class "hidden max-h-screen h-full sm:flex flex-wrap bg-gray-50 dark:bg-gray-900/70 shadow-md pt-5 dark:shadow-gray-800/40 rounded min-w-[280px] max-w-[280px] overflow-auto" ]
            [ Html.div
                [ Attrs.class "py-4 px-6"
                ]
                [ allPostsLink
                , Html.ul [] <|
                    List.map
                        (\tag ->
                            Html.li
                                [ Attrs.class "my-3"
                                ]
                                [ Route.Tags__Slug_ { slug = tag.slug }
                                    |> Route.link
                                        [ Attrs.class "py-2 px-3 uppercase text-sm font-medium text-gray-500 dark:text-gray-300 hover:text-primary-500 dark:hover:text-primary-500"
                                        , Attrs.classList [ ( "text-primary-500 dark:text-primary-500", Just tag.slug == Maybe.map .slug selectedTag ) ]
                                        , Attrs.attribute "aria-label" <| "View posts tagged " ++ tag.title
                                        ]
                                        [ Html.text <| tag.title ++ " (" ++ String.fromInt tag.count ++ ")" ]
                                ]
                        )
                        tags
                ]
            ]
        , Html.div [] [ Html.ul [] <| List.map (\article -> Html.li [ Attrs.class "py-5" ] [ viewBlogpostMetadata article ]) metadata ]
        ]
    ]
