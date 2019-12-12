import os, system, osproc, strformat
import ja_utils


if paramCount() < 1:
    echo "Please pass at least one argument!"
    quit()

if paramStr(1) == "-h" or paramStr(1) == "--help":
    echo """
    jack_helper (jh) command-line utility to help make and restore JACK configs.
    Usage:
        argument1: input file, "clean", "dump"
        - If you pass an input file it reads this as loading a configuration.
        - If you pass "clean" it will disconnect all connections on the JACK server.
        - If you pass "dump" it will create a new configuration of the current settings.
        
        argument2: "path/to/dump"
        - The name of a file to dump the current configuration to.
    """
# ----- LOAD ----- #
if paramStr(1) != "clean" and paramStr(1) != "dump":
    var config: File
    try: config = open(paramStr(1),fmRead)
    except IOError:
        echo "Invalid input file."
        quit()
    connectPlugs(config)

# ----- DISCONNECT ----- #
if paramStr(1) == "clean":
    var chain = createChain()
    for link in chain:
        discard execCmd(fmt"jack_disconnect {link.plug} {link.socket}")

# ----- DUMP ----- #
if paramStr(1) == "dump":
    if paramCount() == 2:
        var cfgOutput: File
        try: 
            cfgOutput = open(paramStr(2), fmWrite)
        except:
            echo "Error opening output file"
            quit()

        var chain = createChain()
        for link in chain:
            cfgOutput.writeLine(fmt"{link.plug} {link.socket}")
        cfgOutput.close()
        
    else:
        echo "You need to pass an output file to write the configuration to."
        quit()