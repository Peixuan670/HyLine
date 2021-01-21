//
// Created by Zhou Yitao on 2018-12-04.
//

#include "Level_flex.h"

Level_flex::Level_flex(): volume(4), currentIndex(0) {

    for (int i=0; i<volume; i++) {
        fifos[i] = new PacketQueue;
    }

}

void Level_flex::enque(Packet* packet, int index) {
    // packet.setInsertFifo(index);
    // packet.setFifoPosition(static_cast<int>(fifos[index].size()));
    // hdr_ip* iph = hdr_ip::access(packet);

    fifos[index]->enque(packet);
    pkt_cnt++;
}

Packet* Level_flex::deque() {
    Packet *packet;

    //fprintf(stderr, "Dequeue from this Level_flex\n"); // Debug: Peixuan 07062019

    if (isCurrentFifoEmpty()) {
        //fprintf(stderr, "No packet in the current serving FIFO\n"); // Debug: Peixuan 07062019
        return 0;
    }
    packet = fifos[currentIndex]->deque();
    pkt_cnt--;
    return packet;
}

int Level_flex::getCurrentIndex() {
    return currentIndex;
}

void Level_flex::setCurrentIndex(int index) {
    currentIndex = index;
}

void Level_flex::getAndIncrementIndex() {
    if (currentIndex + 1 < volume) {
        currentIndex++;
    } else {
        currentIndex = 0;
    }
}

bool Level_flex::isCurrentFifoEmpty() {
    //fprintf(stderr, "Checking if the FIFO is empty\n"); // Debug: Peixuan 07062019
    //fifos[currentIndex]->length() == 0;
    //fprintf(stderr, "Bug here solved\n"); // Debug: Peixuan 07062019
    return fifos[currentIndex]->length() == 0;
}

int Level_flex::getCurrentFifoSize() {
    return fifos[currentIndex]->length();
}

int Level_flex::size() {
    // get fifo number
    //return fifos.size();
    return sizeof(fifos)/sizeof(fifos[0]);
}

int Level_flex::get_level_pkt_cnt() {
    // get pkt_cnt
    return pkt_cnt;
}
