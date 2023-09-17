module Layout.Markdown exposing (toHtml)

import Html exposing (Html)
import Html.Attributes as Attrs
import Markdown.Parser
import Markdown.Renderer exposing (defaultHtmlRenderer)
import SyntaxHighlight


language lang =
    case lang of
        Just "elm" ->
            SyntaxHighlight.elm

        _ ->
            SyntaxHighlight.noLang


syntaxHighlight codeBlock =
    Html.div [ Attrs.class "no-prose" ]
        [ SyntaxHighlight.useTheme SyntaxHighlight.oneDark
        , language codeBlock.language codeBlock.body
            |> Result.map (SyntaxHighlight.toBlockHtml (Just 1))
            |> Result.withDefault
                (Html.pre [] [ Html.code [] [ Html.text codeBlock.body ] ])
        ]


renderer =
    { defaultHtmlRenderer
        | codeBlock =
            \block ->
                syntaxHighlight block
    }


toHtml :
    String
    -> List (Html msg)
toHtml markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    renderer
                    blocks
            )
        |> Result.withDefault [ Html.text "failed to read markdown" ]
