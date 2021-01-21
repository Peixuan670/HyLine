//
// Created by Zhou Yitao on 2018-12-04.
//

#ifndef HIERARCHICALSCHEDULING_HIERARCHY_H
#define HIERARCHICALSCHEDULING_HIERARCHY_H

#include "queue.h"
#include "address.h"
using namespace std;

class Level_flex {
private:
    static const int DEFAULT_VOLUME = 4;
    int volume;                         // num of fifos in one level
    int currentIndex;                   // current serve index
    PacketQueue *fifos[4];
    
    int pkt_cnt;                        // 01132021 Peixuan debug


public:
    Level_flex();
    void enque(Packet* packet, int index);
    Packet* deque();
    int getCurrentIndex();
    void setCurrentIndex(int index);             // 07212019 Peixuan: set serving FIFO (especially for convergence FIFO)
    void getAndIncrementIndex();
    int getCurrentFifoSize();
    bool isCurrentFifoEmpty();
    int size();

    int get_level_pkt_cnt();            // 01132021 Peixuan debug
};


#endif //HIERARCHICALSCHEDULING_HIERARCHY_H
