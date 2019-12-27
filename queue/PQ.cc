#include <cmath>

#include "PQ.h"

static class PQClass : public TclClass {
public:
        PQClass() : TclClass("Queue/PQ") {}
        TclObject* create(int, const char*const*) {
            fprintf(stderr, "Created new TCL PIFO instance\n"); // Debug: Peixuan 07062019
	        return (new PQ);
	}
} class_PQ;

PQ::PQ():PQ(DEFAULT_VOLUME) {
    fprintf(stderr, "Created new PIFO instance\n"); // Debug: Peixuan 07062019
}

PQ::PQ(int volume) {
    fprintf(stderr, "Created new PIFO instance with volumn = %d\n", volume); // Debug: Peixuan 07062019
    this->volume = volume;
    flows.push_back(Flow(0, 2, 100));
    flows.push_back(Flow(1, 2, 100));
    flows.push_back(Flow(2, 2, 100));
    flows.push_back(Flow(3, 2, 100));
    flows.push_back(Flow(4, 20, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    flows.push_back(Flow(5, 20, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    flows.push_back(Flow(6, 200, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    //flows.push_back(Flow(1, 0.2));
    // Flow(1, 0.2), Flow(2, 0.3)};
    currentRound = 0;
    pktCount = 0; // 07072019 Peixuan
    //pktCurRound = new vector<Packet*>;
}

void PQ::setCurrentRound(int currentRound) {
    fprintf(stderr, "Set Current Round: %d\n", currentRound); // Debug: Peixuan 07062019
    this->currentRound = currentRound;
}

void PQ::setPktCount(int pktCount) {
    fprintf(stderr, "Set Packet Count: %d\n", pktCount); // Debug: Peixuan 07072019
    this->pktCount = pktCount;
}

void PQ::enque(Packet* packet) {

    hdr_ip* iph = hdr_ip::access(packet);
    int pkt_size = packet->hdrlen_ + packet->datalen();

    fprintf(stderr, "AAAAA Start Enqueue Flow %d Packet\n", iph->saddr()); // Debug: Peixuan 07062019

    ///////////////////////////////////////////////////
    // TODO: get theory departure Round
    // You can get flowId from iph, then get
    // "lastDepartureRound" -- departure round of last packet of this flow
    int departureRound = cal_theory_departure_round(iph, pkt_size);
    ///////////////////////////////////////////////////

    // 20190626 Yitao
    /* With departureRound and currentRound, we can get the insertLevel, insertLevel is a parameter of flow and we can set and read this variable.
    */

    int flowId = iph->flowid();
    //int insertLevel = flows[flowId].getInsertLevel(); //HCS->AFQ
    int insertLevel = 0;

    departureRound = max(departureRound, currentRound);

    if ((departureRound - currentRound) >= SET_GRANULARITY * SET_NUMBER) {
        fprintf(stderr, "?????Exceeds maximum round, drop the packet from Flow %d\n", iph->saddr()); // Debug: Peixuan 07072019
        drop(packet);
        return;   // 07072019 Peixuan: exceeds the maximum round
    }
   
    //int curFlowID = iph->saddr();   // use source IP as flow id
    int curFlowID = iph->flowid();   // use flow id as flow id
    int curBrustness = flows[curFlowID].getBrustness();
    if ((departureRound - currentRound) >= curBrustness) {
        fprintf(stderr, "?????Exceeds maximum brustness, drop the packet from Flow %d\n", iph->saddr()); // Debug: Peixuan 07072019
        drop(packet);
        return;   // 07102019 Peixuan: exceeds the maximum brustness
    }

    flows[curFlowID].setLastDepartureRound(departureRound);     // 07102019 Peixuan: only update last packet finish time if the packet wasn't dropped

    struct Unit unit;

    unit.packet = packet;
    unit.finishTime = departureRound;
    pq.push(unit);


    setPktCount(pktCount + 1);
    fprintf(stderr, "Packet Count ++\n");

    fprintf(stderr, "Finish Enqueue\n");
}

// Peixuan: This can be replaced by any other algorithms
int PQ::cal_theory_departure_round(hdr_ip* iph, int pkt_size) {
    //int		fid_;	/* flow id */
    //int		prio_;
    // parameters in iph
    // TODO

    // Peixuan 06242019
    // For simplicity, we assume flow id = the index of array 'flows'

    fprintf(stderr, "$$$$$Calculate Departure Round at VC = %d\n", currentRound); // Debug: Peixuan 07062019

    //int curFlowID = iph->saddr();   // use source IP as flow id
    int curFlowID = iph->flowid();   // use flow id as flow id
    float curWeight = flows[curFlowID].getWeight();
    int curLastDepartureRound = flows[curFlowID].getLastDepartureRound();
    int curStartRound = max(currentRound, curLastDepartureRound);

    fprintf(stderr, "$$$$$Last Departure Round of Flow%d = %d\n",iph->saddr() , curLastDepartureRound); // Debug: Peixuan 07062019
    fprintf(stderr, "$$$$$Start Departure Round of Flow%d = %d\n",iph->saddr() , curStartRound); // Debug: Peixuan 07062019

    //int curDeaprtureRound = (int)(curStartRound + pkt_size/curWeight); // TODO: This line needs to take another thought

    int curDeaprtureRound = (int)(curStartRound + curWeight); // 07072019 Peixuan: basic test

    fprintf(stderr, "$$$$$Calculated Packet From Flow:%d with Departure Round = %d\n",iph->saddr() , curDeaprtureRound); // Debug: Peixuan 07062019
    // TODO: need packet length and bandwidh relation
    //flows[curFlowID].setLastDepartureRound(curDeaprtureRound);
    return curDeaprtureRound;
}

//06262019 Peixuan deque function of Gearbox:

//06262019 Static getting all the departure packet in this virtual clock unit (JUST FOR SIMULATION PURPUSE!)

Packet* PQ::deque() {

    fprintf(stderr, "Start Dequeue\n"); // Debug: Peixuan 07062019

    //fprintf(stderr, "Queue size: %d\n",pktCurRound.size()); // Debug: Peixuan 07062019

    if (pktCount == 0) {
        fprintf(stderr, "Scheduler Empty\n"); // Debug: Peixuan 07062019
        return 0;
    }

    struct Unit unit = pq.top();
    pq.pop();
    Packet* p = unit.packet;

    while(!pktCurRound.size()) {
        fprintf(stderr, "Empty Round\n");
        pktCurRound = this->runRound();
        this->setCurrentRound(unit.finishTime);
    }
    // this->setCurrentRound(unit.finishTime); // Update system virtual clock 12232019 Peixuan
    fprintf(stderr, "PIFO dequeue packet with Finish Time of %d\n", unit.finishTime);
    setPktCount(pktCount - 1);
    fprintf(stderr, "Packet Count --\n");

    hdr_ip* iph = hdr_ip::access(p);
    fprintf(stderr, "*****Dequeue Packet p with soure IP: %x\n", iph->saddr()); // Debug: Peixuan 07062019

    return p;

}

// Peixuan: now we only call this function to get the departure packet in the next round
vector<Packet*> PQ::runRound() {

    fprintf(stderr, "Run Round\n"); // Debug: Peixuan 07062019

    vector<Packet*> result;

    int curServeSet = (currentRound / SET_GRANULARITY) % SET_NUMBER;    // Find the current serving set

    fprintf(stderr, "Serving Set %d\n", curServeSet); // Debug: Peixuan 08022019

    Packet* p = levels[curServeSet].deque();

    //fprintf(stderr, "Get packet pointer\n"); // Debug: Peixuan 07062019

    if (!p) {
        fprintf(stderr, "No packet\n"); // Debug: Peixuan 07062019
    }

    while (p) {

        hdr_ip* iph = hdr_ip::access(p);                   // 07092019 Peixuan Debug

        fprintf(stderr, "^^^^^At Round:%d, Round Deque Flow %d Packet From Level %d: fifo %d\n", currentRound, iph->saddr(), curServeSet, levels[curServeSet].getCurrentIndex()); // Debug: Peixuan 07092019

        result.push_back(p);
        p = levels[curServeSet].deque();
    }

    levels[curServeSet].getAndIncrementIndex();               // Level 0 move to next FIFO
    fprintf(stderr, "<<<<<At Round:%d, Level %d update current FIFO as: fifo %d\n", currentRound, curServeSet, levels[curServeSet].getCurrentIndex()); // Debug: Peixuan 07212019

    return result;
}
