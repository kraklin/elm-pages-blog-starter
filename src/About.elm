module About exposing (Author, defaultAuthor, view)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import FontAwesome
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Json.Decode as Decode
import Markdown.Parser
import Markdown.Renderer
import Phosphor
import Svg
import Svg.Attributes as SvgAttrs


type alias Author =
    { body : String
    , name : String
    , socials : List ( String, String )
    , occupation : Maybe String
    , company : Maybe String
    }


authorDecoder : String -> Decode.Decoder Author
authorDecoder body =
    Decode.map4 (Author body)
        (Decode.field "name" Decode.string)
        (Decode.map (Maybe.withDefault []) <| Decode.maybe <| Decode.field "socials" <| Decode.keyValuePairs Decode.string)
        (Decode.maybe <| Decode.field "occupation" Decode.string)
        (Decode.maybe <| Decode.field "company" Decode.string)


defaultAuthor : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } Author
defaultAuthor =
    File.bodyWithFrontmatter authorDecoder "/content/authors/default.md"


markdownToView :
    String
    -> List (Html msg)
markdownToView markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    Markdown.Renderer.defaultHtmlRenderer
                    blocks
            )
        |> Result.withDefault [ Html.text "failed to read markdown" ]


socialsView socials =
    let
        icon socialName =
            case socialName of
                "email" ->
                    Phosphor.envelopeSimple Phosphor.Fill

                "facebook" ->
                    Phosphor.facebookLogo Phosphor.Fill

                "github" ->
                    Phosphor.githubLogo Phosphor.Fill

                "twitter" ->
                    Phosphor.twitterLogo Phosphor.Fill

                "linkedin" ->
                    Phosphor.linkedinLogo Phosphor.Fill

                _ ->
                    Phosphor.link Phosphor.Fill

        socialView ( name, link ) =
            Html.a
                [ Attrs.class "text-sm text-gray-500 transition hover:text-gray-600"
                , Attrs.target "_blank"
                , Attrs.rel "noopener noreferrer"
                , Attrs.href link
                ]
                [ Html.span
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text name ]
                , icon name
                    |> Phosphor.withClass "fill-current text-gray-700 hover:text-primary-500 dark:text-gray-200 dark:hover:text-primary-400 h-8 w-8"
                    |> Phosphor.toHtml []
                ]
    in
    Html.div
        [ Attrs.class "flex space-x-3 pt-6"
        ]
    <|
        List.map socialView <|
            Debug.log "soc" socials


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
                    , Attrs.src "/images/avatar.png"
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
                markdownToView author.body
            ]
        ]
