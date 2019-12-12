# ja (jack assist)

## Usage

This command line utility is essentially a wrapper around other command-line utilities for JACK.

It allows you to restore configurations which are defined by line delimited connections in a file.

For example in a file called **RTOM**.
```
REAPER:out1 Max:in1
REAPER:out3 Max:in6
```

To then call this 'preset' you would run `ja <path/to/config>`

## Installation
1. `git clone` this repo.

2. `cd` to it.

3. run `nimble install`

NOTE: Make sure that the .nimble directory is in your path.

## TODO
Much of this sits as a wrapper to other command-line calls such as `jack_lsp -c` and `jack_connect`. Ideally I could convert these to use some bindings to JACK in order to manage the server in a more direct way.