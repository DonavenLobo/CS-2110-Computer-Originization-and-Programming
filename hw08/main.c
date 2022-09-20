#include "main.h"

#include <stdio.h>
#include <stdlib.h>

#include "gba.h"
#include "images/Win.h"
#include "images/Lose.h"
#include "images/Start.h"
#include "images/Ball.h"
#include "images/Field.h"
#include "images/Goalie.h"


enum gba_state {
  START,
  PLAY,
  WIN,
  LOSE,
};

int main(void) {
  /* TODO: */
  // Manipulate REG_DISPCNT here to set Mode 3. //
  REG_DISPCNT = MODE3 | BG2_ENABLE;

  // Save current and previous state of button input.
  u32 previousButtons = BUTTONS;
  u32 currentButtons = BUTTONS;

  // Load initial application state
  enum gba_state state = START;

  // Save previous state and current state
  State cs, ps;

  // Set initial game conditions

  cs.ball.row = 70;
  cs.ball.rd = 3;
  cs.ball.col = 30;
  cs.ball.cd = 3;

  cs.goalie.row = 70;
  cs.goalie.col = 210;

  cs.size = 20;
  cs.currentState = state;
  cs.goals = 0;
  //cs.nextState = PLAY;

  char score[51];

  waitForVBlank();

  drawFullScreenImageDMA(Start);

  while (1) {

    ps = cs; // Store previous State

    currentButtons = BUTTONS; // Load the current state of the buttons

    /* TODO: */
    // Manipulate the state machine below as needed //
    // NOTE: Call waitForVBlank() before you draw

    switch (cs.currentState) {
      case START:
          if (KEY_JUST_PRESSED(BUTTON_START, currentButtons, previousButtons)) {
              cs.currentState = PLAY;

              waitForVBlank();


              drawFullScreenImageDMA(Field);


              break;
          }

          waitForVBlank();

          sprintf(score, "Goals Scored: %d", cs.goals);
          drawString(120, 70, score, BLACK);

          

          //drawFullScreenImageDMA(Start);

          
          drawString(80, 60, "Hit Start To Play!", WHITE);

          cs.currentState = START;

          break;
        
      case PLAY:

          if (KEY_JUST_PRESSED(BUTTON_SELECT, currentButtons, previousButtons)) {
              cs.currentState = START;
              cs.ball.row = 70;
              cs.ball.col = 30;

              waitForVBlank();

              drawFullScreenImageDMA(Start);



              break;
          }


          if (KEY_DOWN(BUTTON_LEFT, currentButtons)) {
              cs.ball.col -= cs.ball.cd;
              if (cs.ball.col <= 0) {
                  cs.currentState = LOSE;
                  waitForVBlank();
                  drawFullScreenImageDMA(Lose);
                  break;
              }
          }

          if (KEY_DOWN(BUTTON_RIGHT, currentButtons)) {
              cs.ball.col += cs.ball.cd;
              if (cs.ball.col >= WIDTH - cs.size) {
                  cs.currentState = WIN;
                  cs.goals += 1;
                  waitForVBlank();
                  drawFullScreenImageDMA(Win);
                  break;
              }
          }

          if (KEY_DOWN(BUTTON_UP, currentButtons)) {
              cs.ball.row -= cs.ball.rd;
              if (cs.ball.row <= 0) {
                  cs.currentState = LOSE;
                  waitForVBlank();
                  drawFullScreenImageDMA(Lose);
                  break;
              }
          }

          if (KEY_DOWN(BUTTON_DOWN, currentButtons)) {
              cs.ball.row += cs.ball.rd;
              if (cs.ball.row >= HEIGHT - cs.size) {
                  cs.currentState = LOSE;
                  waitForVBlank();
                  drawFullScreenImageDMA(Lose);
                  break;
              }
          }

          if (cs.ball.row <= (cs.goalie.row + 20) && cs.ball.row >= (cs.goalie.row - 20)
              && cs.ball.col <= (cs.goalie.col + 20) && cs.ball.col >= (cs.goalie.col - 20 )) {
              cs.currentState = LOSE;
              waitForVBlank();
              drawFullScreenImageDMA(Lose);
              break;
          }

          waitForVBlank();

          undrawImageDMA(ps.ball.row, ps.ball.col, ps.size, ps.size, Field);

          drawImageDMA(cs.ball.row, cs.ball.col, cs.size, cs.size, Ball);

          drawImageDMA(cs.goalie.row, cs.goalie.col, cs.size, cs.size, Goalie);
          
          drawString(0, 10, "Objective: Reach right side of", RED);
          drawString(10, 10, "screen to Win!", RED);
          drawString(20, 10, "Watch Out: Avoid the Goalie!", RED);

      

          cs.currentState = PLAY;

        break;

      case WIN:
          if (KEY_JUST_PRESSED(BUTTON_SELECT, currentButtons, previousButtons)) {
              cs.currentState = START;
              cs.ball.row = 70;
              cs.ball.col = 30;

              waitForVBlank();

              drawFullScreenImageDMA(Start);
              break;
          }

          waitForVBlank();
          //drawFullScreenImageDMA(Win);
          drawString(80, 100, "YOU SCORED!", GREEN);
          cs.currentState = WIN;
          break;

      case LOSE:
          if (KEY_JUST_PRESSED(BUTTON_SELECT, currentButtons, previousButtons)) {
              cs.currentState = START;
              cs.ball.row = 70;
              cs.ball.col = 30;

              waitForVBlank();

              drawFullScreenImageDMA(Start);

              break;
          }

          waitForVBlank();
          //drawFullScreenImageDMA(Lose);

          drawString(80, 60, "YOU MISSED :(", RED);
          cs.currentState = WIN;

          cs.currentState = LOSE;
          break;
    }

    previousButtons = currentButtons; // Store the current state of the buttons
  }


  return 0;
}
