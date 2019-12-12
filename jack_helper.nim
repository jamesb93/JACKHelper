import os, system, osproc, strutils, strformat
import jack_helper_utils


# Declare variables
var config: File

# Sanity Check
if paramCount() > 1 or paramCount() < 1:
    echo "Please pass one argument!"
    quit()
# If the user doesn't want to disconnect
if paramStr(1) != "disconnect":
    try: config = open(paramStr(1),fmRead)
    except IOError:
        echo "Invalid input file."
        quit()
    connectPlugs(config)

# If the user wants to disconnect
if paramStr(1) == "clean":
    var connections = execCmdEx("jack_lsp -c").output.split("\n")
    var currentNode: string
    var historyDisconnect = newSeq[Actions](0)
    var currentDisconnect: Actions

    for i in 0..len(connections)-2: # ignore the last two blanks
        if connections[i].startsWith("   "): # Find indented connections
            # Check that this connection doesn't exist somewhere in the record
            if len(historyDisconnect) == 0:
                currentDisconnect.node = currentNode
                currentDisconnect.plug = connections[i].strip()
                historyDisconnect.add(currentDisconnect)
            else:
                for history in historyDisconnect:
                    if history.node == connections[i].strip() and history.plug == currentNode:
                        echo currentNode, connections[i].strip()
                        discard execCmd(fmt"jack_disconnect {currentNode} {connections[i].strip()}")
                        currentDisconnect.node = currentNode
                        currentDisconnect.plug = connections[i].strip()
                        historyDisconnect.add(currentDisconnect)
        else:
            currentNode = connections[i]