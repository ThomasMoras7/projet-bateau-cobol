[Index](Index.md) > GameDesign

# Projet Bateau — Game Design

## Concept

Turn-based maritime trading game in COBOL. Inherit a wreck, buy low and sell high across 5 ports, manage fuel costs. Roguelike one-sitting format with absurd humor.

## Core Loop

1. Arrive at port → see current info + goods prices
2. Sell cargo (if profitable), refuel (50k), buy goods
3. Pick a destination → pay fuel → depart
4. Arrive → prices fluctuate → repeat
5. Visit all 5 ports to win. Can't afford fuel? Lose.

## Goods

| # | Good | Base Price |
|---|------|-----------|
| 1 | Cafe | 3 000 |
| 2 | Coton | 2 000 |
| 3 | Epices | 5 500 |
| 4 | Vin | 4 000 |
| 5 | Electronique | 9 000 |

Prices per port randomized at game start: `base × (0.5 + RANDOM)` → from 50 % to 150 %. Each departure fluctuates all prices: `current × (0.9 + RANDOM × 0.2)` → from 90 % to 110 %.

## Ports

| # | Name | Description |
|---|------|-------------|
| 1 | Shanghai (Chine) | Le plus grand port du monde. Trafic non-stop. |
| 2 | Rotterdam (Pays-Bas) | Porte d'entree de l'Europe. Attention aux ecluses. |
| 3 | Singapour (Singapour) | Plateforme asiatique ultramoderne. Taxes ultra basses. |
| 4 | New York (Etats-Unis) | La statue de la Liberte veille sur les bateaux. |
| 5 | Marseille (France) | Le premier port de France. Le pastis coule a flots. |

Starting port: Shanghai.

## Fuel

Binary state: empty (0) or full (1), starts empty. Refuel costs **50 000 $**. Navigation empties the tank. Lose if fuel is empty AND money < 50 000 when attempting to depart.

## Win / Lose

- **Win**: `WS-VISITED-PORTS-COUNT >= 5` (visit all 5 ports)
- **Lose**: fuel empty, money < 50 000, player tries to navigate → `MOVE "LOST" TO WS-STATUS`
- **Quit**: option 0 at any time

## Code

GnuCOBOL 3.2.0 (portable MinGW). Single executable. All user-facing text in French. No comments in code — documentation is the source of truth.
