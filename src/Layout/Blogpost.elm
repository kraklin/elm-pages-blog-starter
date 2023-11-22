module Layout.Blogpost exposing
    ( viewBlogpost
    , viewListItem
    , viewPostList
    )

import Content.Blogpost exposing (Blogpost, Metadata, Status(..), TagWithCount)
import Date
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Layout.Tags
import Route



-- VIEW


authorImages : List { a | image : String } -> Html msg
authorImages authors =
    List.map
        (\{ image } ->
            Html.img
                [ Attrs.alt "avatar"
                , Attrs.attribute "loading" "lazy"
                , Attrs.width 38
                , Attrs.height 38
                , Attrs.attribute "decoding" "async"
                , Attrs.attribute "data-nimg" "1"
                , Attrs.class "h-12 w-12 rounded-full hidden sm:block"
                , Attrs.style "color" "transparent"
                , Attrs.src image
                ]
                []
        )
        authors
        |> Html.div [ Attrs.class "flex -space-x-2" ]


viewBlogpost : Blogpost -> Html msg
viewBlogpost { metadata, body, previousPost, nextPost } =
    let
        blogpostAuthors =
            metadata.authors
                |> List.map
                    (\author ->
                        { name = author.name
                        , image = author.avatar |> Maybe.withDefault "/images/authors/default.png"
                        }
                    )

        bottomLink slug title =
            Route.link
                [ Attrs.class "text-primary-700 dark:text-primary-500 hover:text-primary-600 dark:hover:text-primary-400" ]
                [ Html.text title ]
                (Route.Blog__Slug_ { slug = slug })

        previous =
            previousPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "sm:col-start-1 flex flex-col mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Older post" ]
                            , "← " ++ title |> bottomLink slug
                            ]
                    )

        next =
            nextPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "sm:col-start-2 flex flex-col sm:text-right mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Newer post" ]
                            , title ++ " →" |> bottomLink slug
                            ]
                    )

        authorsView =
            Html.dl
                [ Attrs.class "max-w-[65ch] py-4 xl:pb-8 xl:pt-12"
                ]
                [ Html.dt
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text "Authors" ]
                , Html.dd [ Attrs.class "border-l-4 border-primary-500 pl-4 flex" ]
                    [ authorImages blogpostAuthors
                    , Html.div [ Attrs.class "flex flex-col justify-around items-start sm:pl-4" ]
                        [ Html.span [ Attrs.class "text-lg font-bold text-black dark:text-white" ] [ Html.text <| String.join ", " <| List.map .name blogpostAuthors ]
                        , Html.div [ Attrs.class "flex space-x-4 text-base" ]
                            [ viewPublishedDate metadata.status
                            , Html.span []
                                [ Html.text <| String.fromInt metadata.readingTimeInMin
                                , Html.text " min reading time"
                                ]
                            ]
                        ]
                    ]
                ]

        header =
            Html.div
                [ Attrs.class "max-w-[65ch] m-auto space-y-1 xl:text-xl dark:border-gray-700"
                ]
                [ Html.div
                    []
                    [ Html.h1 [ Attrs.class "mt-8 pb-4 font-bold text-3xl md:text-5xl text-gray-900 dark:text-gray-100" ]
                        [ Html.text metadata.title
                        ]
                    , authorsView
                    ]
                , Html.Extra.viewMaybe
                    (\imagePath ->
                        Html.div
                            [ Attrs.class "w-full"
                            ]
                            [ Html.div
                                [ Attrs.class "relative mt-6 -mx-6 md:-mx-8 2xl:-mx-24"
                                ]
                                [ Html.div
                                    [ Attrs.class "aspect-[2/1] w-full relative"
                                    ]
                                    [ Html.img
                                        [ Attrs.alt metadata.title
                                        , Attrs.attribute "loading" "lazy"
                                        , Attrs.attribute "decoding" "async"
                                        , Attrs.attribute "data-nimg" "fill"
                                        , Attrs.class "object-cover"
                                        , Attrs.attribute "sizes" "100vw"
                                        , Attrs.style "position" "absolute"
                                        , Attrs.style "height" "100%"
                                        , Attrs.style "width" "100%"
                                        , Attrs.style "inset" "0px"
                                        , Attrs.style "color" "transparent"
                                        , Attrs.src imagePath
                                        ]
                                        []
                                    ]
                                ]
                            ]
                    )
                    metadata.image
                ]
    in
    Html.div []
        [ header
        , Html.Extra.viewMaybe
            (\description ->
                Html.div
                    [ Attrs.class "mx-auto prose-p:my-4 prose lg:prose-xl dark:prose-invert" ]
                    [ Html.p [ Attrs.class "font-bold" ] [ Html.text description ] ]
            )
            metadata.description
        , Html.article
            [ Attrs.class "mx-auto prose lg:prose-xl dark:prose-invert" ]
            (Markdown.blogpostToHtml body)
        , Html.div
            [ Attrs.class "mt-8 border-t grid grid-cols-1 text-sm font-medium sm:grid-cols-2 sm:text-base" ]
            [ previous, next ]
        ]


viewPublishedDate : Status -> Html msg
viewPublishedDate status =
    case status of
        Draft ->
            Html.span
                [ Attrs.class "leading-6 text-gray-500 dark:text-gray-400"
                ]
                [ Html.text "Draft"
                ]

        PublishedWithDate date ->
            Html.dl []
                [ Html.dt
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text "Published on" ]
                , Html.dd
                    [ Attrs.class "leading-6 text-gray-500 dark:text-gray-400"
                    ]
                    [ Html.time
                        [ Attrs.datetime <| Date.toIsoString date
                        ]
                        [ Html.text <| Date.format "d. MMM YYYY" date ]
                    ]
                ]

        Published ->
            Html.Extra.nothing


viewBlogpostMetadata : Metadata -> Html msg
viewBlogpostMetadata metadata =
    Html.article
        [ Attrs.class "space-y-2 flex flex-col xl:space-y-0"
        ]
        [ viewPublishedDate metadata.status
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
            , Html.Extra.viewMaybe
                (\description ->
                    Html.div
                        [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                        ]
                        [ Html.text description ]
                )
                metadata.description
            ]
        ]


viewListItem : Metadata -> Html.Html msg
viewListItem metadata =
    Html.article [ Attrs.class "my-12" ]
        [ Html.div
            [ Attrs.class "space-y-2 xl:grid xl:grid-cols-4 xl:items-baseline xl:space-y-0"
            ]
            [ viewPublishedDate metadata.status
            , Html.div
                [ Attrs.class "space-y-5 xl:col-span-3"
                ]
                [ Html.div
                    [ Attrs.class "space-y-6"
                    ]
                    [ Html.div [ Attrs.class "space-y-4 xl:space-y-2" ]
                        [ Html.h2
                            [ Attrs.class "text-2xl font-bold leading-8 tracking-tight"
                            ]
                            [ Route.Blog__Slug_ { slug = metadata.slug }
                                |> Route.link
                                    [ Attrs.class "text-gray-900 hover:underline decoration-primary-600 dark:text-gray-100"
                                    ]
                                    [ Html.text metadata.title ]
                            ]
                        , Html.Extra.viewIf (not <| List.isEmpty metadata.tags)
                            (Html.div [ Attrs.class "flex flex-wrap space-x-4 xl:space-x-2" ]
                                (List.map Layout.Tags.viewTag metadata.tags)
                            )
                        ]
                    , Html.Extra.viewMaybe
                        (\description ->
                            Html.div
                                [ Attrs.class "prose max-w-none text-gray-500 dark:text-gray-400"
                                ]
                                [ Html.text description ]
                        )
                        metadata.description
                    ]
                , Html.div
                    [ Attrs.class "text-base font-medium leading-6"
                    ]
                    [ Route.Blog__Slug_ { slug = metadata.slug }
                        |> Route.link
                            [ Attrs.class "text-primary-700 dark:text-primary-500 hover:text-primary-600 dark:hover:text-primary-400"
                            , Attrs.attribute "aria-label" ("Read more about \"" ++ metadata.title ++ "\"")
                            ]
                            [ Html.text "Read more →" ]
                    ]
                ]
            ]
        ]


viewPostList : List TagWithCount -> List Metadata -> Maybe TagWithCount -> List (Html msg)
viewPostList tags metadata selectedTag =
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
                        [ Attrs.class "text-primary-700 dark:text-primary-500 font-bold uppercase"
                        ]
                        [ Html.text "All Posts" ]
    in
    [ Html.div [ Attrs.class "pb-6 pt-6" ] [ header ]
    , Html.div [ Attrs.class "flex sm:space-x-2 md:space-x-12" ]
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
                                        , Attrs.classList [ ( "text-primary-700 dark:text-primary-500", Just tag.slug == Maybe.map .slug selectedTag ) ]
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
