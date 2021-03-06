
filepath=

terminal=
format=text
record_number_start=1

while [ $# -gt 0 ]; do
    a=$1
    shift
    if [ "$a" = "-o" ]; then
        filepath=$1
        shift
    elif [ "$a" = "--terminal" ]; then
        terminal=1
    elif [ "$a" = "--tsv" ]; then
        format=tsv
    elif [ "$a" = "--json" ]; then
        format=json
    elif [ "$a" = "--text" ]; then
        format=text
    elif [ "$a" = "--textsimple" ]; then
        format=textsimple
    elif [ "$a" = "--string" ]; then
        format=string
    elif [ "$a" = "--record-number-start" ]; then
        record_number_start=$1
        shift
    else
        echo "Unknown parameter: $a" >&2
        exit 1
    fi
done

if [ -n "$terminal" ]; then
    if [ $format = tsv ]; then
        perl $XSVUTILS_HOME/src/table.pl \
             --col-number --record-number --record-number-start $record_number_start \
             --color | \
            less -iSRX
    elif [ $format = json ]; then
        if type jq >/dev/null 2>&1; then
            jq . -C | less -iSRX
        else
            exec less -iSRX
        fi
    elif [ $format = text ]; then
        exec less -iSRXN
    elif [ $format = textsimple ]; then
        exec less -iSRX
    else
        exec less -iSRXF
    fi
else
    if [ -z "$filepath" ]; then
        exec cat
    else
        exec cat > "$filepath"
    fi
fi


