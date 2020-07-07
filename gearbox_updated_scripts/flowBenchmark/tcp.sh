if [ "$#" == 4 ]
then
		script=$1
		flownum=1 
		load=0.5
		topology=$2
		CDF_file=$3
		alg=$4
        pids=""
        cmd="ns $script $flownum $load $topology ${CDF_file} $alg &> /dev/null &"
        echo $cmd
        eval $cmd
        pids="$pids $!" 
        for pid in $pids; do
                echo "Waiting for $pid"
                wait $pid
        done
fi

