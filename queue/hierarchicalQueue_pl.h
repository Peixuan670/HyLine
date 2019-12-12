#include "Level.h"
#include "Flow_pl.h"
#include <vector>
#include <map>
//#include <tuple>
#include <functional>
using namespace std;

class hierarchicalQueue_pl : public Queue {
private:
    static const int DEFAULT_VOLUME = 3;
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

    //vector<Flow> flows;
    //map<tuple<int, int>, Flow_pl> flowMap;
    map<std::pair<int, int>, Flow_pl> flowMap;
    //06262019 Peixuan
    vector<Packet*> pktCurRound;

    // 06262019 Peixuan
    vector<Packet*> runRound();
    vector<Packet*> serveUpperLevel(int);
    void setPktCount(int);
public:
    hierarchicalQueue_pl();
    Flow_pl getFlow();
    explicit hierarchicalQueue_pl(int);
    void enque(Packet*);
    Packet* deque();
    void setCurrentRound(int);
    int cal_theory_departure_round(hdr_ip*, int);
    int cal_insert_level(int, int);
    // Packet* serveCycle();
    // vector<Packet> serveUpperLevel(int &, int);
};