module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array
import Random
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { people : List Person
    , teamCount : Int
    , randomNumbers : List Int
    }


type alias Person =
    { id : Int
    , name : String
    }


initialModel : Model
initialModel =
    { people = []
    , teamCount = 4
    , randomNumbers = []
    }


type Msg
    = RandomRequested
    | RandomReceived (List Int)
    | PeopleReceived (Result Http.Error (List Person))


init : ( Model, Cmd Msg )
init =
    ( initialModel, getPeople )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RandomRequested ->
            ( model, createRandomRequest <| List.length model.people )

        RandomReceived numbers ->
            ( { model | randomNumbers = numbers }, Cmd.none )


        PeopleReceived res ->
            case res of
                Ok people ->
                    ( { model | people = people }, createRandomRequest <| List.length people )

                Err err ->
                    let
                        _ =
                            Debug.log "Couldn't get people " err
                    in
                        ( model, Cmd.none )


createRandomRequest : Int -> Cmd Msg
createRandomRequest size =
    Random.list size (Random.int 0 1000)
        |> Random.generate RandomReceived


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row", style [ ( "margin", "20px 20px" ) ] ]
            [ h1 [ class "mx-auto" ] [ text "Team Distributor" ] ]
        , div [ class "row", style [ ( "margin-bottom", "10px" ) ] ]
            [ div [ class "col offset-sm-3" ]
                [ button
                    [ class "btn btn-primary"
                    , onClick RandomRequested
                    ]
                    [ text "Randomize" ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-sm-3" ] [ viewPeople model ]
            , div [ class "col-12 hidden-sm-up" ] [ hr [] [] ]
            , div [ class "col-sm-9" ] [ viewTeams model ]
            ]
        ]


viewPeople : Model -> Html Msg
viewPeople model =
    ul
        [ class "list-group" ]
        (List.map viewPerson model.people)


viewPerson : Person -> Html Msg
viewPerson person =
    li [ class "list-group-item" ] [ text person.name ]


viewTeams : Model -> Html Msg
viewTeams model =
    div
        [ class "row" ]
        (List.indexedMap viewTeam <| makeTeamDistribution model)


viewTeam : Int -> List Person -> Html Msg
viewTeam idx members =
    card
        [ h4
            [ class "card-header", style [ ( "white-space", "nowrap" ) ] ]
            [ text <| "Team " ++ toString (idx + 1) ]
        , ul
            [ class "list-group list-group-flush" ]
            (List.map viewTeamMember members)
        ]


viewTeamMember : Person -> Html Msg
viewTeamMember member =
    li [ class "list-group-item" ] [ text member.name ]


card : List (Html Msg) -> Html Msg
card children =
    div
        [ class "col-sm" ]
        [ div [ class "card" ] children ]


makeTeamDistribution : Model -> List (List Person)
makeTeamDistribution { people, teamCount, randomNumbers } =
    let
        balancedTeamSize =
            (List.length people // teamCount)

        balancedCount =
            balancedTeamSize * teamCount

        shuffled =
            List.map2 (,) randomNumbers people
                |> List.sortBy Tuple.first
                |> List.map Tuple.second

        leftovers =
            List.drop balancedCount shuffled |> Array.fromList
    in
        partitionBy balancedTeamSize (List.take balancedCount shuffled)
            |> List.indexedMap
                (\idx team ->
                    case Array.get idx leftovers of
                        Just p ->
                            p :: team

                        Nothing ->
                            team
                )


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


getPeople : Cmd Msg
getPeople =
    Http.get "http://localhost:5001/people" peopleDecoder
        |> Http.send PeopleReceived


peopleDecoder : Decode.Decoder (List Person)
peopleDecoder =
    Decode.list personDecoder


personDecoder : Decode.Decoder Person
personDecoder =
    Decode.map2 Person
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
