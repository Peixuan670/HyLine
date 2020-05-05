BEGIN {
	fsDrops = 0;
        numFs = 0;
}
{
	action = $1;
   	time = $2;
   	node_1 = $3;
   	node_2 = $4;
   	src = $5;
   	flow_id = $8;
   	node_1_address = $9;
   	node_2_address = $10;
   	seq_no = $11;
   	packet_id = $12;
        #if (node_1==1 && node_2==2 && action == "+")
	if (node_1_address==3 && action == "+")
        	numFs++;
        if (node_1_address==3 && action == "d")
                fsDrops++;
}
END {
        printf("number of packets sent:%d lost:%d\n", numFs, fsDrops);
}
