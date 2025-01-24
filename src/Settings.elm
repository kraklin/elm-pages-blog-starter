module Settings exposing
    ( author
    , basePath
    , canonicalUrl
    , copyrightYear
    , domain
    , locale
    , subtitle
    , title
    , xId
    )

import LanguageTag.Language as Language
import LanguageTag.Region as Region


domain : String
domain =
    "hahnah.github.io"



{-
   NOTE: basePath except "/" doesn't work for GitHub Pages hosting, because of elm-pages bug.
     SEE: https://github.com/dillonkearns/elm-pages/issues/404
   NOTE: If you set basePath, you need to set --base option in "elm-pages dev" and "elm-pages build" commands.
-}


basePath : String
basePath =
    "/"


canonicalUrl : String
canonicalUrl =
    "https://" ++ domain ++ basePath


locale : Maybe ( Language.Language, Region.Region )
locale =
    Just ( Language.en, Region.us )


title : String
title =
    "Hahnah's elm-pages Blog Template"


subtitle : String
subtitle =
    "A blog template created with elm-pages and TailwindCSS by Hahnah (Natsuki Harai)."


author : String
author =
    "Hahnah"


copyrightYear : String
copyrightYear =
    "2025"


xId : Maybe String
xId =
    -- or like Just "@superhahnah"
    Nothing
