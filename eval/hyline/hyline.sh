if [ "$#" == 7 ]
then
	pids=""
	names=""
	wnd=$4
	host_edge_margin=220;
	edge_agge_margin=220;

	time=$5
	cmd="ns hyline.tcl $1 $2 $3 ${wnd} ${time} $6 $7 &> hyline_trace_$1_$2_$3_${wnd}_${time}_$6_$7.tr &"
	name="hyline_flow_$1_$2_$3_${wnd}_${time}_$6_$7.tr"
	names="$names $name"
	rm $name
	echo $cmd
	echo $name
	eval $cmd
	pids="$pids $!"	       #:$! is PID of last job running in background!
	for pid in $pids; do
		echo "Waiting for $pid"
		wait $pid
	done
	for filename in $names; do
		echo "calculating final results for $filename..."
		echo $filename >> results.tr
		cat $filename | awk 'BEGIN {s1=0;s2=0;s3=0;s4=0;r1=0;r2=0;r3=0;r4=0;Tw1=0;Tw2=0;Tp1=0;Tp2=0;Np1=0;Np2=0;} {if(1460*$1 <=100000){s1+=$2;r1+=1} else if(1460*$1<=1000000){s2+=$2;r2+=1} else if(1460*$1<=10000000){s3+=$2;r3+=1;Tw1+=$11;Tp1+=$12;Np1+=$13} else {s4+=$2;r4+=1;Tw2+=$11;Tp2+=$12;Np2+=$13}} END{if(r1==0){w1=0;}else{w1=s1/r1;} if(r2==0){w2=0;}else{w2=s2/r2;} if(r3==0){w3=0;}else{w3=s3/r3;Tw1=Tw1/r3;Tp1=Tp1/r3;Np1=Np1/r3;} if(r4==0){w4=0;}else{w4=s4/r4;Tw2=Tw2/r4;Tp2=Tp2/r4;Np2=Np2/r4;}print  r1 " " w1 " " r2 " " w2 " " r3 " " w3 " " r4 " " w4 " " (s1+s2+s3+s4)/NR " " Tw1 " " Tw2 " " Tp1 " " Tp2 " " Np1 " " Np2 " "}' >> results.tr
	done
elif [ "$#" == 6 ]
then
        pids=""
        names=""
        for ld in 0.95 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1
        do
		wnd=$4
                host_edge_margin=$8;
                edge_agge_margin=$7;

                time=$5
                cmd="ns hyline.tcl $1  $2 $3 ${wnd} ${time} ${ld} $6 &> hyline_trace_$1_$2_$3_${wnd}_${time}_${ld}_$6.tr &"
                name="hyline_flow_$1_$2_$3_${wnd}_${time}_${ld}_$6.tr"
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
		cat $filename | awk 'BEGIN {s1=0;s2=0;s3=0;s4=0;r1=0;r2=0;r3=0;r4=0;Tw1=0;Tw2=0;Tp1=0;Tp2=0;Np1=0;Np2=0;} {if(1460*$1 <=100000){s1+=$2;r1+=1} else if(1460*$1<=1000000){s2+=$2;r2+=1} else if(1460*$1<=10000000){s3+=$2;r3+=1;Tw1+=$11;Tp1+=$12;Np1+=$13} else {s4+=$2;r4+=1;Tw2+=$11;Tp2+=$12;Np2+=$13}} END{if(r1==0){w1=0;}else{w1=s1/r1;} if(r2==0){w2=0;}else{w2=s2/r2;} if(r3==0){w3=0;}else{w3=s3/r3;Tw1=Tw1/r3;Tp1=Tp1/r3;Np1=Np1/r3;} if(r4==0){w4=0;}else{w4=s4/r4;Tw2=Tw2/r4;Tp2=Tp2/r4;Np2=Np2/r4;}print  r1 " " w1 " " r2 " " w2 " " r3 " " w3 " " r4 " " w4 " " (s1+s2+s3+s4)/NR " " Tw1 " " Tw2 " " Tp1 " " Tp2 " " Np1 " " Np2 " "}' >> results.tr
        done
else
	echo "usage: [total number of flows:e.g. 40000] [Threshold: 1000000] [pfc enable/disable:1] [initial cwnd for big flows:e.g. 50] [min_rto for big flows:1s] [load] [Topology file name]"
fi
