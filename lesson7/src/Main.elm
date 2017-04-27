port module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array
import Random
import Http
import Json.Decode as Decode
import Navigation
import Route


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { people : List Person
    , teamCount : Int
    , randomNumbers : List Int
    , page : Route.Page
    , date : Maybe String
    , dateSettings : DateSettings
    }


type alias Person =
    { id : Int
    , name : String
    }



-- ref https://api.jqueryui.com/datepicker/


type alias DateSettings =
    { dateFormat : String }


initialModel : Model
initialModel =
    { people = []
    , teamCount = 4
    , randomNumbers = []
    , page = Route.Home
    , date = Nothing
    , dateSettings = { dateFormat = "yy-mm-dd" }
    }


type Msg
    = RandomRequested
    | RandomReceived (List Int)
    | PeopleReceived (Result Http.Error (List Person))
    | UrlChange Navigation.Location
    | NewDate String


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( model, urlCmd ) =
            urlUpdate location initialModel
    in
        ( model, Cmd.batch [ urlCmd, getPeople ] )



-- SUBSCRIPTIONS


{-| Outgoing port
-}
port initializeJquery : DateSettings -> Cmd msg


{-| Incoming port
-}
port newDate : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    newDate NewDate



-- UPDATE


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

        UrlChange location ->
            urlUpdate location model

        NewDate dateStr ->
            ( { model | date = Just dateStr }, Cmd.none )


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case (Route.decode location) of
        Just page ->
            case page of
                Route.Distribution ->
                    ( { model | page = page }, initializeJquery model.dateSettings )

                _ ->
                    ( { model | page = page }, Cmd.none )

        Nothing ->
            let
                _ =
                    Debug.log "Couldn't parse: " location
            in
                -- TODO : Handle page not found here !
                ( model, Cmd.none )


createRandomRequest : Int -> Cmd Msg
createRandomRequest size =
    Random.list size (Random.int 0 1000)
        |> Random.generate RandomReceived



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        (viewMenu model :: viewPageContent model)


viewMenu : Model -> Html Msg
viewMenu model =
    nav
        [ class "navbar navbar-toggleable navbar-light bg-faded" ]
        [ a [ class "navbar-brand", href "#/" ] [ text "Team Distributor" ]
        , div [ class "navbar-collapse" ]
            [ ul [ class "navbar-nav" ]
                [ navItem Route.Distribution "Distribution" model
                , navItem Route.People "People" model
                ]
            ]
        ]


navItem : Route.Page -> String -> Model -> Html Msg
navItem page label model =
    li
        [ classList
            [ ( "nav-item", True )
            , ( "active", model.page == page )
            ]
        ]
        [ a [ class "nav-link", href <| Route.encode page ]
            [ text label ]
        ]


viewPageContent : Model -> List (Html Msg)
viewPageContent model =
    case model.page of
        Route.Home ->
            viewHome

        Route.Distribution ->
            viewDistribution model

        Route.People ->
            [ text "Coming soon" ]


viewHome : List (Html msg)
viewHome =
    [ div [ class "jumbotron" ]
        [ h1 [ class "display-3" ] [ text " Welcome to Team Distributor" ]
        , p [ class "lead" ]
            [ text """Assigning peoples to teams can be really tiresome, wouldn't it be great if someone could do it automatically for you ?""" ]
        , hr [ class "my-4" ] []
        , p [] [ text "Look no further. Team Distributor got you covered !" ]
        ]
    ]


viewDistribution : Model -> List (Html Msg)
viewDistribution model =
    [ div [ class "row", style [ ( "margin", "10px 10px" ) ] ]
        [ div [ class "col-sm-3" ]
            [ button
                [ class "btn btn-primary"
                , onClick RandomRequested
                ]
                [ text "Randomize" ]
            ]
        , div [ class "col-sm-3" ]
            [ input [ id "datepicker", type_ "text" ] [] ]
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
        ([ div [ class "col-12" ]
            [ h3 [] [ text "Distribution" ] ]
         ]
            ++ (List.indexedMap viewTeam <| makeTeamDistribution model)
        )


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



-- MISC HELPERS


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
