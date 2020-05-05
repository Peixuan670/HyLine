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
   	if ( packet_id > highest_packet_id ) {
           	highest_packet_id = packet_id;
        }
   	if ( start_time[packet_id] == 0 )  {
           	pkt_seqno[packet_id] = seq_no;
           	start_time[packet_id] = time;
   	}
  	if ( node_1_address == 2 && action != "d" ) {
     		if ( action == "r" ) {
         		end_time[packet_id] = time;
      		}
   	} else {
      		end_time[packet_id] = -1;
   	}
}                                                       
END {
        last_seqno = 0;
        last_delay = 0;
        seqno_diff = 0;
    	for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
       		start = start_time[packet_id];
       		end = end_time[packet_id];
       		packet_duration = end - start;
       		if ( start < end ) {
               		seqno_diff = pkt_seqno[packet_id] - last_seqno;
               		delay_diff = packet_duration - last_delay;
               		if (seqno_diff == 0) {
                      		jitter =0;
               		} else {
                       		jitter = delay_diff/seqno_diff;
               		}
               		printf("%f\t%f\n", start, jitter);
              		last_seqno = pkt_seqno[packet_id];
              		last_delay = packet_duration;
       		}
    	}
}
