module Settings exposing
    ( author
    , canonicalUrl
    , locale
    , subtitle
    , title
    )

import LanguageTag.Country as Country
import LanguageTag.Language as Language


canonicalUrl : String
canonicalUrl =
    "https://elm-pages-blog-template.netlify.com"


locale : Maybe ( Language.Language, Country.Country )
locale =
    Just ( Language.en, Country.us )


title : String
title =
    "elm blog"


subtitle : String
subtitle =
    "A blog starter kit created with elm-pages and TailwindCSS"


author : String
author =
    "Tomas Latal"
