# Projet Bateau — Game Design Document

## Concept

A turn-based maritime shipping game written in COBOL. You inherit a wreck and must build a trading empire — or sink trying. Roguelike, with absurd humor.

## Tone

Self-deprecating absurd humor.

## Core Loop

Navigate between ports, buy low and sell high, manage fuel costs.

1. Buy goods at current port
2. Pick a destination port
3. Pay fuel cost to depart
4. Arrive at destination
5. Sell goods, buy new ones
6. Repeat

Lose: cannot afford fuel to reach any other port.

## Goods

Five types of cargo, each with a base price. Prices vary per port.

Starting capital: **120 000 $**. Goods are priced per ton.

| # | Good | Base Price ($/ton) |
|---|------|-----------|
| 1 | Coffee | 3 000 |
| 2 | Cotton | 2 000 |
| 3 | Spices | 5 500 |
| 4 | Wine | 4 000 |
| 5 | Electronics | 9 000 |

**Price generation** : at game start, each port gets a random buy price for each good:
initial price = base price × (1 ± random(0.5)) — large ±50 % variation.
At each departure, all prices fluctuate slightly: current price × (1 ± random(0.1)) — small ±10 %.

## Ports (RUN 1, hardcoded)

| # | Name | Description |
|---|------|-------------|
| 1 | Shanghai (China) | Le plus grand port du monde. Trafic non-stop. |
| 2 | Rotterdam (Netherlands) | Porte d'entrée de l'Europe. Attention aux écluses. |
| 3 | Singapore | Plateforme asiatique ultra-moderne. |
| 4 | New York (USA) | La statue de la Liberté veille sur le port. |
| 5 | Marseille (France) | Le premier port de France. Le pastis coule à flots. |

## Fuel

Each journey costs **50 000 $** in fuel. If the player cannot afford fuel when trying to depart, the game is lost.

## Future RUNs (draft)

- **RUN 2** : save/load game state, delivery contracts, refined economy
- **RUN 3** : multiple ships, shipyard, fleet management
- **RUN 4** : UI polish, balance tuning, difficulty modes
