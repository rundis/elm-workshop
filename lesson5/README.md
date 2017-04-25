# Lesson 5 - Retrieving data from a server
Congratulations you've implemented randomized team distribution. As I'm sure you've noticed, up until now you've worked on a hard coded list of people. Obviously that's not going to cut it. In this lesson we are going to get rid of that hard coding and start retrieving data from a backend server using the [Http](http://package.elm-lang.org/packages/elm-lang/http/latest) package in Elm.



## Short interlude - Json Decoding
Our backend server returns Json. But Elm doesn't have any automagical tranformation from Json to Elm data types. You'll have to make that conversion using the [Json.Decode](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode) module. People new to Elm quite often get tripped up by json decoding, so it's worth spending a few minutes covering the basics.


**Repl time again**
- `cd lesson5`
- `elm-repl`


```elm

import Json.Decode as Decode


type alias Point = { x : Int, y : Int }

pointJson = """{"x": 1, "y": 2}"""


Decode.decodeString

Decode.decodeString
    (Decode.map2 Point
        (Decode.field "x" Decode.int)
        (Decode.field "y" Decode.int)
    )
    pointJson



pointDecoder =
    Decode.map2 Point
        (Decode.field "x" Decode.int)
        (Decode.field "y" Decode.int)

faultyPointJson = """{"x": "1", "y": 2}"""

-- should give an error
Decode.decodeString pointDecoder faultyPointJson


-- List of points
pointListJson = """[{"x": 1, "y": 2}, {"x": 5, "y": 6}]"""

Decode.decodeString (Decode.list pointDecoder) pointListJson

-- Unwrapping that result
Decode.decodeString (Decode.list pointDecoder) pointListJson
    |> Result.withDefault []
    |> List.map .x
    |> List.sum


-- Dealing with null
type alias LogEntry = { message : String, details : Maybe String }

logEntryJson = """{"message": "Logged in", "details": null}"""

logEntryDecoder =
    Decode.map2 LogEntry
        (Decode.field "message" Decode.string)
        (Decode.field "details" (Decode.maybe Decode.string))

Decode.decodeString logEntryDecoder logEntryJson

-- Composition
type alias Line = { start : Point, end : Point}

lineJson = """{"start": {"x": 1, "y": 2}, "end": {"x": 5, "y": 6}}"""

lineDecoder =
    Decode.map2 Line
        (Decode.field "start" pointDecoder)
        (Decode.field "end" pointDecoder)

Decode.decodeString lineDecoder lineJson


```

There's obviously more to it, but this should be more than enough to get you started handling Json responses from a backend.


## The Http Package
Http is a separate package that you'll need to add to your project.
In a terminal:
- `cd lesson5`
- `elm-package install elm-lang/http`
- Accept the suggestion from the Elm package manager
- Feel free to open `lesson5/elm-package.json` and see that the http package has been added as a dependency


You'll find the documentation for the package [here](http://package.elm-lang.org/packages/elm-lang/http/latest/Http)


The two functions you'll be using in your assignment is
- `get` : This function creates a `Request`. However you'll be needing a command so you'll need to pass that request on to the other function you'll be using
- `send` : This function turns a `Request` into a `Cmd`, something that fits nicely into what we need !

```elm
Http.get "http://myserver.com/artists" artistsDecoder
        |> Http.send ArtistListResponse
```



> What the fark is this `(Result Error a -> msg)` ?

> Well, 2 things can fail when dealing with Http. One is that the http request can fail, the other thing that can fail is the Json decoding. We need to deal with both the success case and the error case. `Result` is a type that capture this dualstate of success or error.

> ```elm type Result error value = Ok value | Err error```
A `Result` can either be `Ok` with a value or it can be `Err` with an error

So you might have a message defined like this:

```elm
type Msg = ArtistListResponse (Result Http.Error (List Artist))
```

In your update function you might deal with it like this

```elm
update msg model =
    case msg of
        ArtistListResponse res ->
            case res of ->
                Result.Ok artists ->
                    -- store the list in your model probably

                Result.Err err ->
                    -- Store the error so that you can notify the user of an error
                    -- Or (shudder) just ignore it (:

```


## Your assignment
You are going to get rid of the hard coded list of people and retrieve them from a backend server. You should:
- Create a new function `getPeople` that creates a Cmd representing a Http request
  - The url you'll be calling is `http://localhost:5001/people`
  - You'll need to write a Json decoder, the format you'll be decoding is given by the json defined in `lesson5/db.json`
- You'll need to define a new Msg tag
- You'll need to add handling of this new message in your update function
- You should initiate loading of the data when your application starts (hint `init`)


**Getting started**
- If you haven't already installed the http package, do that first (see previous chapter)
- Open a terminal and
  - `cd lesson5`
  - `npm install`
  - `npm run dev`
  - `open http://localhost:5000`
- Open another terminal for your api server
  - `cd lesson5`
  - `npm run api`
- Open your Editor and start working your magic





