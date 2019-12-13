//
// Created by Zhou Yitao on 2018-12-04.
//

#ifndef HIERARCHICALSCHEDULING_TASK_H
#define HIERARCHICALSCHEDULING_TASK_H

// will be used in package-send function
#include "queue.h"
#include "address.h"
//#include <tuple>
#include <functional>
#include <utility>

using namespace std;

class Flow_pl {
private:
    // int flowId;
    //std::tuple<int, int> key;
    std::pair<int,int> key;
    float weight;
    int brustness; // 07102019 Peixuan: control flow brustness level
    static const int DEFAULT_BRUSTNESS = 1000;  // 07102019 Peixuan: control flow brustness level

    int lastDepartureRound;
    int insertLevel;
public:
    Flow_pl(nsaddr_t saddr, nsaddr_t daddr, float weight);
    Flow_pl(nsaddr_t saddr, nsaddr_t daddr, float weight, int brustness); // 07102019 Peixuan: control flow brustness level

    float getWeight() const;
    int getBrustness() const; // 07102019 Peixuan: control flow brustness level
    void setBrustness(int brustness); // 07102019 Peixuan: control flow brustness level

    int getLastDepartureRound() const;
    void setLastDepartureRound(int lastDepartureRound);

    void setWeight(float weight);

    int getInsertLevel() const;

    void setInsertLevel(int insertLevel);
};


#endif //HIERARCHICALSCHEDULING_TASK_H
