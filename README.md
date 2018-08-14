# Ada mode for Kakoune

This file provides syntax highlighting for Ada in Kakoune.

To install, chuck the file in your autoload folder.

## Status

I don't consider this complete quite yet -- I'd like the auto-indentation to be
consistent and predictable first.

Other reasonable improvements I'd like to make:
 - Auto-fill `begin ... end Thing;` when you type `is`
 - Provide a convenient means to type those big box-comments
 - Correctly align long lists of aspects (`with Pre => ..., Post => ...`)
 - Maybe highlight `end Pack;` or `end Func;` correctly. Probably too hard,
though.

Hopefully you find this useful. Feel free to open an issue if you encounter 
any problems.

## Preview

![](https://wtok.keybase.pub/ada-kakoune.png)


