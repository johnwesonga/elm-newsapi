module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Types exposing (..)
import News.Headlines
import News.Sources
import Api


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Elm SPA" ]
        , page model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            News.Sources.view model.sources

        HeadlinesRoute sourceId ->
            News.Headlines.headlinesViewPage model sourceId

        NotFoundRoute ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
