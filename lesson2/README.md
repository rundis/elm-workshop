# Lesson 2 - A quick Elm 1 on 1


Let's spend a little time getting to know some basic Elm syntax.
We'll be using the Elm repl (or if your Editor has repl integration by all means use that).


In a terminal window:
* `cd lesson2`
* `elm-repl`
* evaluate each expression and observe the results
* Feel free to experiment on your own too !


> When evaluating multiline expressions in the repl, you need to terminate each line with a backslash !
![Elm Repl](https://github.com/rundis/elm-workshop/blob/master/lesson2/repl.png)


## Values

```elm
a = 2
b = "Hello"
c = 'C'
d = 1.1
e = (2,3)
f = {x = 1, y = 2}
g = [1,2,3]
```


## Functions
```elm
add a b =
  a + b

add 2 2

-- The above actually evaluates to
(add 2) 2


addLambda = (\a b -> a + b)

addLambda 2 2


-- Currying
inc = add 1
dec = add -1

inc 4
dec 4

-- Let
average values =
  let
    count = List.length values
    -- count = count + 1 -- try uncommenting
  in
    (List.sum values) // count


average [1,2,3,4]


-- infix/prefix
1 + 1
(+) 1 1



-- composition
(>>)
doubleInc = inc >> inc
doubleInc 3


(<<)
toString
stringedDec = toString << dec
stringedDec 2

-- Function application

(<|)  -- avoiding parens
add 2 (add 2 2)
add 2 <| add 2 2


-- much more useful (Clojure peeps, think thread last)
(|>)
add 2 2
  |> add 2
  |> inc
  |> (\x -> x * x )
```



## Working with lists
Reference : http://package.elm-lang.org/packages/elm-lang/core/latest/List

```elm
List.map
List.map (\x -> x + 1) [1,2,3]
List.map inc [1,2,3]
List.map ((+) 1) [1,2,3]  -- see what's happening here ?


List.filter
List.filter (\x -> x < 3) [1,2,3,4]
List.filter ((>) 3) [1,2,3,4]


List.foldl
List.foldl (\acc x -> acc + x) 0 [1,2,3,4]
List.foldl add 0 [1,2,3,4]


List.map2
List.map2 (\x y -> (x,y)) ["a","b","c"] [1,2,3]
List.map2 (,) ["a","b","c"] [1,2,3]


List.take 2 [1,2,3,4]
List.drop 2 [1,2,3,4]


List.append [1,2,3] [1,2,3]
[1,2,3] ++ [1,2,3]
List.concat [[1,2,3], [1,2,3]]


(::)
1 :: [2,3,4]
```


## Recursion detour
Elm supports tail recursion (transformed to while loops in JS). Using recursion in combination
with pattern matching will allow you to create elegant and efficient functions.
The core library of Elm is quite small (unlike say Clojure), so you'll most likely miss some list related functions. You could use something like the [list-extra](http://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra) package, or if it's just a one off thing and you don't want to add a dependency for that, rolling your own isn't that hard !




```elm
myReverse xs =
  case xs of
    head :: tail ->
      myReverse tail ++ [head]

    [] ->
      []

myReverse [1,2,3]


myReverseVerbose xs =
  let
    head = List.head xs
    tail = List.tail xs
  in
    case (head, tail) of
      (Just h, Just t) ->
        myReverseVerbose t ++ [h]

      _ ->
        []


-- of course in this instance you could just write
List.reverse [1,2,3]
```


## Defining your own types

### Union types / tagged types

```elm
-- a here is a type variable, ie it can be any type (a bit like the T in  List<T> for Java )
type Option a = Some a | None

Some
Some 1
Some "Hello"
None


optionedMap fn optionValue =
  case optionValue of
    Some v ->
      Some (fn v)

    None ->
      None


optionedMap inc (Some 1)
optionedMap inc None


-- Elm already has a type like this
-- type Maybe a = Just a | Nothing

List.head [1,2,3]
List.head []

Maybe.map (\v -> v + 1) (List.head [1,2,3])
Maybe.map inc (List.head [1,2,3])

Maybe.withDefault 0 (List.head [1,2,3])
```


### Type aliases (and records)

A type alias is just an alias for another type. Mostly you'll use them for records.
They are really handy when you'd like to type annotate your functions.



```elm
type alias Person = { age : Int, name : String}

magnus = Person 43 "Magnus"
magnusAlt = { age = 43, name = "Magnus" }

magnus.age
.age magnus -- this is handy when working with lists and such


-- unfortunately you can't apply type annotations in the repl
-- getAverageAge : List Person -> Int
getAverageAge people =
  List.sum (List.map .age people) // List.length people


getAverageAge [Person 43 "Jane", Person 36 "Doe"]


-- updating
olderMagnus = { magnus | age = magnus.age + 1 }


```


### Bonus
* We really need a partionBy function. Try implementing one such that:
  * `partitionBy 2 [1,2,3,4] == [[1,2], [3,4]]`
  * `partitionBy 2 [1,2,3] == [[1,2], [3]]`
  * `partitionBy 2 [] == []`



* Implement your own list function `first` (as opposed to List.head) with the following signature
`first : List a -> Option a`

* Safe move challenge
  * A `Position` is defined by an `x` and a `y`
  * You are only allowed to move to the left, right, up or down
  * Define the types necessary and implementation for a function with the following signature
  `move : Int -> Direction -> Position -> Position`
