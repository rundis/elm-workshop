# Lesson 3 - Working with Elm Html


In this lesson we will be learning a bit more about the HTML functions in Elm. We'll start by creating a hard coded view for our team distribution.


## Short introduction
```elm

import Html
import Html.Attributes as Attributes


main =
    Html.h1
        [ Attributes.class "custom-header" ]
        [ Html.text "My heading" ]

```

All html elements have a corresponding Elm function
* The first argument is a list of attributes
* The second argument is a list of child elements
* Attributes can be created using functions in the `Html.Attributes` module



## It's all functions yo !
Composing your view is done by using all the power of Elm. So you can map, filter, split out stuff to functions etc. No half-assed templating language, just a pure functional language at your disposal.


```elm

items = ["Item 1", "Item2", "Item3", "Item4" ]

viewItems =
  Html.ul []
    (List.map (\item -> Html.li [] [ Html.text item ] ) )

```


## Common pitfalls
* Trying to return a list of elements from you top level view function.
* Forgetting parens when concatting elements or mapping over them


```elm
viewItems =
  Html.ul []
    List.map (\item -> Html.li [] [ Html.text item ] )

```
When the compiler evaluates `Html.ul` it's looking for two list arguments
but what you are giving here is [] and List.map ... the second one is a function and the compiler will politely ask you to correct the mistake !



## Your assignment
The `lesson3` folder contains some example code to get you started. Your task is to complete the listing of people and provide a hard coded team distribution with the given team size (of 4). To help you out there is even a helper function to partiion lists in case you didn't complete that in the previous lesson :)


To give you a sane feedback loop, we've had to pull in some JavaScript stuff because the elm-reactor doesn't support hot reloading.


To get started:
* `cd lesson3`
* `npm install` - this will install a dev server with hot reloading support
* `npm run dev`
* `open http://localhost:5000`

Open up your favorite Editor and start editing `src/Main.elm`. When you save, the page will reload with your changes (or go blank, then you should check your console because you've just had a compile error)


> Don't let the compiler errors scare you, take your time to read them. They are generally quite helpful... but not always, ask if you're stuck.
