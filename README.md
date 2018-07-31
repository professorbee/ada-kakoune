# Ada mode for Kakoune

This file provides syntax highlighting for Ada in Kakoune, as well as some other
small benefits like auto-indentation.

To install, chuck the file in your autoload folder.

This is still in development and there are a few things I want to fix before I
call it complete.

That said, the highlighting is quite serviceable at this point, and this should
be good to use.

The main pain point is that `begin` and other such keywords aren't reduced in
indentation when you insert them, which is more annoying than it sounds.

Other reasonable improvements I'd like to make:
 - Highlight types
 - Auto-fill `begin ... end Proc;` when you type `is`
 - Correctly auto-indent long lists of aspects (`with Pre => ..., Post => ...`)

Anyway, hopefully you find this useful. Feel free to open an issue if you
encounter any problems.

