# Workshop - Building Web Apps with Elm

It's about time you started learning some Elm ! This workshop will (hopefully) get you to a stage where you will be able to make a Web Application using Elm on your own (*).

To make the most of the limited time we have for the workshop, there are few things that I need you to set up prior to the workshop.

>(*) This workshop is not a complete tutorial on the Elm language. It's highly recommended to check out the
official [Elm Guide](https://guide.elm-lang.org/) to get a better understanding of how Elm works in general !



## Overview
* Lesson 1 - [Getting started](lesson1/README.md)
* Lesson 2 - [A quick Elm 1 on 1](lesson2/README.md)
* Lesson 3 - [Working with Elm Html](lesson3/README.md)
* Lesson 4 - [Implementing Randomization](lesson4/README.md)
* Lesson 5 - [Retrieving data from a server](lesson5/README.md)
* Lesson 6 - [Introducing Navigation](lesson6/README.md)
* Lesson 7 - [Talking to JavaScript](lesson7/README.md)


## Installing Elm (and a few other tidbits)
Please install Elm and set up your editor before the workshop ! If you have any problems, get in touch and we'll work it out.


### Install Node (/npm ..or yarn if that's your thing)
If for some weird reason you haven't got node/npm on your machine, you need to get that installed for some parts of the workshop. If you are on Linux, you'll deffo need it regardless.

* **Recommended:** install via a version manager like **nvm**
  * For OS X and Linux install [**nvm**](https://github.com/creationix/nvm)
    * `nvm install --lts`
  * For Windows install [**nvm-windows**](https://github.com/coreybutler/nvm-windows)
    * 64-bit: `nvm install 6.10.0 64`
    * 32-bit: `nvm install 6.10.0 32`
* Or download from [nodejs.org](https://nodejs.org)


### Installing Elm
  - [Mac installer](http://install.elm-lang.org/Elm-Platform-0.18.pkg)
  - [Windows installer](http://install.elm-lang.org/Elm-Platform-0.18.exe)
  - Whatever else: `npm install -g elm`

### Installing Elm Format
You don't have to install this, but you might as well get used to it from the get go. It ensures
that your code style follows the community guidelines from the get go. You'll probably have issues with
the amount of whitespace it introduces, but once you get used to it you'll really start to appreciate it.
No more formatting discussions, and you can spend the time writing awesome Elm code instead.


- Mac: [download](https://github.com/avh4/elm-format/releases/download/0.6.1-alpha/elm-format-0.18-0.6.1-alpha-mac-x64.tgz)
- Linux: [download](https://github.com/avh4/elm-format/releases/download/0.6.1-alpha/elm-format-0.18-0.6.1-alpha-linux-x64.tgz)
- Windows: [download](https://github.com/avh4/elm-format/releases/download/0.6.1-alpha/elm-format-0.18-0.6.1-alpha-win-i386.zip)

or you should be able to use `npm -g install elm-format`



## Choosing and configuring an Editor

Most popular editors have some level of Elm support. **This workshop is not a good place to start learning a new editor completely from scratch, if in doubt choose an editor you are comfortable with !**


### [**Atom**](https://atom.io/)
Atom has some of the most advanced features for saving you from typing. In particular elmjutsu has some really nifty features. This seems to be the most popular editor in the Elm community at the moment.

* [**language-elm**](https://github.com/edubkendo/atom-elm)
* [**linter-elm-make**](https://github.com/mybuddymichael/linter-elm-make)
* [**elm-format**](https://github.com/triforkse/atom-elm-format)
* [**elmjutsu**](https://github.com/halohalospecial/atom-elmjutsu)

If you install elmjutsu, you should turn off the autocompleter in linter-elm-make (using the package manager in Atom) and use the autocompleter that comes with elmjutsu.


### [**Light Table**](http://lighttable.com/)
Has a ton of features, many of which you don't need for this workshop. But the repl integration alone might be worth considering it as a "second" editor. Oh and I'll be showing things using it. But yeah it's a niche thing so if you've never used it before ... I'm happy to help anyone interested getting in configured (but please contact me before the workshop so we get you sorted well in advance).

Check out the [guide](https://rundis.gitbooks.io/elm-light-guide/content/) if you are interested in trying it out.



### !! Heads up !!
>For the remaining editors you'll need to install elm-oracle to get autocompletions.
`npm -g install elm-oracle`


### Emacs
There's an [elm-mode](https://github.com/jcollard/elm-mode) !


### Sublime
A good choice if you're undecided and just needs something that is simple to get started with and that is great at editing text.

* Via [**Package Control**](https://packagecontrol.io/)
  * **Elm Language Support**
  * **Highlight Build Errors**

### [**VS Code**](https://code.visualstudio.com/)
* [**vscode-elm**](https://github.com/sbrink/vscode-elm)
  * `ext install elm`


### Vim
*Vim** (with a package manager like [vim-plug](https://github.com/junegunn/vim-plug) or [Vundle](https://github.com/VundleVim/Vundle.vim))
  * [**Valloric/YouCompleteMe**](https://github.com/Valloric/YouCompleteMe)
    * General Vim autocompletion.
  * [**w0rp/ale**](https://github.com/w0rp/ale)
    * **Recommended:** General Vim linting and typechecking.
    * **NOTE:** Requires NeoVim or Vim 8.
  * [**vim-syntastic/syntastic**](https://github.com/vim-syntastic/syntastic)
    * General Vim linting and typechecking.
    * **NOTE:** Use if you're not using NeoVim or Vim 7.
  * [**ElmCast/elm-vim**](https://github.com/ElmCast/elm-vim)
    * Syntax highlighting, indentation, autocompletion, autoformatting.
    * Requires previous Vim plugins.


### IntelliJ
Check out the following [elm-plugin](https://durkiewicz.github.io/elm-plugin/).
(To get elm-format working you'll need to follow these instructions https://github.com/avh4/elm-format/blob/master/README.md#jetbrains-installation)





