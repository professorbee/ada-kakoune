# Ada mode for Kakoune

This file provides syntax highlighting for Ada in Kakoune, as well as some other
small benefits like auto-indentation (which doesn't yet work perfectly).

To install, chuck the file in your autoload folder.

There are some improvements I'd like to make before I call this complete.

The main pain point is that `begin` and other such keywords aren't reduced in
indentation when you insert them. In the meantime, make heavy use of the `<` and
`>` keys.

Other reasonable improvements I'd like to make:
 - Auto-fill `begin ... end Proc;` when you type `is`
 - Correctly auto-indent long lists of aspects (`with Pre => ..., Post => ...`)
 - Maybe highlight `end Pack;` or `end Func;` correctly. Probably too hard,
though.

Anyway, hopefully you find this useful. Feel free to open an issue if you
encounter any problems.

# Preview

![](https://wtok.keybase.pub/ada-kakoune.png)


