---
title: "Post A"
description: "Post A description"
published: "2019-10-01"
updated: "2025-01-23"
category: "tech"
tags:
  - elm
---

This is Post A.

Can show image like this:

![Amonng Us](/content/tech-blog/post-a/assets/among-us.jpg)

## Butonn sample in Elm

Can show code block like this:

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
  Browser.sandbox { init = 0, update = update, view = view }

type Msg = Increment | Decrement

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Can show a link like this:

[elm button example](https://elm-lang.org/examples/buttons).

## P.S.

Nothing. Don't mind.
