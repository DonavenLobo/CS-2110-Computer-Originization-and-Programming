#ifndef MAIN_H
#define MAIN_H

#include "gba.h"

// TODO: Create any necessary structs

typedef struct ball {
    int row;
    int col;
    int rd;
    int cd;
} socBall;

typedef struct goalie {
    int row;
    int col;
} gk;



typedef struct state {
    int size;
    int currentState;
    int goals;
    socBall ball;
    gk goalie;
} State;


/*
* For example, for a Snake game, one could be:
*
* struct snake {
*   int heading;
*   int length;
*   int row;
*   int col;
* };
*
* Example of a struct to hold state machine data:
*
* struct state {
*   int currentState;
*   int nextState;
* };
*
*/

#endif
