module Layout.Markdown exposing (toHtml)

import Html exposing (Html)
import Markdown.Parser
import Markdown.Renderer


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
                    Markdown.Renderer.defaultHtmlRenderer
                    blocks
            )
        |> Result.withDefault [ Html.text "failed to read markdown" ]
