set myAgent "Agent/TCP/FullTcp/Sack/SolTCP";
set switchAlg "DropTail"
set bottleneckAlg "AFQ10PL"
#set bottleneckAlg "DropTail"
set hybrid 0
set Elp_win_init_ 80;#50#68;#BDP #[lindex $argv 5] 
set Elp_maxcwnd 100;#25,68,149;#[lindex $argv 6]

source "~/eval/common/common.tcl"
#source "tcp-common-opt.tcl"
set ns [new Simulator]
puts "Date: [clock format [clock seconds]]"
set sim_start [clock seconds]
puts "start: $sim_start"
set tf [open out.tr w]
$ns trace-all $tf

# Peixuan 02282020
#set ftr [open "out.nam" w]
#$ns namtrace-all $ftr



if {$argc != 3} {
        puts "wrong number of arguments $argc"
        exit 0
}


set num_flow [lindex $argv 0]
set num_queue 1;#[lindex $argv 1]
set cap0 1000000;#[lindex $argv 2]
set size_queue 226
set pfc 0;#[lindex $argv 3]
set margin_ 10 ;#[lindex $argv 4]
set Elp_win_init_ 25;#[lindex $argv 4]
set Elp_min_rto  0.004;#[lindex $argv 5]
set min_deadline_offset 0.5
#set max_deadline_offset [lindex $argv 6]
set ld [lindex $argv 1]
#set win_init_ 25;#50#68;#BDP #[lindex $argv 5]
set win_init_ 1;#50#68;#BDP #[lindex $argv 5]  Peixuan 01022020
#set maxcwnd 50;#$size_queue;#25,68,149;#[lindex $argv 6]

set pfc_thr1_edg_agg [expr $size_queue-6];#[lindex $argv 6]


set pfc_thr1_host_edg [expr $size_queue-6];#[lindex $argv 7]

set top [lindex $argv 2]
set qsize1_host_edg $size_queue
#set Elp_win_init_ 40;#50#68;#BDP #[lindex $argv 5] 
set Elp_maxcwnd [expr $size_queue-1];#[expr $Elp_win_init+1] ;#25,68,149;#[lindex $argv 6]

set enable_deadline 0;#[lindex $argv 4]
set flowlog [open tcp_flow_$num_flow\_$ld\_$top.tr w]
puts "flowlog: $flowlog"

#set win_init_ 25;#25;#68;#BDP #[lindex $argv 5]
set win_init_ 1;#50#68;#BDP #[lindex $argv 5]  Peixuan 01022020 
set maxcwnd $size_queue;#68;#149[lindex $argv 6]

#puts "enable_deadline=$enable_deadline"

#set tf [open out.tr w]
#$ns trace-all $tf

################# Arguments ####################

set prop_delay [expr 25.0000];#6 links each 25us prop delay
set num_links 6.00000
set total_prop_delay [expr $prop_delay*$num_links]
#set min_rto [expr ($total_prop_delay*2*3)/1000000.00000]
set min_rto 0.004;#0.0002

set debug_mode 1
set sim_end $num_flow
set queueSize $size_queue; #250
set DCTCP_g 0.0625
set sourceAlg "DCTCP-Sack"
set meanFlowSize [expr 1138 * 1460]
set pktSize 1460
set slowstartrestart 1
set ackRatio 1
set enableHRTimer 0

#### trace frequency
#set queueSamplingInterval 0.0001
set queueSamplingInterval 1

set drop_prio_ 0
set deque_prio_ 0
#prio_scheme_ 2
#prob_mode_ 0
set keep_order_ 0
set DCTCP_K 10000
#set link_rate 1.0000;#Gbps
set link_rate 100.00;#Gbps 02292020 Peixuan
set load $ld
set enableNAM 0
################# Transport Options ####################
Agent/TCP/FullTcp/Sack/SolTCP set NI $link_rate

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

Agent/TCP/FullTcp set prio_scheme_ 1 
Agent/TCP/FullTcp set prio_num_ $num_queue  
Agent/TCP/FullTcp set prio_cap0  $cap0 ; #1000000
Agent/TCP/FullTcp set prio_cap1  10000000

Agent/TCP/FullTcp set nodelay_ true
Agent/TCP/FullTcp set segsperack_ $ackRatio
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
    Agent/TCP set ecnhat_g_ $DCTCP_g
;
}
#Shuang
#Agent/TCP/FullTcp set prio_scheme_ $prio_scheme_;
#Agent/TCP/FullTcp set dynamic_dupack_ 1000000; #disable dupack
Agent/TCP set window_ 1000000
Agent/TCP set windowInit_ $win_init_
#Agent/TCP/FullTcp/Sack set clear_on_timeout_ false;
#Agent/TCP/FullTcp set pipectrl_ true;
#Agent/TCP/FullTcp/Sack set sack_rtx_threshmode_ 2;
Agent/TCP set maxcwnd_ $maxcwnd;#149
#Agent/TCP/FullTcp set prob_cap_ $prob_cap_;
Agent/TCP set rtxcur_init_ $min_rto;


################# Switch Options ######################

Queue set limit_ $queueSize

Queue/DropTail set queue_in_bytes_ true
Queue/DropTail set mean_pktsize_ [expr $pktSize+40]
Queue/DropTail set drop_prio_ $drop_prio_
Queue/DropTail set deque_prio_ $deque_prio_
Queue/DropTail set keep_order_ $keep_order_

Queue/RPQ set queue_num_ $num_queue

set pfc_ $pfc
Agent/TCP/FullTcp set pfc_enable $pfc_; #: pfc
Queue/RPQ set pfc_enable $pfc_

Queue/RPQ set pfc_threshold_0 500 ; #desabling pfc for queue #0
Queue/RPQ set pfc_threshold_1 224
Queue/RPQ set margin $margin_


if {1} {
	Queue/RPQ set bytes_ false
	Queue/RPQ set queue_in_bytes_ true
	Queue/RPQ set mean_pktsize_ $pktSize
	Queue/RPQ set setbit_ true
	Queue/RPQ set gentle_ false
	Queue/RPQ set q_weight_ 1.0
	Queue/RPQ set mark_p_ 1.0
	Queue/RPQ set thresh_ $DCTCP_K
	Queue/RPQ set maxthresh_ $DCTCP_K
	Queue/RPQ set drop_prio_ $drop_prio_
	Queue/RPQ set deque_prio_ $deque_prio_
	#DelayLink set avoidReordering_ true
}

if {1} {
	Queue/RPQ set bytes_1 false
	Queue/RPQ set queue_in_bytes_1 true
	Queue/RPQ set mean_pktsize_1 $pktSize
	Queue/RPQ set setbit_1 true
	Queue/RPQ set gentle_1 false
	Queue/RPQ set q_weight_1 1.0
	Queue/RPQ set mark_p_1 1.0
	Queue/RPQ set thresh_1 $DCTCP_K
	Queue/RPQ set maxthresh_1 $DCTCP_K
	Queue/RPQ set drop_prio_1 $drop_prio_
	Queue/RPQ set deque_prio_1 $deque_prio_
	#Queue/RPQ set queue_num_ 2
	#DelayLink set avoidReordering_ true
}

if {0} {
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
	Queue/RED set bytes_ false
}

set ctr [new Controller]

source "~/eval/common/$top"

puts "Initial agent creation done";flush stdout
puts "Simulation started!"

$ns run

