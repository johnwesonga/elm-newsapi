module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Api exposing (..)
import Types exposing (..)
import RemoteData exposing (..)


init : ( Model, Cmd Msg )
init =
    ( Model [] [] "" RemoteData.Loading, fetchSources )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadSources ->
            ( model, getSources )

        LoadArticles ->
            ( model, getArticles "bbc-news" )

        GetSources (Ok result) ->
            ( { model | sourceList = result }, Cmd.none )

        GetSources (Err error) ->
            { model | error = toString error } ! []

        GetArticles (Ok result) ->
            ( { model | articleList = result }, Cmd.none )

        OnFetchSources response ->
            ( { model | sources = response }, Cmd.none )

        _ ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Your Elm App is working!" ]
        , button [ onClick LoadSources ] [ text "Load Sources!" ]
        , button [ onClick LoadArticles ] [ text "Load Articles!" ]
        , viewNewsSourcesList model
        , viewFetchSources model.sources
        , p []
            [ if (model.error /= "") then
                text ("Error:" ++ model.error)
              else
                text ""
            ]
        ]


viewFetchSources : WebData (List Source) -> Html Msg
viewFetchSources response =
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


viewNewsSourcesList : Model -> Html Msg
viewNewsSourcesList model =
    div [ class "newsSource" ]
        [ model.sourceList
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



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
