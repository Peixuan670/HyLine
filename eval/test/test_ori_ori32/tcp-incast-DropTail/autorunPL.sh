
alg=$1
topo=$2
flow=$3


./tcp-${alg}.sh ${flow} 0.1 ${topo}
rm tcp_${alg}*

./tcp-${alg}.sh ${flow} 0.3 ${topo}
rm tcp_${alg}*

./tcp-${alg}.sh ${flow} 0.5 ${topo}
rm tcp_${alg}*

./tcp-${alg}.sh ${flow} 0.7 ${topo}
rm tcp_${alg}*

./tcp-${alg}.sh ${flow} 0.9 ${topo}
rm tcp_${alg}*

#cmd="./${alg}.sh ${flow} 0.3 ${topo}"
#cmd="rm tcp_${alg}*"

#cmd="./${alg}.sh ${flow} 0.5 ${topo}"
#cmd="rm tcp_${alg}*"

#cmd="./${alg}.sh ${flow} 0.7 ${topo}"
#cmd="rm tcp_${alg}*"

#cmd="./${alg}.sh ${flow} 0.9 ${topo}"
#cmd="rm tcp_${alg}*"
