module Layout.About exposing (seoHeaders, view)

import Content.About exposing (Author)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Pages.Url
import Phosphor
import Settings
import UrlPath


seoHeaders : Author -> List Head.Tag
seoHeaders author =
    let
        imageUrl =
            author.avatar
                |> Maybe.map (\authorAvatar -> Pages.Url.fromPath <| UrlPath.fromString authorAvatar)
                |> Maybe.withDefault
                    ([ "media", "blog-image.png" ] |> UrlPath.join |> Pages.Url.fromPath)
    in
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image =
            { url = imageUrl
            , alt = author.name
            , dimensions = Just { width = 300, height = 300 }
            , mimeType = Nothing
            }
        , description = author.name ++ " - " ++ (author.occupation |> Maybe.withDefault ("Author of blogposts on " ++ Settings.title))
        , locale = Settings.locale
        , title = author.name
        }
        |> Seo.website


socialsView : List ( String, String ) -> Html msg
socialsView socials =
    let
        icon socialName =
            case socialName of
                "email" ->
                    Phosphor.envelopeSimple

                "facebook" ->
                    Phosphor.facebookLogo

                "github" ->
                    Phosphor.githubLogo

                "twitter" ->
                    Phosphor.twitterLogo

                "linkedin" ->
                    Phosphor.linkedinLogo

                "youtube" ->
                    Phosphor.youtubeLogo

                "tiktok" ->
                    Phosphor.tiktokLogo

                _ ->
                    Phosphor.link

        socialLink name link =
            if name == "email" then
                "mailto:" ++ link

            else
                link

        socialView ( name, link ) =
            Html.a
                [ Attrs.target "_blank"
                , Attrs.rel "noopener noreferrer"
                , Attrs.href <| socialLink name link
                ]
                [ Html.span
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text name ]
                , icon name Phosphor.Regular
                    |> Phosphor.withClass "fill-current text-gray-500 hover:text-primary-500 dark:text-gray-200 dark:hover:text-primary-400 h-8 w-8"
                    |> Phosphor.toHtml []
                ]
    in
    List.map socialView socials
        |> Html.div
            [ Attrs.class "flex space-x-3 pt-6"
            ]


view : Author -> Html msg
view author =
    Html.div
        [ Attrs.class "divide-y divide-gray-200 dark:divide-gray-700"
        ]
        [ Html.div
            [ Attrs.class "space-y-2 pb-8 pt-6 md:space-y-5"
            ]
            [ Html.h1
                [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                ]
                [ Html.text "About" ]
            ]
        , Html.div
            [ Attrs.class "items-start space-y-2 xl:grid xl:grid-cols-3 xl:gap-x-8 xl:space-y-0"
            ]
            [ Html.div
                [ Attrs.class "flex flex-col items-center space-x-2 pt-8"
                ]
                [ Html.img
                    [ Attrs.alt "avatar"
                    , Attrs.attribute "loading" "lazy"
                    , Attrs.width 192
                    , Attrs.height 192
                    , Attrs.attribute "decoding" "async"
                    , Attrs.attribute "data-nimg" "1"
                    , Attrs.class "h-48 w-48 rounded-full"
                    , Attrs.src "/images/authors/default.png"
                    , Attrs.style "color" "transparent"
                    ]
                    []
                , Html.h3
                    [ Attrs.class "pb-2 pt-4 text-2xl font-bold leading-8 tracking-tight"
                    ]
                    [ Html.text author.name ]
                , Html.Extra.viewMaybe
                    (\occupation ->
                        Html.div
                            [ Attrs.class "text-gray-500 dark:text-gray-400"
                            ]
                            [ Html.text occupation ]
                    )
                    author.occupation
                , Html.Extra.viewMaybe
                    (\company ->
                        Html.div
                            [ Attrs.class "text-gray-500 dark:text-gray-400"
                            ]
                            [ Html.text company ]
                    )
                    author.company
                , socialsView author.socials
                ]
            , Html.div
                [ Attrs.class "prose max-w-none pb-8 pt-8 dark:prose-invert xl:col-span-2"
                ]
              <|
                Markdown.toHtml author.body
            ]
        ]
