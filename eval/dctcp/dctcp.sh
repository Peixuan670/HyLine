if [ "$#" == 3 ]
then
        pids=""
        names=""
        ld=$2
        cmd="ns dctcp.tcl $1 ${ld} $3 &> dctcp_trace_$1_${ld}_$3.tr &"
        name="dctcp_flow_$1_${ld}_$3.tr"
        names="$names $name"
        rm $name
        echo $cmd
        echo $name
        eval $cmd
        pids="$pids $!" 
        for pid in $pids; do
                echo "Waiting for $pid"
                wait $pid
        done
elif [ "$#" == 2 ]
then
        pids=""
        names=""
        for ld in 0.95 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1
        do
	      	cmd="ns dctcp.tcl $1 ${ld} $2 &> dctcp_trace_$1_${ld}_$3.tr &"
                name="dctcp_flow_$1_${ld}_$2.tr"
                names="$names $name"
                rm $name
                echo $cmd
                echo $name
                eval $cmd
                pids="$pids $!"
        done
        for pid in $pids; do
                echo "Waiting for $pid"
                wait $pid
        done
else
        echo "usage: [# of flows] [load] [topology]"
fi

