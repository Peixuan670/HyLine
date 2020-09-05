script=$1
topo=$2

for fix in 6 13 19 33 53 133 667 1333 3333 6667 20000
do
CDF_file="CDF_${fix}.tcl"

resultfile="result-${CDF_file}.txt"
eval "rm $resultfile"
#for alg in "DropTail" "AFQ10UlimPL" "AFQ10PL" "HRCCPL" "AFQ100PL" "AFQ1000PL"
for alg in "AFQ10UlimPL"
do
  cmd="./tcp.sh $script $topo ${CDF_file} $alg"
  echo $cmd
  eval $cmd
  eval "echo -n \"${alg} \" >> $resultfile"
  eval "cat tcp_${alg}_${topo}_${CDF_file}.tr | awk '{print \$14}' >> $resultfile"
done

done
