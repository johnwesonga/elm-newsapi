module Types exposing (..)

import Http
import RemoteData exposing (WebData)
import Navigation exposing (Location)


---- MODEL ----


type Msg
    = NoOp
    | OnFetchSources (WebData (List Source))
    | OnFetchHeadlines (WebData (List Article))
    | OnLocationChange Location


type alias Model =
    { sources : WebData (List Source)
    , headlines : WebData (List Article)
    , route : Route
    }



--SOURCE


type alias Source =
    { id : String
    , name : String
    , description : String
    , url : String
    , category : String
    , language : String
    , category : String
    }



--ARTICLES


type alias ArticleSource =
    { id : String
    , name : String
    }


type alias Article =
    { source : ArticleSource
    , title : String
    , author : Maybe String
    , description : String
    , url : Maybe String
    , urlToImage : Maybe String
    , publishedAt : Maybe String
    }



--ROUTE --


type alias SourceId =
    String


type Route
    = Home
    | HeadlinesRoute SourceId
    | NotFoundRoute
