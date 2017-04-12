# Lesson 4 - Implementing Randomization

In the previous lesson we familiarized ourselves with the Elm Html functions. Our solution was entirely static and we created a hard coded distribution of our teams. It's time to move on and add some interactivity to our application and to make our team distribution randomized.




## The Elm Architecture

Every Elm Application follows a simimlar structure or pattern described as [`The Elm Architecture`](https://guide.elm-lang.org/architecture/). So Elm isn't just a language that compiles down to JavaScript, but you could argue that it's also a framework for structuring you applications as well. If you are familiar with [`Redux`](http://redux.js.org/) and [`Facebook React`](https://facebook.github.io/react/), you'll probably see many similarities. In Elm, managing application state and having a virtual DOM implementation isn't opt-in, it's mandated and ships out of the box.



## Changing the main function

Our current `main` function has the following signature
`main : Html msg`. It just returns some chunk of Html, or rather more accurately it returns data describing how we want our page to look like. The Elm Runtime will turn that description into HTML that is displayed by the browser.


To make our application interactive and support side effects we need to change our `main` function.


```elm
import Html

main =
    Html.program
      { init = init
      , update = update
      , view = view
      , subscriptions = \_ -> Sub.none
      }

```

* `Html.program` is a function that lives in the `Html` module that ships with any Elm program. It takes one parameter which is a record with 4 fields that describes specific interaction points to your application that is called by the Elm runtime.
* The `init`field describes the entry point function for your application, it's called once when your application starts.
* The `update` field descibes the function that is responsible for stepping your application state forward.
* The `view` field is for wiring up the function where you describe the view for your application given the current application state
* The `subscription` function is an entry point for subscribing to outside events. We won't be using this for now.


### Init
The init function (or more accurately `value`) is where you initialize your application. Here you define the initial state for your application and any side-effects you'd like to be triggered when starting your application.

```elm
init : (Model, Cmd Msg)
init =
    ( initialModel, Cmd.none )

```

- It returns a 2-tuple of your application state and a Cmd
  - Your application state is just a type, but common practice is to name it `Model`
  - Cmd is just an opaque type that describes side-effects you would like the Elm runtime to perform on your behalf.
  - `Msg` is a type that you define. Again this is just some data describing a message to your application. Messages is passed to your applications `update` function for you to react upon. We'll get back to this shortly.
  - When the Elm runtime has excuted a command it will notify you of the result using your defined message by calling the update function.

In the example above we use `Cmd.none` which informs the Elm runtime that we don't have any side-effects it should execute when calling `init`.


### Update
The update function is called by the Elm runtime whenever there is a message our application should react upon. It looks something like this:


```elm

-- Our model just represents a number in this example
type alias Model = Int

-- Our application supports two messages
type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

```
* `update` takes two parameters of types `Msg` and `Model` and returns
a tuple of our (potentially) updated `Model` and any commands (side-effects) we'd like to schedule for execution
* `msg` is a concrete instance of Msg. In the example above it can be either `Increment` or `Decrement`
* `model` is the current application state. Elm keeps track of the application state for us. Presumably we have initialized our model to be 0 in our init function (not shown).
* The implementation shows how we can pattern match on the `msg` value to determine the appropriate step forward for our application. We return an updated model (either incremented or decremented) and no side-effects in this example.


### View
The view is where we define how we want the view of our application to be given the current state of it.


```elm
view : Model -> Html Msg
view model =
  div []
      [ button [ onClick Decrement ] [ text "-" ]
      , span [] [ text " " ++ toString model ++ " " ]
      , button [ onClick Increment ] [ text "+" ]
      ]

```

* `Model` the view function receives the current state of our application. Here we use that to display the current count.
* `Html Msg` - You'll notice that not only are we defining markup (Html)
but we are defining 2 event handlers (`onClick`). One for each button.
When the user clicks on one of the buttons, the Elm runtime will pick that up and call our update function with the appropriate `Msg`, in our case either `Increment` or `Decrement`. So our view function not only returns `Html`, but it returns `Html Msg` meaning Html that can trigger messages of type `Msg`.


> What's the difference between `Html msg` and `Html Msg` ? Well `msg` means it can be any type, but our application doesn't trigger messages of any type. Our application triggers messages of the specific `Msg` type.



## Random
In a language `JavaScript` you can easily invoke `Math.random`. Not so in Elm ! Why ? Well Elm is a purely functional language (or at least your Elm Application is). Calling random is a side effect, and by nature it isn't pure (*).

>(*) The function always evaluates the same result value given the same argument value(s). The function result value cannot depend on any hidden information or state that may change while program execution proceeds or between different executions of the program, nor can it depend on any external input from I/O devices (usually—see below).

> Evaluation of the result does not cause any semantically observable side effect or output, such as mutation of mutable objects or output to I/O devices (usually—see below).

Pure functions are much easier to test, but it also gives other benefits as you'll see when we introduce the Elm debugger.

The main take-away is that introducing random in your Elm Application is a bit more involved than it is in many other languages.


**I'll walk you through a simple example on how to use the [`Random module`](http://package.elm-lang.org/packages/elm-lang/core/latest/Random) in Elm.**



## Your assignment
Your task is to make the Team distribution from the previous lesson randomized and interactive.

A little checklist of things you'll need to do:
* Change the main function to use Html.program
* Add a `Msg` type. You probably need 2 messages, one for requesting random number generation, and one for receiving the generated numbers/values
* Add a field to your model, to hold generated numbers
* Add an `init` function
* Add an `update` function
  - Implement behavior for the two messages
* Change all references in type annotations using `msg` to use `Msg`
* Add a button or something allowing a user to initiate a team distribution
* Create a function that creates the actual team distribution given the list of people and the random input
* Update your view function(s) to display the randomized team distribution



**Getting started:**
* `cd lesson4`
* `npm install`
* `elm-package install`
* `npm run dev` (remember to kill your previous running app !)
* Open your editor and start hacking on `lesson4/src/Main.elm`



**Bonus**
* Would it be possible to change your init function so that your app starts off with a randomized team distribution
* Update your view to handle the scenario where no randomized team distribution yet exists
* Make the view less awful !
* Your customer isn't as impressed as you'd expect, could you make the drawing of teams more interesting by adding some delay and/or incrementally rendering the results ? Perhaps introducing a subscription using [Time.every](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Time#every) gives you some new ideas ?



### Useful hints perhaps ?
- [List.map2](http://package.elm-lang.org/packages/elm-lang/core/latest/List#map2) is useful if you need to map over 2 lists
- Should you for some reason end up with a tuple, `Tuple.first` and `Tuple.second` might come in handy
- [List.sortBy](http://package.elm-lang.org/packages/elm-lang/core/latest/List#sortBy) could be useful, or not depending on what approach you choose :)









