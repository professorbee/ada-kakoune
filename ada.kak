hook global BufCreate (.*/)?(.*\.(adb|ads)) %{ set-option buffer filetype ada }

# Declare highlighter groups
add-highlighter shared/ada      group
add-highlighter shared/ada/code group

# Region highlighters
add-highlighter shared/ada/regions         regions
add-highlighter shared/ada/regions/string  region -match-capture '"'  '"' fill string
add-highlighter shared/ada/regions/comment region -match-capture '--' '$' fill comment

# Reserved words, from Ada Reference Manual section 2.9.
# Separated by pipes to make it valid regex.
evaluate-commands %sh{
    keywords="abort|else|new|return|elsif|reverse|abstract|end|null"
    keywords="${keywords}|accept|entry|select|access|exception|of|separate"
    keywords="${keywords}|aliased|exit|or|some|all|others|subtype|and|for|out"
    keywords="${keywords}|synchronized|array|function|overriding|at|tagged"
    keywords="${keywords}|generic|package|task|begin|goto|pragma|terminate|body"
    keywords="${keywords}|private|then|if|procedure|type|case|in|protected"
    keywords="${keywords}|constant|interface|until|is|raise|use|declare|range"
    keywords="${keywords}|delay|limited|record|when|delta|loop|while|digits"
    keywords="${keywords}|renames|with|do|requeue|not|xor|mod|rem|abs"

    # Add the language's grammar to the static completion list
    printf '%s\n' "hook global WinSetOption filetype=ada %{
        set-option window static_words '${keywords}'
    }" | tr '|' ':'
    # Highlight keywords
    printf "%s\n" "add-highlighter shared/ada/code/ regex \b(?i)(${keywords})\b 0:keyword"
}

# Operators. Symbols were deduplicated, e.g. := is just : and =.
add-highlighter shared/ada/code/ regex \
    (=|<|>|\+|–|&|\*|/|:) \
    0:operator

# Decimal Literals (Ada 2012 RM section 2.4.1)
# Examples: 0.01, 000001, 1234_5678, 1_2_3.4_5_6e+12
add-highlighter shared/ada/code/ regex \
    ([^\w]+)([0-9][0-9_]*)(\.[0-9_]+)?(([Ee][+-]?)([0-9_]+))? \
    2:value 3:value 5:operator 6:value

# Based Literals (Ada 2012 RM section 2.4.2)
# Examples: 16#e#E-1, 2#1.1111_1111_1110#e11, 16#CAFE_F00D#
add-highlighter shared/ada/code/ regex \
    ([0-9]{1,2})(#)([0-9_.a-fA-F]+)(#)(([Ee][+-]?)([0-9]+))? \
    1:value 2:operator 3:value 4:operator 6:operator 7:value

# Types in declarations and function arguments
add-highlighter shared/ada/code/ regex \
    (?i)(?::\s+)(?!declare)(?!loop)(?:constant\s+)?(?:in\s+)?(?:out\s+)?(?:not\s+null\s+)?(?:access\s+(?:all\s+)?)?(?:aliased\s+)?([\w.]+)? \
    1:type

# Function names and return types
add-highlighter shared/ada/code/ regex \
    '(?i)function\s+([\w.]+)\s*(\([\s\w_.:;,]*\))?\s+return\s+([\w.]+)' \
    1:function 3:type

# Procedure names
add-highlighter shared/ada/code/ regex \
    (?i)procedure\s+([\w.]+) \
    1:function 2:function

# Labels (for goto)
add-highlighter shared/ada/code/ regex \
    (?i)<<([\w]+)>> \
    1:meta

# Labels (for named blocks)
add-highlighter shared/ada/code/ regex \
    (?i)([\w]+)\s+:\s+(declare|loop) \
    1:meta

#
# Highlight types in type declarations
# 

# Subtype declarations
add-highlighter shared/ada/code/ regex \
    (?i)subtype\s+([\w]+)\s+is\s+([\w]+) \
    1:type 2:type

# Array declarations
add-highlighter shared/ada/code/ regex \
    (?i)type\s+([\w]+)\s+is\s+array\s*\(([\w.]+)(\s+range\s+[\w.\s<>]+)?\)\s+of\s+(aliased\s+)?([\w.]+) \
    1:type 2:type 5:type

# New type declarations
add-highlighter shared/ada/code/ regex \
    (?i)type\s+([\w]+)\s+is\s+new\s+(?:([\w.]+)\.)?([\w]+) \
    1:type 2:module 3:type

# Record declarations
add-highlighter shared/ada/code/ regex \
    (?i)type\s+([\w]+)\s+is\s+(tagged\s+)?(null\s+)?record \
    1:type

#
# Highlight things with apostrophes
#

# '(...) Initialisers
add-highlighter shared/ada/code/ regex \
    (?i)([\w.]+)(?='\() \
    1:type

# I considered using the attribute list from the RM to highlight
# things based on attributes they've been given, but that turned out
# to be pretty complicated. You'll just have to live without that.

# 
# Default settings
#

define-command -hidden Ada_Adjust_Indentation_On_New_Line %~
    eval -draft -itersel %!
        # Preserve previous line indent
        try %{ execute-keys -draft \;K<a-&> }
        # De-indent certain words
        try %{ execute-keys -draft <a-x> <a-k> (is|then|exception|begin|end)\h*$<ret> <a-lt> }
        # Clean up trailing whitespace on the previous line
        try %{ execute-keys -draft k<a-x> s \h+$<ret>d }
        # Copy comments prefix (--)
        try %{ execute-keys -draft \;<c-s>k<a-x> s ^\h*\K-{2,}<ret> y<c-o><c-o>P<esc> }
    !
~

hook global WinSetOption filetype=ada %{
    set-option window aligntab     false
    set-option window indentwidth  3
    set-option window tabstop      3
    set-option window comment_line "--  "

    # Clean up trailing whitespaces when exiting insert mode.
    hook window InsertEnd  .*  %{ try %{ exec -draft <a-x>s^\h+$<ret>d } }
    hook window InsertChar \n  Ada_Adjust_Indentation_On_New_Line
}

hook global WinSetOption filetype=ada       %{ add-highlighter window/ ref ada }
hook global WinSetOption filetype=(?!ada).* %{ remove-highlighter window/ada }
hook global WinSetOption filetype=(?!ada).* %{ remove-hooks window kak-indent }

