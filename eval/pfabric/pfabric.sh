if [ "$#" == 4 ]
then
	rm pfabric_trace_$1_$2_$3_$4.tr
	rm pfabric_flow_$1_$2_$3_$4.tr
	rm pfabric_flow_sort_$1_$2_$3_$4.tr

	ns pfabric.tcl $1 $2 $3 $4 > pfabric_trace_$1_$2_$3_$4.tr
	sort -n pfabric_flow_$1_$2_$3_$4.tr > pfabric_flow_sort_$1_$2_$3_$4.tr
	echo $1 $2 $3 $4 >> pfabric_result.tr
	cat pfabric_flow_sort_$1_$2_$3_$4.tr | awk 'BEGIN {s1=0;s2=0;s3=0;s4=0;r1=0;r2=0;r3=0;r4=0;} {if(1460*$1 <=100000){s1+=$2;r1+=1} else if(1460*$1<=1000000){s2+=$2;r2+=1} else if(1460*$1<=10000000){s3+=$2;r3+=1} else {s4+=$2;r4+=1}} END{if(r1==0){w1=0;}else{w1=s1/r1;} if(r2==0){w2=0;}else{w2=s2/r2;} if(r3==0){w3=0;}else{w3=s3/r3;} if(r4==0){w4=0;}else{w4=s4/r4;}print  r1 " " w1 " " r2 " " w2 " " r3 " " w3 " " r4 " " w4 " " (s1+s2+s3+s4)/NR}' >> results.tr

elif [ "$#" == 3 ]
then
        pids=""
        names=""

        for ld in 0.95 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1
        do
		cmd="ns pfabric.tcl $1 $2 ${ld} $3 &> pfabric_trace_$1_$2_${ld}\_$3.tr &"
		name="pfabric_flow_$1_$2_${ld}_$3.tr"
		names="$names $name"
		rm $name
		echo $cmd
		echo $name
		eval $cmd
		pids="$pids $!"        #:$! is PID of last job running in background!
        done
        for pid in $pids; do
                echo "Waiting for $pid"
                wait $pid
        done

        for filename in $names; do
                echo "calculating final results for $filename..."
                echo $filename >> results.tr
                cat $filename | awk 'BEGIN {s1=0;s2=0;s3=0;s4=0;r1=0;r2=0;r3=0;r4=0;} {if(1460*$1 <=100000){s1+=$2;r1+=1} else if(1460*$1<=1000000){s2+=$2;r2+=1} else if(1460*$1<=10000000){s3+=$2;r3+=1} else {s4+=$2;r4+=1}} END{if(r1==0){w1=0;}else{w1=s1/r1;} if(r2==0){w2=0;}else{w2=s2/r2;} if(r3==0){w3=0;}else{w3=s3/r3;} if(r4==0){w4=0;}else{w4=s4/r4;}print  r1 " " w1 " " r2 " " w2 " " r3 " " w3 " " r4 " " w4 " " (s1+s2+s3+s4)/NR}' >> results.tr

                echo $filename "margin:10">> results_retrans.tr
                cat $filename | awk 'BEGIN {s1=0;s2=0;s3=0;s4=0;s5=0;r1=0;r2=0;r3=0;r4=0;r5=0;} {if(1460*$1<=100000 && $4>0){s1+=$4;r1+=1} else if (1460*$1<=1000000 && $4>0) {s2+=$4;r2+=1} else if (1460*$1<=10000000 && $4>0) {s3+=$4;r3+=1} else if (1460*$1<=100000000 && $4>0) {s4+=$4;r4+=1}} END{print  r1 " " s1 " " r2 " " s2 " " r3 " " s3 " " r4 " " s4 " "(s1+s2+s3+s4) }' >> results_retrans.tr

        done
else
        echo "usage: [# of flows] [queue size] [load] [topology]"
fi




