module Types exposing (..)

import Http
import RemoteData exposing (WebData)


---- MODEL ----


type Msg
    = NoOp
    | LoadSources
    | LoadArticles
    | GetSources (Result Http.Error (List Source))
    | GetArticles (Result Http.Error (List Article))
    | OnFetchSources (WebData (List Source))


type alias Model =
    { articleList : List Article
    , sourceList : List Source
    , error : String
    , sources : WebData (List Source)
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
    , author : String
    , description : String
    , url : String
    , urlToImage : String
    , publishedAt : String
    }



--ROUTE --


type alias SourceId =
    String


type Route
    = ArticlesRoute
    | ArticleRoute SourceId
    | NotFoundRoute
