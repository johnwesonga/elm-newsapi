module Main exposing (..)

import Api exposing (..)
import Types exposing (..)
import RemoteData exposing (..)
import Route exposing (parseLocation)
import Navigation exposing (Location)
import View exposing (view)


initialModel : Route -> Model
initialModel route =
    (Model RemoteData.Loading RemoteData.Loading route)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( initialModel currentRoute, fetchSources )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchSources response ->
            { model | sources = response } ! []

        OnFetchHeadlines response ->
            { model | headlines = response } ! []

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                urlUpdate { model | route = newRoute }

        _ ->
            ( model, Cmd.none )


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        Home ->
            model ! []

        HeadlinesRoute sourceId ->
            { model | headlines = RemoteData.Loading } ! [ fetchHeadlines sourceId ]

        _ ->
            model ! []



---- PROGRAM ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
