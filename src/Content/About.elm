module Content.About exposing (Author, defaultAuthor)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import FatalError exposing (FatalError)
import Json.Decode as Decode


type alias Author =
    { body : String
    , name : String
    , socials : List ( String, String )
    , occupation : Maybe String
    , company : Maybe String
    }


authorDecoder : String -> Decode.Decoder Author
authorDecoder body =
    Decode.map4 (Author body)
        (Decode.field "name" Decode.string)
        (Decode.map (Maybe.withDefault []) <| Decode.maybe <| Decode.field "socials" <| Decode.keyValuePairs Decode.string)
        (Decode.maybe <| Decode.field "occupation" Decode.string)
        (Decode.maybe <| Decode.field "company" Decode.string)


defaultAuthor : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } Author
defaultAuthor =
    File.bodyWithFrontmatter authorDecoder "/content/authors/default.md"
