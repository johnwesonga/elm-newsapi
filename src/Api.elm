module Api exposing (..)

import Json.Decode exposing (int, map2, string, float, nullable, field, list, Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional)
import Http
import Types exposing (..)
import RemoteData exposing (..)


apiUrl : String -> String
apiUrl str =
    "https://newsapi.org/v2" ++ str ++ "?apiKey=a688e6494c444902b1fc9cb93c61d697"


sourceDecoder : Decoder Source
sourceDecoder =
    decode Source
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "url" string
        |> required "category" string
        |> required "language" string
        |> required "country" string


sourceListDecoder : Decoder (List Source)
sourceListDecoder =
    field "sources" (list sourceDecoder)


fetch : Decoder a -> String -> (Result Http.Error a -> b) -> Cmd b
fetch decoder url action =
    Http.get url decoder
        |> Http.send action


fetchSources : Cmd Msg
fetchSources =
    let
        sourceUrl =
            apiUrl ("/sources")
    in
        Http.get sourceUrl sourceListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchSources


decodeArticleSource : Decoder ArticleSource
decodeArticleSource =
    Json.Decode.map2 ArticleSource
        (field "id" string)
        (field "name" string)


articleDecoder : Decoder Article
articleDecoder =
    decode Article
        |> required "source" (decodeArticleSource)
        |> required "title" string
        |> required "author" (nullable string)
        |> required "description" string
        |> required "url" (nullable string)
        |> required "urlToImage" (nullable string)
        |> required "publishedAt" (nullable string)


articleListDecoder : Decoder (List Article)
articleListDecoder =
    field "articles" (list articleDecoder)


fetchHeadlines : String -> Cmd Msg
fetchHeadlines sourceId =
    let
        articlesUrl =
            "https://newsapi.org/v2/top-headlines?sources=" ++ sourceId ++ "&apiKey=a688e6494c444902b1fc9cb93c61d697"

        --apiUrl ("/top-headlines?sources=" ++ sourceId)
    in
        Http.get articlesUrl articleListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map OnFetchHeadlines
