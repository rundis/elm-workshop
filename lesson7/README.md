# Lesson 7 - Talking to JavaScript

So now your product owner has decided that your are going to need to store team distributions in the future.
Related to that requirement it's been stated that your app is going to need a datepicker. You've looked at
what's available in the Elm Package manager and couldn't find any that satisfies the stated requirements.


You did however find that [the jquery ui datepicker](https://api.jqueryui.com/datepicker/) fit the bill very nicely. But that's JavaScript, how do you get your Elm program to talk to the datepicker ?




## Ports
To send and receive stuff from JavaScript land in Elm you have to use a mechanism called `ports`. Unlike many other compile-to-js languages Elm enforces strict border control when talking to JavaScript. The reasoning behind this strictness stems from Elm's goal of having zero runtime exception in your Elm programs.



Talking to JavaScript is very much like a publish/subscribe mechanism. You can publish stuff (async) to JavaScript through ports and you can subscribe to stuff from JavaScript land through ports. One way to think about it from an Elm perspective is `JavaScript as a Service`. Elm provides automatic marshalling of things that are easily mappable like strings, booleans, numbers, lists etc. If you come across a case where you have
data types that there is no support for, you can always send JSON as string and using Elm's Json decoders/encoders (like you saw a small example of in lesson 5).



> For more information about JavaScript integration you should check out the [JavaScript](https://guide.elm-lang.org/interop/javascript.html) chapter in the elm-guide.

## Example
You would surely be able to connect the dots yourself after reading the guide, but in the interest of time etc,  we've implemented a small skeleton implementation to get you started.


### Embedding your Elm app
You might not have noticed, but since lesson 3 we have already been working with an Elm application that is embedded in a Html. For anything but toy apps that's what you'll end up doing. Now is a good time to walk through it.

**src/index.html**
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Team Distributor</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

    <!-- Add the CSS and javascript necessary for the Jquery Datepicker -->
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  </head>
  <body>
    <!-- Include JavaScript for that embeds our Elm application -->
    <script src="index.js"></script>
  </body>
</html>
```

**src/index.js**
```javascript
'use strict';


require('./index.html');
var Elm = require('./Main'); // Pulls in the transpiled/compiled js output for our Elm program

// Start/embed the Elm application
var elm = Elm.Main.fullscreen();

```

#### Adding datepicker support to our index.js

We append the following incantation to our `src/index.js` to define the JavaScript side for supporting
the datepicker.

```javascript
// From JavaScript we can subscribe to an outgoing port from our Elm program
elm.ports.initializeJquery.subscribe(function(settings) {

  // requestAnimationFrame, because we want to make sure Elm has had time to render the element for the datepicker
  requestAnimationFrame ( function () {

    $("#datepicker").datepicker({

      dateFormat: settings.dateFormat || "dd.mm.yy",

      onSelect: function(selectedDate) {

        // Send date to Elm when new date is picked
        // We publish it to a port in our Elm programm called newDate
        elm.ports.newDate.send(selectedDate);
      }
    });
  });
});
```




### Adding support for the datapicker in Elm

#### Model
```elm
type alias Model =
    { -- omitted other fields
    , date : Maybe String
    , dateSettings : DateSettings
    }

type alias DateSettings =
    { dateFormat : String }
```

#### Msg
```elm
type Msg
    = -- omitted other messages
    | NewDate String
```


#### Ports

```elm

{-| Outgoing port
-}
port initializeJquery : DateSettings -> Cmd msg


{-| Incoming port
-}
port newDate : (String -> msg) -> Sub msg

```


#### Subscription

```elm
main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    newDate NewDate

```


#### Update
```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewDate dateStr ->
            ( { model | date = Just dateStr }, Cmd.none )
```


#### Url update
```elm
urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case (Route.decode location) of
        Just page ->
            case page of
                -- We need to initialize the datepicker whenever the page showing the datepicker is selected
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
```


#### Showing the datapicker

```elm

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
        -- We've just chucked it in here. Note the id attribute, which is used JS side to match.
        , div [ class "col-sm-3" ]
            [ input [ id "datepicker", type_ "text" ] [] ]
        ]
    , div [ class "row" ]
        [ div [ class "col-sm-3" ] [ viewPeople model ]
        , div [ class "col-12 hidden-sm-up" ] [ hr [] [] ]
        , div [ class "col-sm-9" ] [ viewTeams model ]
        ]
    ]
```



## Your assignment

1. The current implementation doesn't seem to store the date you selected when you change pages. You need to figure out a way to handle that.
2. Add a min date constraint. You'll need to extend the settings you pass from Elm and use the extra setting when initializing the Datepicker on the JS side
3. Add a button next to the datepicker, when you click it the datepicker should be shown.
  - You need to add another outgoing port in your Elm program. Something like `port showDatepicker : () -> Cmd msg`
  - Add a `onClick` handler for the button element in your view
  - Add a message (constructor) to your `Msg` type
  - Add handling for the new message in your update function (it needs to use your port !)
  - Add a port subscription in `src/index.js` to the new port and use the `show` method for jquery datepicker (`$( ".selector" ).datepicker( "show" );`)


### Getting started
- `cd lesson7`
- `npm install`
- `elm-package install --yes elm-lang/nagivation`
- `elm-package install --yes evancz/url-parser`
- `npm run dev`

In another terminal:
- `cd lesson7`
- `npm run api`




### Bonus
- It sucks to store date as a string in our model. See if you can't work out a way to store dates using the [Date](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Date) module in Elm. You might need to tweak the js side of things for onSelect
- It would be great if I could type the date and only valid dates are allowed
   -- Maybe you could add some sort of validation (on blur perhaps) showing an error message


### Hints
* Datepicker API: https://api.jqueryui.com/datepicker/
* Html.Attributes.value and Html.Attributes.defaultValue might be useful functions to look at for your datepicker. Feel free to try both and see if you can figure out how they differ



