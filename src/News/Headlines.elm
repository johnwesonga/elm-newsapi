module News.Headlines exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import RemoteData exposing (..)
import Api exposing (..)


headlinesViewPage : Model -> String -> Html Msg
headlinesViewPage model sourceId =
    case model.headlines of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success headlines ->
            list headlines

        RemoteData.Failure error ->
            text (toString error)


list : List Article -> Html Msg
list articles =
    div [ class "headlines" ]
        [ articles
            |> List.map viewArticles
            |> ul []
        ]


viewArticles : Article -> Html Msg
viewArticles article =
    li []
        [ text article.description
        ]
