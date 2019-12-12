import osproc, strformat, strutils

type Connection* = object
    plug*: string
    socket*: string

proc createChain*(): seq[Connection] =
    var connections = execCmdEx("jack_lsp -c").output.split("\n")
    var currentNode:string
    var tChain = newSeq[Connection]()
    var tConnection:Connection

    for i in 0..len(connections)-2: # ignore the last two blanks
        if not connections[i].startsWith("   "):
            currentNode = connections[i]
        else:
            tConnection.plug = currentNode
            tConnection.socket = connections[i].strip()
            tChain.add(tConnection)

    for i in 0..len(tChain)-1:
        for j in 0..len(tChain)-1:
            if tChain[i].plug == tChain[j].socket and tChain[i].socket == tChain[j].plug:
                tChain.delete(j)
    return tChain

proc connectPlugs*(configuration: File): void =
    for row in configuration.lines():
        discard execCmd(fmt"jack_connect {row}")