module Route exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Types exposing (Route(..))


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ArticlesRoute top
        , map ArticleRoute (s "headlines" </> string)
        , map ArticlesRoute (s "articles")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
