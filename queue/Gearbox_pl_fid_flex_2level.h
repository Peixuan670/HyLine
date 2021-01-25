#include "Level_flex.h"
#include "Flow_pl.h"
#include <vector>
#include <string>

#include <map>

using namespace std;

class Gearbox_pl_fid_flex : public Queue {
private:
    static const int DEFAULT_VOLUME = 2;
    static const int FIFO_PER_LEVEL = 32;         // 01212020 Peixuan flex level
    static const int STEP_DOWN_FIFO = 16;         // 01212020 Peixuan flex level
    static const int DEFAULT_WEIGHT = 2;         // 01032019 Peixuan default weight
    static const int DEFAULT_BRUSTNESS = 1000;    // 01032019 Peixuan default brustness
    static const int TIMEUNIT = 1;    // 01032019 Peixuan default brustness
    int volume;                     // num of Level_flexs in scheduler
    int currentRound;           // current Round
    int pktCount;           // packet count

    Level_flex levels[2];
    Level_flex levelsB[1];       // Back up Levels

    //Level_flex forthLevel;
    //Level_flex thirdLevel;
    
    //Level_flex hundredLevel;
    Level_flex decadeLevel;

    //Level_flex thirdLevelB;    // Back up Level_flexs
    //Level_flex hundredLevelB;    // Back up Level_flexs
    //Level_flex decadeLevelB;     // Back up Levels

    bool level0ServingB;          // is serve Back up Levels
    //bool level1ServingB;          // is serve Back up Levels

    //bool level2ServingB;          // is serve Back up Levels
    //bool level3ServingB;          // is serve Back up Levels
    //bool level4ServingB;          // is serve Back up Levels

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
    //Flow_pl* getFlowPtr(nsaddr_t saddr, nsaddr_t daddr);
    Flow_pl* getFlowPtr(int fid);   // Peixuan 04212020
    //int getFlowPtr(ns_addr_t saddr, ns_addr_t daddr);
    //Flow_pl* insertNewFlowPtr(nsaddr_t saddr, nsaddr_t daddr, int weight, int brustness);
    Flow_pl* insertNewFlowPtr(int fid, int weight, int brustness);   // Peixuan 04212020

    //int updateFlowPtr(nsaddr_t saddr, nsaddr_t daddr, Flow_pl* flowPtr);
    int updateFlowPtr(int fid, Flow_pl* flowPtr);    // Peixuan 04212020

    //string convertKeyValue(nsaddr_t saddr, nsaddr_t daddr);
    string convertKeyValue(int fid);    // Peixuan 04212020


public:
    Gearbox_pl_fid_flex();
    explicit Gearbox_pl_fid_flex(int);
    void enque(Packet*);
    Packet* deque();
    void setCurrentRound(int);
    int cal_theory_departure_round(hdr_ip*, int);
    int cal_insert_level(int, int);
    // Packet* serveCycle();
    // vector<Packet> serveUpperLevel(int &, int);

    

};
