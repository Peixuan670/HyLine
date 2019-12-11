//
// Created by Zhou Yitao on 2018-12-04.
//

#include "Flow_pl.h"

Flow_pl::Flow_pl(int saddr, int daddr, float weight) {
    this->key = {saddr, daddr};
    this->weight = weight;
    this->brustness = DEFAULT_BRUSTNESS;
    this->insertLevel = 0;
    this->lastDepartureRound = 0;
}

Flow_pl::Flow_pl(int saddr, int daddr, float weight, int brustness) {
    this->key = {saddr, daddr};
    this->weight = weight;
    this->brustness = brustness;
    this->insertLevel = 0;
    this->lastDepartureRound = 0;
}

int Flow_pl::getLastDepartureRound() const {
    return lastDepartureRound;
}

void Flow_pl::setLastDepartureRound(int lastDepartureRound) {
    Flow_pl::lastDepartureRound = lastDepartureRound;
}

float Flow_pl::getWeight() const {
    return weight;
}

void Flow_pl::setWeight(float weight) {
    Flow_pl::weight = weight;
}

int Flow_pl::getInsertLevel() const {
    return insertLevel;
}

void Flow_pl::setInsertLevel(int insertLevel) {
    Flow_pl::insertLevel = insertLevel;
}

int Flow_pl::getBrustness() const {
    return brustness;
} // 07102019 Peixuan: control flow brustness level


void Flow_pl::setBrustness(int brustness) {
    Flow_pl::brustness = brustness;
} // 07102019 Peixuan: control flow brustness level
