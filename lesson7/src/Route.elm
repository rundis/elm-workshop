module Route exposing (Page (..), decode, encode)


import UrlParser exposing (s, top)
import Navigation

type Page
    = Home
    | Distribution
    | People



route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Distribution (s "distribution")
        , UrlParser.map People (s "people")
        ]


decode : Navigation.Location -> Maybe Page
decode location =
    UrlParser.parseHash route location


encode : Page -> String
encode route =
    case route of
        Home ->
            "/#"

        Distribution ->
            "#/distribution"

        People ->
            "/#people"



