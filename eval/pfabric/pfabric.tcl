set myAgent "Agent/TCP/FullTcp/Sack/MinTCP";
set hybrid 0
set Elp_win_init_ 80;#50#68;#BDP #[lindex $argv 5] 
set Elp_maxcwnd 100;#25,68,149;#[lindex $argv 6]

source "~/eval/common/common.tcl"

#add/remove packet headers as required
#this must be done before create simulator, i.e., [new Simulator]
#remove-all-packet-headers       ;# removes all except common
#add-packet-header Flags IP RCP  ;#hdrs reqd for RCP traffic

set ns [new Simulator]
puts "Date: [clock format [clock seconds]]"
set sim_start [clock seconds]
puts "Host: [exec uname -a]"



if {$argc != 4} {
    puts "wrong number of arguments $argc"
    exit 0
}

set num_flow [lindex $argv 0]
set num_queue 1;#[lindex $argv 1]
set cap0 1000000;#[lindex $argv 2] 
set size_queue [lindex $argv 1] 
set enable_deadline 0;#[lindex $argv 4]
set min_deadline_offset 0.5;#[lindex $argv 5]
#set max_deadline_offset [lindex $argv 6]
set ld [lindex $argv 2]
set top [lindex $argv 3]
set flowlog [open pfabric_flow_$num_flow\_$size_queue\_$ld\_$top.tr w]

#set tf [open out.tr w]
#$ns trace-all $tf
set margin_ 10 ;#[lindex $argv 4]
set Elp_min_rto  0.001
set pfc_thr1_edg_agg 225
set pfc_thr1_host_edg 225


################# Arguments ####################
set cwdn 25
set size_queue [expr $cwdn*2] 
set prop_delay [expr 25.0000];#6 links each 25us prop delay
set num_links 6.00000
set total_prop_delay [expr $prop_delay*$num_links]
set min_rto 0.001;#[expr ($total_prop_delay*2*3)/1000000.00000]

set debug_mode 1
set sim_end $num_flow
set queueSize 50;#$size_queue; #250
set DCTCP_g 0.0625
set sourceAlg "DCTCP-Sack"
set meanFlowSize [expr 1138 * 1460]
set pktSize 1460
set slowstartrestart 1
set ackRatio 1
set enableHRTimer 0

set switchAlg "DropTail"


#### trace frequency
#set queueSamplingInterval 0.0001
set queueSamplingInterval 1

set drop_prio_ 1
set deque_prio_ 1
set prio_scheme_ 2
set prob_mode_ 5
set prob_cap_ $prob_mode_
set keep_order_ 1
set DCTCP_K 10000
set link_rate 1.000
set load $ld
set enableNAM 0

################# Transport Options ####################

Agent/TCP set ecn_ 1
Agent/TCP set old_ecn_ 1
Agent/TCP set packetSize_ $pktSize
Agent/TCP/FullTcp set segsize_ $pktSize
Agent/TCP/FullTcp set spa_thresh_ 0
Agent/TCP set window_ 64
Agent/TCP set windowInit_ 2
Agent/TCP set slow_start_restart_ $slowstartrestart
Agent/TCP set windowOption_ 0
Agent/TCP set tcpTick_ 0.000001
Agent/TCP set minrto_ $min_rto
Agent/TCP set maxrto_ 2

Agent/TCP/FullTcp set nodelay_ true; # disable Nagle
Agent/TCP/FullTcp set segsperack_ $ackRatio; 
Agent/TCP/FullTcp set interval_ 0.000006
if {$ackRatio > 2} {
    Agent/TCP/FullTcp set spa_thresh_ [expr ($ackRatio - 1) * $pktSize]
}
if {$enableHRTimer != 0} {
    Agent/TCP set minrto_ 0.00100 ; # 1ms
    Agent/TCP set tcpTick_ 0.000001
}
if {[string compare $sourceAlg "DCTCP-Sack"] == 0} {
    Agent/TCP set ecnhat_ true
    Agent/TCPSink set ecnhat_ true
    Agent/TCP set ecnhat_g_ $DCTCP_g;
}
#Shuang
Agent/TCP/FullTcp set prio_scheme_ $prio_scheme_;
Agent/TCP/FullTcp set dynamic_dupack_ 1000000; #disable dupack
Agent/TCP set window_ 1000000
Agent/TCP set windowInit_ 25;#25;#12;#50
Agent/TCP set rtxcur_init_ $min_rto;
Agent/TCP/FullTcp/Sack set clear_on_timeout_ false;
#Agent/TCP/FullTcp set pipectrl_ true;
Agent/TCP/FullTcp/Sack set sack_rtx_threshmode_ 2;
if {$queueSize > 25} {
   Agent/TCP set maxcwnd_ [expr $queueSize - 1];#70;#[expr $queueSize - 1];
} else {
   Agent/TCP set maxcwnd_ 25;
}
Agent/TCP/FullTcp set prob_cap_ $prob_cap_;


################# Switch Options ######################

Queue set limit_ $queueSize

Queue/DropTail set queue_in_bytes_ true
Queue/DropTail set mean_pktsize_ [expr $pktSize+40]
Queue/DropTail set drop_prio_ $drop_prio_
Queue/DropTail set deque_prio_ $deque_prio_
Queue/DropTail set keep_order_ $keep_order_

Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ true
Queue/RED set mean_pktsize_ $pktSize
Queue/RED set setbit_ true
Queue/RED set gentle_ false
Queue/RED set q_weight_ 1.0
Queue/RED set mark_p_ 1.0
Queue/RED set thresh_ $DCTCP_K
Queue/RED set maxthresh_ $DCTCP_K
Queue/RED set drop_prio_ $drop_prio_
Queue/RED set deque_prio_ $deque_prio_
			 
#DelayLink set avoidReordering_ true

############### NAM ###########################
if {$enableNAM != 0} {
    set namfile [open out.nam w]
    $ns namtrace-all $namfile
}


#############  Agents    #########################
set ctr [new Controller]

source "~/eval/common/$top"

puts "Initial agent creation done";flush stdout
puts "Simulation started!"

$ns run
