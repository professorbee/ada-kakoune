hook global BufCreate (.*/)?(.*\.(adb|ads)) %{ set-option buffer filetype ada }

define-command -hidden Ada_Adjust_Indentation_On_New_Line %~
    eval -draft -itersel %!
        # Preserve previous line indent
        try %{ execute-keys -draft \;K<a-&> }
        # De-indent certain words
        try %{ execute-keys -draft <a-x> <a-k> (is|then|exception|begin|end)\h*$ <a-lt> }
        # Clean up trailing whitespace on the previous line
        try %{ execute-keys -draft k<a-x> s \h+$ <ret>d }
        # Align to opening paren of previous line
        try %{ execute-keys -draft [( <a-k> \([^\n]*\n[^\n]*\n? <ret> s \( <ret> '<a-;>' & }
        # Copy comments prefix (--)
        try %{ execute-keys -draft \;<c-s>k<a-x> s ^\h*\K-{2,} <ret> y<c-o><c-o>P<esc> }
    !
~

add-highlighter shared/ regions -default code -match-capture ada \
    string  '"' '"' '' \
    comment '(?<!\$)--' '$' ''

add-highlighter shared/ada/string  fill string
add-highlighter shared/ada/comment fill comment

%sh{
    # Reserved words, from Ada Reference Manual section 2.9.
    # Separated by pipes to make it valid regex.
    # Words used exclusively as operators (e.g. xor, mod, rem, abs) removed.
    keywords="abort|else|new|return|elsif|reverse|abstract|end|null"
    keywords="${keywords}|accept|entry|select|access|exception|of|separate"
    keywords="${keywords}|aliased|exit|or|some|all|others|subtype|and|for|out"
    keywords="${keywords}|synchronized|array|function|overriding|at|tagged"
    keywords="${keywords}|generic|package|task|begin|goto|pragma|terminate|body"
    keywords="${keywords}|private|then|if|procedure|type|case|in|protected"
    keywords="${keywords}|constant|interface|until|is|raise|use|declare|range"
    keywords="${keywords}|delay|limited|record|when|delta|loop|while|digits"
    keywords="${keywords}|renames|with|do|requeue|not"

    # Add the language's grammar to the static completion list
    printf '%s\n' "hook global WinSetOption filetype=ada %{
        set-option window static_words '${keywords}'
    }" | tr '|' ':'

    # Highlight keywords
    printf %s "add-highlighter shared/ada/code regex \b(${keywords})\b 0:keyword"
}

###################################
## Highlight regular expressions ##
###################################

# Massive thanks to regex101.com for saving me from countless regex-induced
# brain aneurysms.

# Operators. Symbols were deduplicated, e.g. := is just : and =.
add-highlighter shared/ada/code regex \
    (xor|mod|rem|abs|=|<|>|\+|–|&|\*|/|:) \
    0:operator

# Decimal Literals (Ada 2012 RM section 2.4.1)
# Examples: 0.01, 000001, 1234_5678, 1_2_3.4_5_6e+12
add-highlighter shared/ada/code regex \
    ([^a-zA-Z_])([0-9][0-9_]*)(\.[0-9_]+)?(([Ee][+-]?)([0-9_]+))? \
    2:value 3:value 5:default 6:value

# Based Literals (Ada 2012 RM section 2.4.2)
# Examples: 16#e#E-1, 2#1.1111_1111_1110#e11, 16#CAFE_F00D 
add-highlighter shared/ada/code regex \
    ([0-9]{1,2})(#)([0-9_.a-fA-F]+)((#)([Ee][+-]?)([0-9]+))? \
    1:value 2:operator 3:value 5:operator 6:default 7:value

# Highlight types in declarations and function arguments
add-highlighter shared/ada/code regex \
    (:\s+)(constant\s+)?(in\s+)?(out\s+)?(not\s+null\s+)?(access\s+(all\s+)?)?([a-zA-Z_0-9]+)? \
    8:type

# Highlight function names and function return types
add-highlighter shared/ada/code regex \
    (function|procedure)\s+([a-zA-Z_0-9.]+)(\s*\(.+\))?(\s+return\s+([a-zA-Z_0-9]+))? \
    2:function 5:type

# Highlight types in type declarations
add-highlighter shared/ada/code regex \
    (sub)?type\s+([a-zA-Z_0-9]+)\s+is\s+(new\s+|array\s*\(([a-zA-Z_0-9]+)[^\)]*\)\s+of(\s+aliased)\s+)?([a-zA-Z_0-9]+) \
    2:type 4:type 6:type

hook global WinSetOption filetype=ada %{
    set-option window aligntab false
    set-option window indentwidth 3
    set-option window comment_line "-- "

    # Clean up trailing whitespaces when exiting insert mode.
    hook window InsertEnd  .*  %{ try %{ exec -draft <a-x>s^\h+$<ret>d } }
    hook window InsertChar \n  Ada_Adjust_Indentation_On_New_Line
}

hook global WinSetOption filetype=ada       %{ add-highlighter window ref ada }
hook global WinSetOption filetype=(?!ada).* %{ remove-highlighter window/ada }
hook global WinSetOption filetype=(?!ada).* %{ remove-hooks window kak-indent }

