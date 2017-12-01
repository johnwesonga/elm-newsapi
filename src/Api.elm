module Api exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Http
import Types exposing (..)
import RemoteData exposing (..)


apiUrl : String -> String
apiUrl str =
    "https://newsapi.org/v2" ++ str ++ "?apiKey=a688e6494c444902b1fc9cb93c61d697"


sourceDecoder : Decoder Source
sourceDecoder =
    decode Source
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "url" Decode.string
        |> required "category" Decode.string
        |> required "language" Decode.string
        |> required "country" Decode.string


sourceListDecoder : Decoder (List Source)
sourceListDecoder =
    Decode.field "sources" (Decode.list sourceDecoder)


fetch : Decoder a -> String -> (Result Http.Error a -> b) -> Cmd b
fetch decoder url action =
    Http.get url decoder
        |> Http.send action


getSources : Cmd Msg
getSources =
    let
        sourceUrl =
            apiUrl ("/sources")
    in
        fetch sourceListDecoder sourceUrl GetSources


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
    Decode.map2 ArticleSource
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)


articleDecoder : Decoder Article
articleDecoder =
    decode Article
        |> required "source" (decodeArticleSource)
        |> required "title" Decode.string
        |> required "author" Decode.string
        |> required "description" Decode.string
        |> required "url" Decode.string
        |> required "urlToImage" Decode.string
        |> required "publishedAt" Decode.string


articleListDecoder : Decoder (List Article)
articleListDecoder =
    Decode.field "articles" (Decode.list articleDecoder)


getArticles : String -> Cmd Msg
getArticles source =
    let
        articlesUrl =
            apiUrl ("/top-headlines?sources=" ++ source)
    in
        fetch articleListDecoder articlesUrl GetArticles
