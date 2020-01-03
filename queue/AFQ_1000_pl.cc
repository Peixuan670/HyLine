#include <cmath>
#include <sstream>

#include "AFQ_1000_pl.h"

static class AFQ1000_plClass : public TclClass {
public:
        AFQ1000_plClass() : TclClass("Queue/AFQ1000PL") {}
        TclObject* create(int, const char*const*) {
            fprintf(stderr, "Created new TCL AFQ1000PL instance\n"); // Debug: Peixuan 07062019
	        return (new AFQ_1000_pl);
	}
} class_AFQ1000;

AFQ_1000_pl::AFQ_1000_pl():AFQ_1000_pl(DEFAULT_VOLUME) {
    fprintf(stderr, "Created new AFQ1000 instance\n"); // Debug: Peixuan 07062019
}

AFQ_1000_pl::AFQ_1000_pl(int volume) {
    fprintf(stderr, "Created new AFQ1000 instance with volumn = %d\n", volume); // Debug: Peixuan 07062019
    this->volume = volume;
    //flows.push_back(Flow_pl(0, 2, 100));
    //flows.push_back(Flow_pl(1, 2, 100));
    //flows.push_back(Flow_pl(2, 2, 100));
    //flows.push_back(Flow_pl(3, 2, 100));
    //flows.push_back(Flow_pl(4, 20, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    //flows.push_back(Flow_pl(5, 20, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    //flows.push_back(Flow_pl(6, 200, 1000));        //07062019: Peixuan adding more flows for strange flow 3 problem
    //flows.push_back(Flow(1, 0.2));
    // Flow(1, 0.2), Flow(2, 0.3)};
    currentRound = 0;
    pktCount = 0; // 07072019 Peixuan
    //pktCurRound = new vector<Packet*>;

    //12132019 Peixuan
    typedef std::map<string, Flow_pl*> FlowMap;
    FlowMap flowMap;
}

void AFQ_1000_pl::setCurrentRound(int currentRound) {
    fprintf(stderr, "Set Current Round: %d\n", currentRound); // Debug: Peixuan 07062019
    this->currentRound = currentRound;
}

void AFQ_1000_pl::setPktCount(int pktCount) {
    fprintf(stderr, "Set Packet Count: %d\n", pktCount); // Debug: Peixuan 07072019
    this->pktCount = pktCount;
}

void AFQ_1000_pl::enque(Packet* packet) {   
    
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

    //int flowId = iph->flowid();

    // Mengqi
    //int flowId = iph->flowid();
    string key = convertKeyValue(iph->saddr(), iph->daddr());
    // Not find the current key
    if (flowMap.find(key) == flowMap.end()) {
        //flowMap[key] = Flow_pl(iph->saddr, iph->daddr, 2, 100);
        insertNewFlowPtr(iph->saddr(), iph->daddr(), 2, 100);
    }

    Flow_pl* currFlow = flowMap[key];

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
    int curBrustness = currFlow->getBrustness();
    if ((departureRound - currentRound) >= curBrustness) {
        fprintf(stderr, "?????Exceeds maximum brustness, drop the packet from Flow %d\n", iph->saddr()); // Debug: Peixuan 07072019
        drop(packet);
        return;   // 07102019 Peixuan: exceeds the maximum brustness
    }

    //flows[curFlowID].setLastDepartureRound(departureRound);     // 07102019 Peixuan: only update last packet finish time if the packet wasn't dropped
    currFlow->setLastDepartureRound(departureRound);
    this->updateFlowPtr(iph->saddr(), iph->daddr(),currFlow);

    if ((departureRound - currentRound) < SET_GRANULARITY * SET_NUMBER) {
        //fprintf(stderr, "Enqueue Level 0\n"); // Debug: Peixuan 07072019
        int setID = (departureRound/SET_GRANULARITY) % SET_NUMBER;
        fprintf(stderr, "departureRound/SET_GRANULARITY = %d/%d = %d\n", departureRound, SET_GRANULARITY, (departureRound/SET_GRANULARITY)); // Debug: Peixuan 07072019
        fprintf(stderr, "Enqueue Set %d\n", setID); // Debug: Peixuan 07072019
        //flows[flowId].setInsertLevel(0);
        int fifoGranularity = SET_GRANULARITY/10;
        levels[setID].enque(packet, (departureRound/fifoGranularity) % 10);
    } else {
        fprintf(stderr, "?????Exceeds maximum brustness, drop the packet from Flow %d\n", iph->saddr()); // Debug: Peixuan 07072019
        drop(packet);
        return;   // 07102019 Peixuan: exceeds the maximum brustness
    }
    setPktCount(pktCount + 1);
    fprintf(stderr, "Packet Count ++\n");

    fprintf(stderr, "Finish Enqueue\n"); // Debug: Peixuan 07062019
}

// Peixuan: This can be replaced by any other algorithms
int AFQ_1000_pl::cal_theory_departure_round(hdr_ip* iph, int pkt_size) {
    //int		fid_;	/* flow id */
    //int		prio_;
    // parameters in iph
    // TODO

    // Peixuan 06242019
    // For simplicity, we assume flow id = the index of array 'flows'

    fprintf(stderr, "$$$$$Calculate Departure Round at VC = %d\n", currentRound); // Debug: Peixuan 07062019

    //int curFlowID = iph->saddr();   // use source IP as flow id
    //float curWeight = flows[curFlowID].getWeight();
    //int curLastDepartureRound = flows[curFlowID].getLastDepartureRound();
    string key = convertKeyValue(iph->saddr(), iph->daddr());

    Flow_pl* currFlow = this->getFlowPtr(iph->saddr(), iph->daddr());

    float curWeight = currFlow->getWeight();
    int curLastDepartureRound = currFlow->getLastDepartureRound();
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

Packet* AFQ_1000_pl::deque() {

    fprintf(stderr, "Start Dequeue\n"); // Debug: Peixuan 07062019

    //fprintf(stderr, "Queue size: %d\n",pktCurRound.size()); // Debug: Peixuan 07062019

    if (pktCount == 0) {
        fprintf(stderr, "Scheduler Empty\n"); // Debug: Peixuan 07062019
        return 0;
    }

    while (!pktCurRound.size()) {
        fprintf(stderr, "Empty Round\n"); // Debug: Peixuan 07062019
        pktCurRound = this->runRound();
        this->setCurrentRound(currentRound + 1); // Update system virtual clock
        //this->deque();
    }

    Packet *p = pktCurRound.front();
    pktCurRound.erase(pktCurRound.begin());

    setPktCount(pktCount - 1);
    fprintf(stderr, "Packet Count --\n");

    hdr_ip* iph = hdr_ip::access(p);
    fprintf(stderr, "*****Dequeue Packet p with soure IP: %x\n", iph->saddr()); // Debug: Peixuan 07062019

    return p;

}

// Peixuan: now we only call this function to get the departure packet in the next round
vector<Packet*> AFQ_1000_pl::runRound() {

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

// 12132019 Peixuan
Flow_pl* AFQ_1000_pl::getFlowPtr(nsaddr_t saddr, nsaddr_t daddr) {
    fprintf(stderr, "Getting flows with src address %d , dst address = %d\n",saddr, daddr); // Debug: Peixuan 12142019
//int hierarchicalQueue_pl::getFlowPtr(ns_addr_t saddr, ns_addr_t daddr) {
    //pair<ns_addr_t, ns_addr_t> key = make_pair(saddr, daddr);
    //FlowMap::const_iterator iter; 
    //iter = this->flowMap.find(make_pair<ns_addr_t, ns_addr_t>);
    //typedef std::map<pair<ns_addr_t, ns_addr_t>, Flow_pl*> FlowMap;
    //FlowMap::const_iterator iter = this->flowMap.find(key);
    //return iter->second;
    //return this->flowMap[key];
    //Flow_pl* flow = this->flowMap[key];
    //printf("Map size: %d",this->flowMap.size());
    string key = convertKeyValue(saddr, daddr);
    Flow_pl* flow; 
    if (flowMap.find(key) == flowMap.end()) {
        flow = this->insertNewFlowPtr(saddr, daddr, DEFAULT_WEIGHT, DEFAULT_BRUSTNESS);
    }
    flow = this->flowMap[key];
    return flow;
}

Flow_pl* AFQ_1000_pl::insertNewFlowPtr(nsaddr_t saddr, nsaddr_t daddr, int weight, int brustness) {
    string key = convertKeyValue(saddr, daddr);
    Flow_pl* newFlowPtr = new Flow_pl(1, weight, brustness);
    this->flowMap.insert(pair<string, Flow_pl*>(key, newFlowPtr));
    return this->flowMap[key];
}

int AFQ_1000_pl::updateFlowPtr(nsaddr_t saddr, nsaddr_t daddr, Flow_pl* flowPtr) {
    //pair<ns_addr_t, ns_addr_t> key = make_pair(saddr, daddr);
    string key = convertKeyValue(saddr, daddr);
    //Flow_pl* newFlowPtr = new Flow_pl(1, weight, brustness);
    //this->flowMap.insert(pair<pair<ns_addr_t, ns_addr_t>, Flow_pl*>(key, newFlowPtr));
    this->flowMap.insert(pair<string, Flow_pl*>(key, flowPtr));
    //flowMap.insert(pair(key, newFlowPtr));
    //return 0;
    return 0;
}

string AFQ_1000_pl::convertKeyValue(nsaddr_t saddr, nsaddr_t daddr) {
    stringstream ss;
    ss << saddr;
    ss << ":";
    ss << daddr;
    string key = ss.str();
    return key;
}
