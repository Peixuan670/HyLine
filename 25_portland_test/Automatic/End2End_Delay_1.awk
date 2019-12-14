BEGIN {
	highest_packet_id = 0;
}
{
   	action = $1;
   	time = $2;
   	node_1 = $3;
   	node_2 = $4;
   	type = $5;
   	flow_id = $8; 
   	node_1_address = $9;
   	node_2_address = $10; 
   	seq_no = $11;
   	packet_id = $12;
   	if ( packet_id > highest_packet_id )
   		highest_packet_id = packet_id;
  	if ( start_time[packet_id] == 0 )  
        	start_time[packet_id] = time;
  	if ( node_1_address == 1 && action != "d" ) {
        	if ( action == "r" ) {
        		end_time[packet_id] = time;
			seq_num[packet_id] = seq_no;
        	}
   	}else{
        	end_time[packet_id] = -1;
   	}
}                                                                                                           
END {
   	for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
        	start = start_time[packet_id];
        	end = end_time[packet_id];
		seq = seq_num[packet_id];
        	packet_duration = end - start;
        	if ( start < end ) printf("%f\t%f\n", start, packet_duration);
		#if(seq!=0) printf("%f %f %f %f\n", seq, start, end, packet_duration);
   	}
}
