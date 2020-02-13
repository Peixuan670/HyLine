BEGIN {
	init=0;
	i=0;
}
{
	action = $1;
        time = $2;
        node_1 = $3;
        node_2 = $4;
        src = $5;
        pktsize = $6;
        flow_id = $8;
        node_1_address = $9;
        node_2_address = $10;
        seq_no = $11;
        packet_id = $12;
	if(action=="r" && node_2==5 && node_1_address == 1) {
        #if(action=="r" && node_2==5 && node_1_address==1 && node_2_address==5) {
        	pkt_byte_sum[i+1]=pkt_byte_sum[i]+ pktsize; 
                if(init==0) {
                	start_time = time;
                	init = 1;
		}
                              
		end_time[i] = time;
		i = i+1;
	}
}
END {
	printf("%f\t%f\n", end_time[0], 0);
        for(j=1 ; j<i ; j++){
		#if(j<50){
		#	th = pkt_byte_sum[j] / (end_time[j] - start_time)*8/1000;
		#	printf("%.2f\t%.2f\n", end_time[j], th);
		#} else {
		#	th = (pkt_byte_sum[j]-pkt_byte_sum[j-50]) / (end_time[j] - end_time[j-50])*8/1000;
		#	printf("%.2f\t%.2f\n", end_time[j], th);
		#}
		th = pkt_byte_sum[j] / (end_time[j] - start_time)*8/1000;
		printf("%f\t%f\n", end_time[j], th);
	}
	printf("%f\t%f\n", end_time[i-1], 0);
}
