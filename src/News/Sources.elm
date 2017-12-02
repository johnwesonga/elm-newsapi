module News.Sources exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import RemoteData exposing (..)


view : WebData (List Source) -> Html Msg
view response =
    div []
        [ maybeList response
        ]


maybeList : WebData (List Source) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success source ->
            list source

        RemoteData.Failure error ->
            text (toString error)


list : List Source -> Html Msg
list source =
    div [ class "newsSource" ]
        [ source
            |> List.map viewNewsSource
            |> ul []
        ]


viewNewsSource : Source -> Html Msg
viewNewsSource source =
    li []
        [ a [ href ("/#headlines/" ++ source.id) ]
            [ text source.name
            ]
        ]
