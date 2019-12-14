#Autorun
#Put this in the Automatic director

dir1="k_new_same_weight_multiple_cubic_equal_large_bw"

# HCS
cp ../$dir1/HCS/HCS_out.tr out.tr
bash parse_result.sh
#echo $dir1
#echo ../$dir1/HCS/HCS_out.tr out.tr

sleep 5

mv ./results/* ../$dir1/HCS/

# AFQ10
cp ../$dir1/AFQ10/AFQ10_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ10/

# AFQ100
cp ../$dir1/AFQ100/AFQ100_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ100/

# AFQ1000
cp ../$dir1/AFQ1000/AFQ1000_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ1000/

# DropTail
cp ../$dir1/DropTail/DropTail_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/DropTail/

