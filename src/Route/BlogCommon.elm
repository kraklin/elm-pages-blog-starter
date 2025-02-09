module Route.BlogCommon exposing (ActionData, Data, Model, Msg, RouteParams)

import Content.BlogpostCommon exposing (Metadata, TagWithCount)


type alias Model =
    {}


type alias Msg =
    ()


type alias Data =
    { blogposts :
        List Metadata
    , tags : List TagWithCount
    }


type alias ActionData =
    {}


type alias RouteParams =
    {}
