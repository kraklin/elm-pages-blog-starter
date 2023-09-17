module Layout.Blogpost exposing
    ( viewBlogpost
    , viewListItem
    , viewPublishedDate
    , viewTag
    )

import Blogpost exposing (Blogpost, Metadata)
import Date
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Layout.Tags
import Route
import String.Normalize



-- VIEW


viewBlogpost : Blogpost -> Html msg
viewBlogpost { metadata, body, previousPost, nextPost } =
    let
        bottomLink slug title =
            Route.link
                [ Attrs.class "text-primary-500 hover:text-primary-600 dark:hover:text-primary-400" ]
                [ Html.text title ]
                (Route.Blog__Slug_ { slug = slug })

        previous =
            previousPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "flex flex-col mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Newer post" ]
                            , "← " ++ title |> bottomLink slug
                            ]
                    )

        next =
            nextPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "flex flex-col sm:text-right mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Older post" ]
                            , title ++ " →" |> bottomLink slug
                            ]
                    )
    in
    Html.div []
        [ Html.h1 [ Attrs.class "my-16 pb-8 font-bold text-center border-b text-5xl text-gray-900 dark:text-gray-100" ]
            [ Html.div [] [ viewPublishedDate metadata.publishedDate ]
            , Html.text metadata.title
            ]
        , Html.div
            [ Attrs.class "mx-auto prose-p:my-4 prose lg:prose-xl dark:prose-invert" ]
            [ Html.p [ Attrs.class "font-bold" ] [ Html.text metadata.description ] ]
        , Html.div
            [ Attrs.class "mx-auto prose lg:prose-xl dark:prose-invert" ]
            (Markdown.toHtml body)
        , Html.div
            [ Attrs.class "mt-8 border-t flex flex-col text-sm font-medium sm:flex-row sm:justify-between sm:text-base" ]
            [ previous, next ]
        ]


viewPublishedDate : Date.Date -> Html msg
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


viewTag : String -> Html msg
viewTag slug =
    Route.Tags__Slug_ { slug = String.Normalize.slug slug }
        |> Route.link
            [ Attrs.class "mr-3 text-sm font-medium uppercase text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
            ]
            [ Html.text slug ]


viewListItem : Metadata -> Html.Html msg
viewListItem metadata =
    Html.article [ Attrs.class "my-12" ]
        [ Html.div
            [ Attrs.class "space-y-2 xl:grid xl:grid-cols-4 xl:items-baseline xl:space-y-0"
            ]
            [ viewPublishedDate metadata.publishedDate
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
                            [ Html.text "Read more →" ]
                    ]
                ]
            ]
        ]


viewBlogpostMetadata : Metadata -> Html msg
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
                    List.map Layout.Tags.viewTag metadata.tags
                ]
            , Html.div
                [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                ]
                [ Html.text metadata.description ]
            ]
        ]
