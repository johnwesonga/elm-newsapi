module News.Headlines exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import RemoteData exposing (..)


view : WebData (List Article) -> Html Msg
view response =
    div []
        [ maybeList response
        ]


maybeList : WebData (List Article) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success articles ->
            list articles

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
        []
