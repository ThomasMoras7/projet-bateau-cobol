# RUN 1 — Navigation Basics

Goal: visit all 5 ports. Buy and sell goods to fund your journey. No save/load — each run is a fresh start.

Fuel cost: **30** per journey. If you can't afford it, you lose.

## Issues

### Issue 1.1 — Project setup + copybooks + build script

- [x] Create `src/copybooks/port-rec` (PORT-RECORD: PORT-ID, PORT-NAME, PORT-DESCRIPTION, PORT-VISITED)
- [x] Create `src/copybooks/game-rec` (GAME-RECORD for future save file)
- [x] Create `src/copybooks/game-dat` (WS-GAME-DATA for LINKAGE)
- [x] Create `src/copybooks/gds-dat` (WS-GOODS-LIST — 5 goods with base prices)
- [x] Create `src/copybooks/pric-dat` (WS-GOODS-PRICES-LIST — 5×5 price grid)
- [x] Create `build-game.ps1` (compiles game.cbl + subprograms into single exe)
- [x] Update `AGENTS.md` with game workflow
- [x] Update `README.md` with game description

### Issue 1.2 — initialisation module

- [x] Create `src/initialisation.cbl`
- [x] Receives `GAME-DATA` + `GOODS-PRICES-LIST` via LINKAGE
- [x] Sets money=500, current-port=1, visited=0, status="PLAYING"
- [x] Generates random goods prices for each port (5 goods × 5 ports): base price × (1 ± random(0.5))
- [x] `GOBACK` to return

**Dependencies**: 1.1

### Issue 1.3 — port-screen module

- [ ] Create `src/port.cbl`
- [ ] Receives `ACTION`, `ARG`, `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST`
- [ ] Displays current port name + description + visited status
- [ ] Shows current money and fuel cost (30) for next trip
- [ ] Lists goods at current port with buy price
- [ ] Lets user buy goods (select good + quantity, deduct money)
- [ ] Lets user sell goods from cargo (if carrying any)
- [ ] Lists other ports with their IDs
- [ ] Lets user type a port ID or 0 to quit
- [ ] Validates input: must be a valid port (not current, not out of range)
- [ ] Sets `ACTION` (0=quit, 1=navigate) and `ARG` (port ID)
- [ ] Loop until valid choice
- [ ] `GOBACK` to return

**Dependencies**: 1.1

### Issue 1.4 — main game (game.cbl)

- [ ] Create `src/game.cbl`
- [ ] Title screen
- [ ] CALL initialisation (always fresh start)
- [ ] Builds port table from hardcoded literals (no file I/O)
- [ ] Game loop:
  1. CALL port-screen → get action + destination
  2. If action=0 (quit): set status to "LOST", exit loop
  3. Fuel check: if money < 30 → display "Not enough fuel!" → CALL end-screen("LOST"), exit loop
  4. Deduct 30 from money (fuel cost)
  5. Display travel narrative ("En route from X to Y...", "Arrived at destination!")
  6. Fluctuate goods prices: each price × (1 ± random(0.1))
  7. Mark destination port as visited
  8. Check win: all 5 ports visited → CALL end-screen("WON"), exit loop
- [ ] No file I/O, no .DAT files, no save/load in RUN 1
- [ ] STOP RUN

**Dependencies**: 1.2, 1.3

### Issue 1.5 — end-screen module

- [ ] Create `src/end-screen.cbl`
- [ ] Receives `RESULT` ("WON" or "LOST")
- [ ] Displays end screen with appropriate message
- [ ] `GOBACK` to return

**Dependencies**: 1.1

### Issue 1.6 — Integration test

- [ ] Build with `build-game.ps1` → compiles without errors
- [ ] Run from `bin/`
- [ ] Test NEW game: title → port → buy goods → navigate → sell goods → continue
- [ ] Test WIN: visit all 5 ports → game over screen
- [ ] Test LOSE: spend all money, try to navigate when money < 30 → "Not enough fuel!" → game over
- [ ] Test invalid port input: should get "Invalid port, try again."

**Dependencies**: 1.4, 1.5