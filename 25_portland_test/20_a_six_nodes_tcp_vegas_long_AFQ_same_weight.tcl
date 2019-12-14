set ns [new Simulator]

$ns color 0 Red
$ns color 1 Blue
$ns color 2 Green
$ns color 3 Yellow

$ns color 4 Orange
$ns color 5 Pink
$ns color 6 Brown

set tr [ open "out.tr" w]
$ns trace-all $tr

set ftr [open "out.nam" w]
$ns namtrace-all $ftr

proc finish { } {
	global ns tr ftr
	$ns flush-trace
	close $tr
	close $ftr
	exec nam out.nam &
	}


#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

set n4 [$ns node]
$n4 shape box
$n4 color green

set n5 [$ns node]
$n5 shape box
$n5 color red

#create link
$ns duplex-link $n0 $n4 2Mb 3ms DropTail
$ns duplex-link $n1 $n4 2Mb 3ms DropTail
$ns duplex-link $n2 $n4 2Mb 3ms DropTail
$ns duplex-link $n3 $n4 12Mb 3ms DropTail
#$ns duplex-link $n4 $n5 4Mb 3ms HRCC
#$ns duplex-link $n4 $n5 4Mb 3ms AFQ10
#$ns duplex-link $n4 $n5 4Mb 3ms AFQ100
#$ns duplex-link $n4 $n5 4Mb 3ms AFQ1000
#$ns duplex-link $n4 $n5 4Mb 3ms DropTail
$ns queue-limit $n4 $n5 500

#set nodes position
$ns duplex-link-op $n0 $n4 orient right-up
$ns duplex-link-op $n1 $n4 orient up
$ns duplex-link-op $n2 $n4 orient right-down
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n4 $n5 orient right


#for n0 and n5 source
set tcp0 [new Agent/TCP/Vegas]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$tcp0 set fid_ 0

#for n1 and n5 source
set tcp1 [new Agent/TCP/Vegas]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$tcp1 set fid_ 1

#for n2 and n5 source
set tcp2 [new Agent/TCP/Vegas]
$ns attach-agent $n2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$tcp2 set fid_ 2

#for n3 and n5 source
set tcp3 [new Agent/TCP/Vegas]
$ns attach-agent $n3 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n5 $sink3
$ns connect $tcp3 $sink3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$tcp3 set fid_ 3

#for n3 and n5
#set udp4 [new Agent/UDP]
#$ns attach-agent $n3 $udp4
#set null4 [new Agent/Null]
#$ns attach-agent $n5 $null4
#$ns connect $udp4 $null4
#set cbr4 [new Application/Traffic/CBR]
#$cbr4 attach-agent $udp4
#$cbr4 set type_ CBR
#$cbr4 set packet_size_ 1000
#$cbr4 set rate_ 1mb
#$cbr4 set random_ false
#$udp4 set fid_ 3

#event
$ns at .1 "$ftp0 start"
$ns at .1 "$ftp1 start"
$ns at .1 "$ftp2 start"
$ns at .1 "$ftp3 start"
#$ns at .1 "$cbr4 start"

$ns at 12 "$ftp0 stop"
$ns at 12 "$ftp1 stop"
$ns at 12 "$ftp2 stop"
$ns at 12 "$ftp3 stop"
#$ns at 12 "$cbr4 stop"

$ns at 15.1 "finish"

$ns run
