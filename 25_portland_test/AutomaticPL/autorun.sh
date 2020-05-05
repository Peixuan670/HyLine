#Autorun
#Put this in the Automatic director

#dir1="d_new_same_weight_all_new_reno/wmq_data"
#dir1="d_new_same_weight_all_new_reno/18xxx"
#dir1="d_new_same_weight_all_new_reno/19xxxb"
dir1="d_new_same_weight_all_new_reno/19xxxa"

# HCSPL
cp ../$dir1/HCSPL/HCSPL_out.tr out.tr
bash parse_result.sh
#echo $dir1
#echo ../$dir1/HCS/HCS_out.tr out.tr

sleep 5

mv ./results/* ../$dir1/HCSPL/

# AFQ10PL
cp ../$dir1/AFQ10PL/AFQ10PL_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ10PL/

# AFQ100PL
cp ../$dir1/AFQ100PL/AFQ100PL_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ100PL/

# AFQ1000PL
cp ../$dir1/AFQ1000PL/AFQ1000PL_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/AFQ1000PL/

# DropTail
cp ../$dir1/DropTail/DropTail_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/DropTail/

# PQPL
cp ../$dir1/PQPL/PQPL_out.tr out.tr
bash parse_result.sh

sleep 5

mv ./results/* ../$dir1/PQPL/
