//
// Created by Zhou Yitao on 2018-12-04.
//

#include "Flow.h"

Flow::Flow(int id, float weight) {
    this->flowId = id;
    this->weight = weight;
    this->brustness = DEFAULT_BRUSTNESS;
    this->insertLevel = 0;
    this->lastDepartureRound = 0;
}

Flow::Flow(int id, float weight, int brustness) {
    this->flowId = id;
    this->weight = weight;
    this->brustness = brustness;
    this->insertLevel = 0;
    this->lastDepartureRound = 0;
}

int Flow::getLastDepartureRound() const {
    return lastDepartureRound;
}

void Flow::setLastDepartureRound(int lastDepartureRound) {
    Flow::lastDepartureRound = lastDepartureRound;
}

float Flow::getWeight() const {
    return weight;
}

void Flow::setWeight(float weight) {
    Flow::weight = weight;
}

int Flow::getInsertLevel() const {
    return insertLevel;
}

void Flow::setInsertLevel(int insertLevel) {
    Flow::insertLevel = insertLevel;
}

int Flow::getBrustness() const {
    return brustness;
} // 07102019 Peixuan: control flow brustness level


void Flow::setBrustness(int brustness) {
    Flow::brustness = brustness;
} // 07102019 Peixuan: control flow brustness level
