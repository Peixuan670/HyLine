awk -f throughput_0.awk out.tr > results/throughput_0.txt
awk -f throughput_1.awk out.tr > results/throughput_1.txt
awk -f throughput_2.awk out.tr > results/throughput_2.txt
awk -f throughput_3.awk out.tr > results/throughput_3.txt

awk -f throughput_combine_0.awk out.tr > results/throughput_combine_0.txt
awk -f throughput_combine_1.awk out.tr > results/throughput_combine_1.txt
awk -f throughput_combine_2.awk out.tr > results/throughput_combine_2.txt
awk -f throughput_combine_3.awk out.tr > results/throughput_combine_3.txt

awk -f throughput_short_0.awk out.tr > results/throughput_short_0.txt
awk -f throughput_short_1.awk out.tr > results/throughput_short_1.txt
awk -f throughput_short_2.awk out.tr > results/throughput_short_2.txt
awk -f throughput_short_3.awk out.tr > results/throughput_short_3.txt

awk -f End2End_Delay_0.awk out.tr > results/delay_0.txt
awk -f End2End_Delay_1.awk out.tr > results/delay_1.txt
awk -f End2End_Delay_2.awk out.tr > results/delay_2.txt
awk -f End2End_Delay_3.awk out.tr > results/delay_3.txt

awk -f serving_time_0.awk out.tr > results/serving_time_0.txt
awk -f serving_time_1.awk out.tr > results/serving_time_1.txt
awk -f serving_time_2.awk out.tr > results/serving_time_2.txt
awk -f serving_time_3.awk out.tr > results/serving_time_3.txt

awk -f packet_loss_0.awk out.tr > results/packet_loss.txt
awk -f packet_loss_1.awk out.tr >> results/packet_loss.txt
awk -f packet_loss_2.awk out.tr >> results/packet_loss.txt
awk -f packet_loss_3.awk out.tr >> results/packet_loss.txt

awk -f jitter_0.awk out.tr > results/jitter_0.txt
awk -f jitter_1.awk out.tr > results/jitter_1.txt
awk -f jitter_2.awk out.tr > results/jitter_2.txt
awk -f jitter_3.awk out.tr > results/jitter_3.txt









