module Settings exposing
    ( author
    , canonicalUrl
    , logo
    , subtitle
    , title
    )

import Svg exposing (Svg)
import Svg.Attributes as SvgAttrs


canonicalUrl : String
canonicalUrl =
    "https://github.com"


title : String
title =
    "ElmBlog Template"


subtitle : String
subtitle =
    "A blog created with elm-pages and TailwindCSS"


author : String
author =
    "Tomas Latal"


logo : Svg msg
logo =
    Svg.svg
        [ SvgAttrs.width "80"
        , SvgAttrs.height "80"
        , SvgAttrs.viewBox "0 0 700 351"
        ]
        [ Svg.g
            [ SvgAttrs.fill "text-primary-400"
            , SvgAttrs.fillRule "evenodd"
            ]
            [ Svg.path
                [ SvgAttrs.d "M529.5 169 700 0H359zM349.7 349l79.7-79H270zM266.2 86.5l79 79.7V6.8zM352 180h168l-82 82H270zM175.77 176.5l84.85-84.85 84.85 84.85-84.85 84.85zM353.03 173.3l166.87-1.4L354.44 6.42zM170.5 182 341 351H0z"
                ]
                []
            ]
        ]
