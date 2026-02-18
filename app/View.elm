module View exposing (View, map, freeze, freezableToHtml, htmlToFreezable)

{-|

@docs View, map, freeze, freezableToHtml, htmlToFreezable

-}

import Html exposing (Html)


{-| -}
type alias View msg =
    { title : String
    , body : List (Html msg)
    }


{-| -}
type alias Freezable =
    Html Never


{-| -}
freezableToHtml : Freezable -> Html Never
freezableToHtml =
    identity


{-| -}
htmlToFreezable : Html Never -> Freezable
htmlToFreezable =
    identity


{-| -}
freeze : Freezable -> Html msg
freeze content =
    content
        |> freezableToHtml
        |> htmlToFreezable
        |> Html.map never


{-| -}
map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }
