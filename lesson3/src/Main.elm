module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    view initialModel


type alias Model =
    { people : List Person
    , teamSize : Int
    }


type alias Person =
    { id : Int
    , name : String
    }


initialModel : Model
initialModel =
    { people = personList
    , teamSize = 4
    }



view : Model -> Html msg
view model =
    div [ class "container"]
        [ div [class "row", style [("margin", "20px 20px")] ]
            [ h1 [ class "mx-auto" ] [ text "Team Distributor"] ]
        , div [ class "row" ]
            [ div [ class "col-sm-4" ] [ viewPeople model]
            , div [ class "col-12 hidden-sm-up"] [ hr [] [] ]
            , div [ class "col-sm-8" ] [ viewTeams model ]
            ]
        ]

-- TODO : Show the actual list of people
viewPeople : Model -> Html msg
viewPeople model =
    ul
        [ class "list-group" ]
        [ li [ class "list-group-item"] [ text "Person 1" ]
        , li [ class "list-group-item"] [ text "Person 2" ]
        ]



-- TODO : Show the actual list of of teams
viewTeams : Model -> Html msg
viewTeams model =
    div
        [ class "row" ]
        [ card
            [ h4 [ class "card-header" ] [ text "Team 1" ]
            , ul
                [ class "list-group list-group-flush" ]
                [ li [ class "list-group-item" ] [ text "Person 1" ]
                , li [ class "list-group-item" ] [ text "Person 2" ]
                ]
            ]
        , card
            [ h4 [ class "card-header" ] [ text "Team 2" ]
            , ul
                [ class "list-group list-group-flush" ]
                [ li [ class "list-group-item" ] [ text "Person 3" ]
                , li [ class "list-group-item" ] [ text "Person 4" ]
                ]
            ]
        , card
            [ h4 [ class "card-header" ] [ text "Team 3" ]
            , ul
                [ class "list-group list-group-flush" ]
                [ li [ class "list-group-item" ] [ text "Person 5" ]
                , li [ class "list-group-item" ] [ text "Person 6" ]
                ]
            ]
        , card
            [ h4 [ class "card-header" ] [ text "Team 4" ]
            , ul
                [ class "list-group list-group-flush" ]
                [ li [ class "list-group-item" ] [ text "Person 7" ]
                , li [ class "list-group-item" ] [ text "Person 8" ]
                ]
            ]
        ]


card : List (Html msg) -> Html msg
card children =
    div
        [ class "col-sm" ]
        [ div [ class "card" ] children ]



partitionBy : Int -> List a -> List (List a)
partitionBy step items =
    let
        partition =
            List.take step items
    in
        if List.length partition > 0 && step > 0 then
            partition :: partitionBy step (List.drop step items)
        else
            []



personList : List Person
personList =
    [ Person 1 "Nils"
    , Person 2 "Christin"
    , Person 3 "Eivind"
    , Person 4 "Christian"
    , Person 5 "Alf Kristian"
    , Person 6 "Odin"
    , Person 7 "August"
    , Person 8 "Stian"
    , Person 9 "Stein Tore"
    , Person 10 "Stig"
    , Person 11 "Anders"
    , Person 12 "Kristian"
    , Person 13 "Kjetil"
    , Person 14 "Fredrik"
    , Person 15 "Finn"
    , Person 16 "Alf"
    , Person 17 "Ronny"
    , Person 18 "Magnar"
    , Person 19 "Magnus"
    , Person 20 "Gry"
    , Person 21 "André"
    , Person 22 "Torstein"
    , Person 23 "Kristoffer"
    , Person 24 "Kolbjørn"
    , Person 25 "Trygve"
    ]
