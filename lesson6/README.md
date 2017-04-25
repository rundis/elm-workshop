# Lesson 6 - Introducing Navigation

We've done a great job so far, but the requirements keep pouring in. So far we've had just a single page. And allthough we are making a Single Page Application, we want to be able to have multiple pages, we just don't wont to hit the server with a full page reload. In this lesson you'll learn how to use the [elm-navigation](http://package.elm-lang.org/packages/elm-lang/navigation/latest) and [url-parser](http://package.elm-lang.org/packages/evancz/url-parser/latest) packages to introduce page navigation in the Team Distributor application.




## Navigation
The navigation package is a package allows you to capture browser navigation and handle it yourself. It provides functions that allows you to work with the browsers history api in a sensible and type safe manner.


### Changes to main

In order for you to use the navigation package and reap it's benefits you'll need to change how you wire you main function.  Your new main function will look something like this.


```elm
import Navigation


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
```

We use the program function from the Navigation module. It's very similar to the `program` function from the Html module. However you'll notice that it takes an addition parameter. We've called this UrlChange and it's a message function that you define.

```elm
type Msg
  = UrlChange Navigation.Location
  | ... other messages
```

Whenever the browser url changes, your update function will receive a message (in our case `UrlChange`) with the current location. How you deal with is up to you. We'll get back to that real soon.

### Changes to init
There is also one other small change you need to accomodate. You obviously want to know what the initial url is when you start your application. So the `init` function also needs to change.

```elm
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ... dealing with the initial location

```

`Location` is just a record with a bunch of fields (`host`, `port`, `pathname`, `hash` etc). You can obviously work with that by hand for doing your page routing/navigation, but it's tedious and error prone so we'll use another package for that.


## Url parser

In a real world application we would probably use hashless urls, but for simplicity we'll be using hash based urls.

You'll find the api to be fairly intuitive and should be able to figure it out by reading the [api docs](http://package.elm-lang.org/packages/evancz/url-parser/latest/UrlParser)


```elm
import UrlParser
import Navigation

-- We've decided to keep track of just pages for our routes
-- These are the only routes we currently support in our App
type Page
    = Home
    | Artists
    | Albums

{-| The definition of our route parser.
-}
route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Artists (UrlParser.s "artists")
        , UrlParser.map Albums (UrlParser.s "albums")
        ]

{-| Try to turn a location into a Page type
-}
decode : Navigation.Location -> Maybe Page
decode location =
    UrlParser.parseHash route location


{-| Handy utility function for turning a concrete Page type
into a url (`hash`). Great for creating links in our app !
-}
encode : Page -> String
encode route =
    case route of
        Home ->
            "/#"

        Artists ->
            "/#artists"

        Albums ->
            "/#albums"
```


## Filling in the missing pieces


Let's start with creating a function for dealing with url changes.


```elm
urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case (decode location) of
        Just page ->
            ( { model | page = page }, Cmd.none )

        Nothing ->
            let
                _ =
                    Debug.log "Couldn't parse: " location
            in
                -- TODO : Handle page not found here !
                ( model, Cmd.none )
```
If decoding of a location returns a successful result (a `Page`), we store that in our model. If parsing fails, we would want to deal with that graciosly too. Above we haven't (:


Armed with that function we can now complete our init function.

```elm
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( model, urlCmd ) =
            urlUpdate location initialModel
    in
        ( model, Cmd.batch [ urlCmd, someOtherCmdProducingFunction ] )
```

- So first we run the urlUpdate function that return a tuple of an updated model and a command.
- Then we return a tuple of the updated model and a batch of commands.

> When you need to return potential several effects you want exectuted from init or your update function, you'll have to use the `Cmd.batch` function which will compose your commands into one "master" command.

> _It's worth knowing that commands are executed asynchronously and the Elm runtime provides no ordering guarantee on there execution or completion._


Adjusting our update function is just a matter of dealing with the new message by delegation

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        ... other messages
```


## Your assignment
- Implement a navbar with
  - A clickable brand "Team Distributor" which takes you to the Home page
  - A menu item "Distribution" for the team distribution
  - A menu item "People" for a future people crud page
- Implement a simple Home page with some text on it
- Implement a dummy People page
- Implement a new module `Route` in a new `Route.elm` file which exposes
  - A Page type
  - `decode` function
  - `encode` function
  - your module header should look like this `module Route exposing (Page (..), decode, encode)`
- Adapt your view function(s) to show the menu bar and switch its main content depending on which page is selected


> This is a pretty substantial refactor. Don't worry, just jump in and let the compiler guide you along the way.


### Getting started
- `cd lesson6`
- `npm install`
- `elm-package install --yes elm-lang/navigation`
- `elm-package install --yes evancz/url-parser`
- `npm run dev`

In another terminal:
- `cd lesson6`
- `npm run api`

Open your editor and off you go !


### A few extra tips

You might find that writing a view function like this handy;


```elm
viewPageContent : Model -> List (Html Msg)
viewPageContent model =
    case model.page of
        Route.Home ->
            viewHome

        ... etc
```


To give you some help for creating a menu you might find this html markup helpful inspiration:

```html
<nav class="navbar navbar-toggleable navbar-light bg-faded">
  <a class="navbar-brand" href="#">Navbar</a>
  <div class="navbar-collapse" id="navbarNav">
    <ul class="navbar-nav">
      <li class="nav-item active">
        <a class="nav-link" href="#">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Features</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Pricing</a>
      </li>
      <li class="nav-item">
        <a class="nav-link disabled" href="#">Disabled</a>
      </li>
    </ul>
  </div>
</nav>
```















