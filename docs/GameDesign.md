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

| # | Good | Base Price |
|---|------|-----------|
| 1 | Coffee | 50 |
| 2 | Cotton | 40 |
| 3 | Spices | 80 |
| 4 | Wine | 60 |
| 5 | Electronics | 120 |

**Price generation** : at game start, each port gets a random buy price for each good:
initial price = base price × (1 ± random(0.5)) — large ±50 % variation.
At each departure, all prices fluctuate slightly: current price × (1 ± random(0.1)) — small ±10 %.

## Ports (RUN 1, hardcoded)

| # | Name | Description |
|---|------|-------------|
| 1 | Shanghai (China) | The world's largest port. Non-stop traffic. |
| 2 | Rotterdam (Netherlands) | Gateway to Europe. Mind the locks. |
| 3 | Singapore | Ultra-modern Asian hub. Ultra-low taxes. |
| 4 | New York (USA) | The Statue of Liberty watches over the harbor. |
| 5 | Marseille (France) | France's top port. Pastis flows freely. |

## Fuel

Each journey costs **30** in fuel. If the player cannot afford fuel when trying to depart, the game is lost.

## Future RUNs (draft)

- **RUN 2** : save/load game state, delivery contracts, refined economy
- **RUN 3** : multiple ships, shipyard, fleet management
- **RUN 4** : UI polish, balance tuning, difficulty modes
