module Content.BlogpostCommon exposing
    ( Blogpost
    , Category(..)
    , Metadata
    , Status(..)
    , TagWithCount
    , decodeStatus
    , getLastModified
    , getPublishedDate
    , metadataDecoder
    )

import Content.About exposing (Author)
import Date exposing (Date)
import DateOrDateTime exposing (DateOrDateTime)
import Dict exposing (Dict)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import String.Normalize
import Time


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
    | PublishedAndUpdatedWithDate Date Date


type alias Metadata =
    { title : String
    , slug : String
    , image : Maybe String
    , description : Maybe String
    , category : Category
    , tags : List String
    , authors : List Author
    , status : Status
    , publishedAt : Maybe DateOrDateTime
    , updatedAt : Maybe DateOrDateTime
    , readingTimeInMin : Int
    }


type Category
    = Tech
    | Life
    | Unknown


type alias TagWithCount =
    { slug : String, title : String, count : Int }


decodeCategory : Decoder Category
decodeCategory =
    Decode.field "category" Decode.string
        |> Decode.andThen
            (\categoryString ->
                case categoryString of
                    "tech" ->
                        Decode.succeed Tech

                    "life" ->
                        Decode.succeed Life

                    _ ->
                        Decode.succeed Unknown
            )


decodeStatus : Decoder Status
decodeStatus =
    Decode.map3
        (\publishedDate updatedDate statusString ->
            case ( statusString, publishedDate, updatedDate ) of
                ( Just "draft", _, _ ) ->
                    Draft

                ( _, Just date, Nothing ) ->
                    PublishedWithDate date

                ( _, Just date1, Just date2 ) ->
                    PublishedAndUpdatedWithDate date1 date2

                _ ->
                    Published
        )
        (Decode.maybe (Decode.field "published" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string)))
        (Decode.maybe (Decode.field "updated" (Decode.map (Result.withDefault (Date.fromRataDie 1) << Date.fromIsoString) Decode.string)))
        (Decode.maybe (Decode.field "status" Decode.string))


dateOrDateTimeDecoder : Decoder DateOrDateTime
dateOrDateTimeDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case Date.fromIsoString str of
                    Ok date ->
                        Decode.succeed (DateOrDateTime.Date date)

                    Err _ ->
                        Decode.fail "Invalid date format"
            )


metadataDecoder : Dict String Author -> String -> Decoder Metadata
metadataDecoder authorsDict slug =
    Decode.succeed Metadata
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault slug >> String.Normalize.slug)
                (Decode.maybe (Decode.field "slug" Decode.string))
            )
        |> Decode.andMap (Decode.maybe (Decode.field "image" Decode.string))
        |> Decode.andMap (Decode.maybe (Decode.field "description" Decode.string))
        |> Decode.andMap decodeCategory
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault [])
                (Decode.maybe (Decode.field "tags" <| Decode.list Decode.string))
            )
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault [ "default" ])
                (Decode.maybe (Decode.field "authors" <| Decode.list Decode.string))
                |> Decode.map (\authors -> List.filterMap (\authorSlug -> Dict.get authorSlug authorsDict) authors)
            )
        |> Decode.andMap decodeStatus
        |> Decode.andMap (Decode.maybe (Decode.field "published" dateOrDateTimeDecoder))
        |> Decode.andMap (Decode.maybe (Decode.field "updated" dateOrDateTimeDecoder))
        |> Decode.andMap (Decode.succeed 1)


getPublishedDate : Metadata -> Date
getPublishedDate { status } =
    case status of
        PublishedWithDate date ->
            date

        _ ->
            Date.fromRataDie 1


getLastModified : Metadata -> Time.Posix
getLastModified metadata =
    case metadata.updatedAt of
        Just updatedAt ->
            Iso8601.toTime (DateOrDateTime.toIso8601 updatedAt)
                |> Result.withDefault
                    (case metadata.publishedAt of
                        Just publishedAt ->
                            Iso8601.toTime (DateOrDateTime.toIso8601 publishedAt)
                                |> Result.withDefault (Time.millisToPosix 0)

                        Nothing ->
                            Time.millisToPosix 0
                    )

        Nothing ->
            case metadata.publishedAt of
                Just publishedAt ->
                    Iso8601.toTime (DateOrDateTime.toIso8601 publishedAt)
                        |> Result.withDefault (Time.millisToPosix 0)

                Nothing ->
                    Time.millisToPosix 0
