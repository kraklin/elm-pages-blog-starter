module Layout.Index exposing (view)

import Content.BlogpostCommon exposing (Metadata)
import Html exposing (Html)
import Html.Attributes as Attrs
import Layout.Blogpost
import Settings


view : List Metadata -> List (Html msg)
view blogpostMetadata =
    [ Html.div [ Attrs.class "space-y-2 pb-8 pt-6 md:space-y-5" ]
        [ Html.h1 [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14" ] [ Html.text "Latest" ]
        , Html.p [ Attrs.class "text-lg leading-7 text-gray-500 dark:text-gray-400" ] [ Html.text Settings.subtitle ]
        ]
    , Html.div [] <| List.map Layout.Blogpost.viewListItem blogpostMetadata
    ]
