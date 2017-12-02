module Route exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Types exposing (Route(..))


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map HeadlinesRoute (s "headlines" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
