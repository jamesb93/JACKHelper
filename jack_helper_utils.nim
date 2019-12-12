import osproc, strformat

type Actions* = object
    node*: string
    plug*: string

proc connectPlugs*(configuration: File): void =
    for row in configuration.lines():
        discard execCmd(fmt"jack_connect {row}")