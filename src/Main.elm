module Main exposing (..)

import Api exposing (..)
import Types exposing (..)
import RemoteData exposing (..)
import Route exposing (parseLocation)
import Navigation exposing (Location)
import View exposing (view)


initialModel : Route -> Model
initialModel route =
    (Model [] [] "" RemoteData.Loading route)


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
        GetSources (Ok result) ->
            ( { model | sourceList = result }, Cmd.none )

        GetSources (Err error) ->
            { model | error = toString error } ! []

        GetArticles (Ok result) ->
            ( { model | articleList = result }, Cmd.none )

        OnFetchSources response ->
            ( { model | sources = response }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        _ ->
            ( model, Cmd.none )



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
