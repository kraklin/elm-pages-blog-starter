module Content.BlogpostCommon exposing (Blogpost, Metadata, Status(..), TagWithCount)

import Content.About exposing (Author)
import Date exposing (Date)


type alias Blogpost =
    { metadata : Metadata
    , body : String
    , previousPost : Maybe Metadata
    , nextPost : Maybe Metadata
    }


type Status
    = Draft
    | Published
    | PublishedWithDate Date


type alias Metadata =
    { title : String
    , slug : String
    , image : Maybe String
    , description : Maybe String
    , tags : List String
    , authors : List Author
    , status : Status
    , readingTimeInMin : Int
    }


type alias TagWithCount =
    { slug : String, title : String, count : Int }
