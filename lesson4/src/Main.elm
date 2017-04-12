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
    , teamSize = 5
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
        (List.map viewPerson model.people)


viewPerson : Person -> Html msg
viewPerson person =
    li [ class "list-group-item"] [ text person.name ]



-- TODO : Show the actual list of of teams
viewTeams : Model -> Html msg
viewTeams model =
    let
        teams =
            partitionBy model.teamSize model.people
    in
        div
            [ class "row" ]
            (List.indexedMap viewTeam teams)


viewTeam : Int -> List Person -> Html msg
viewTeam idx members =
    card
        [ h4 [ class "card-header" ] [ text <| "Team " ++ toString (idx + 1) ]
        , ul
            [ class "list-group list-group-flush" ]
            (List.map viewTeamMember members)
        ]

viewTeamMember : Person -> Html msg
viewTeamMember member =
    li [ class "list-group-item" ] [ text member.name]


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
