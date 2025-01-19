module Content.BlogpostCommon exposing (Blogpost, Category(..), Metadata, Status(..), TagWithCount)

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
    , category : Category
    , tags : List String
    , authors : List Author
    , status : Status
    , readingTimeInMin : Int
    }


type Category
    = Tech
    | Life
    | Unknown


type alias TagWithCount =
    { slug : String, title : String, count : Int }
