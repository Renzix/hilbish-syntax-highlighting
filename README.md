# Syntax highlighting

This provides syntax highlighting to hilbish sh via, lua or both.

## Install

To install manually just git clone the repo

`git clone https://github.com/Renzix/hilbish-syntax-highlighting ~/.local/share/hilbish/libs/syntax-highlighting`

## Getting Started

then in your config

```lua
-- the rest of your plugins
local syntax = requires 'syntax-highlighting'

-- the rest of your config

hilbish.highlighter(syntax.sh) -- currently only raw sh is supported, others are coming
```

note the only plugin syntax-highlighting uses is lunacolors which should be
included with hilbish.

## License

Uses mpl2. The TLDR of the mpl is if you make any changes to any of the files
above its similar to the gpl however you are allowed to put these files side by
side with propretiary files (or any licensed files) which is unlike the gpl.
Nice faq from Mozzila [here](https://www.mozilla.org/en-US/MPL/2.0/FAQ/).
