# Lesson 1 : Getting started


__We are about to build a web application for (randomly) distribute people to teams.
So given a list of people and a given number of teams our app should be able to come
up with a random team distribution. Preferably with the same number of participants per team (or as close as possible). Of course the requirements are whishy-washy and will change along the way as they generally do in any real-life project.__



We'll start really slowly, just to get you into the groove.


## Hello world
Using the terminal:
* `git clone https://github.com/rundis/elm-workshop`
* `cd lesson1`
* `elm-package install`
* Approve what the kind package manager suggests for you !
* create a file Main.elm with the following contents

```elm
import Html

main =
  Html.text "Hello Team Distributor"
```
Back to the terminal;
* `elm-make Main.elm`
* `open index.html`
* Voila


## Upsetting the compiler
* Change `Html.text` to `Html.tex`
* `elm-make Main.elm`
* The compiler should give you some friendly advice


## elm-reactor
Elm reactor is a simple web server that ships with Elm. It will serve your
elm files (after compiling them). It's handy when you want to test your elm application.

* `elm-reactor` - Starts a web server on port 8000
* `open http://localhost:8000`
* In the file navigator, select the file `Main.elm`
* Make a change to the Main.elm file and reload your browser window
* The changes should take effect
* Try making it fail just for fun too


## Bonus
* Have a peak at the file elm-package.json
* do `tree elm-stuff`
* Go crazy with the available `Html.*` functions like
  * `Html.h1 [] [ Html.text "Hello" ]` or
  * ```elm
  Html.div
      []
      [ Html.h1 [] [ Html.text "Hello"]
      , Html.p [] [ text "I'm a paragraph" ]
      ]```
