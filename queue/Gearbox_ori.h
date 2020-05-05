#include "Level.h"
#include "Flow_pl.h"
#include <vector>
#include <string>

#include <map>

using namespace std;

class hierarchicalQueue_pl : public Queue {
private:
    static const int DEFAULT_VOLUME = 3;
    static const int DEFAULT_WEIGHT = 2;         // 01032019 Peixuan default weight
    static const int DEFAULT_BRUSTNESS = 100;    // 01032019 Peixuan default brustness
    int volume;                     // num of levels in scheduler
    int currentRound;           // current Round
    int pktCount;           // packet count

    Level levels[3];
    Level levelsB[2];       // Back up Levels

    Level hundredLevel;
    Level decadeLevel;

    //Level hundredLevelB;    // Back up Levels
    Level decadeLevelB;     // Back up Levels

    bool level0ServingB;          // is serve Back up Levels
    bool level1ServingB;          // is serve Back up Levels

    //vector<Flow_pl> flows;
    //06262019 Peixuan
    vector<Packet*> pktCurRound;

    // 06262019 Peixuan
    vector<Packet*> runRound();
    vector<Packet*> serveUpperLevel(int);
    void setPktCount(int);

    //12132019 Peixuan
    //typedef std::map<int, Flow_pl*> FlowTable;
    typedef std::map<string, Flow_pl*> FlowMap;
    FlowMap flowMap;

    //typedef std::map<int, Flow_pl*> TestIntMap;
    //TestIntMap testIntMap;

    //12132019 Peixuan
    Flow_pl* getFlowPtr(nsaddr_t saddr, nsaddr_t daddr);
    //int getFlowPtr(ns_addr_t saddr, ns_addr_t daddr);
    Flow_pl* insertNewFlowPtr(nsaddr_t saddr, nsaddr_t daddr, int weight, int brustness);

    int updateFlowPtr(nsaddr_t saddr, nsaddr_t daddr, Flow_pl* flowPtr);

    string convertKeyValue(nsaddr_t saddr, nsaddr_t daddr);


public:
    hierarchicalQueue_pl();
    explicit hierarchicalQueue_pl(int);
    void enque(Packet*);
    Packet* deque();
    void setCurrentRound(int);
    int cal_theory_departure_round(hdr_ip*, int);
    int cal_insert_level(int, int);
    // Packet* serveCycle();
    // vector<Packet> serveUpperLevel(int &, int);

    

};