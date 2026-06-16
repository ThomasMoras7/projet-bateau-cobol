# Optimisations

| Category | Code | Description |
|----------|------|-------------|
| Optimisations | `OPT` | Performance, logic, lightweight architecture |
| Factorisation | `FAC` | Strict DRY, atomic decomposition, feature-driven |
| Externalisation | `EXT` | Config files, no magic numbers/strings |
| Simplification | `SIM` | More lightweight, no unasked flavor text, no superfluous |

## Planned

### FAC-1 — Decouper port-screen.cbl en sous-programmes specialises (RUN 2+)

Le fichier `src/port-screen.cbl` contient toute la logique d'interface portuaire :
menu, achat, vente, navigation, refuel, fluctuation des prix. A terme, chaque
fonction pourrait etre extraite dans son propre sous-programme :

- `buy-screen.cbl` — logique d'achat
- `sell-screen.cbl` — logique de vente
- `navigation-screen.cbl` — logique de navigation
- `port-screen.cbl` — allège (menu + orchestration)

Interet : isoler les responsabilites, reduire la taille de chaque module,
faciliter les tests manuels, et eviter les conflits de WORKING-STORAGE.

Necessite RUN 2+ car les CALL avec LINKAGE sections ajoutent de la complexite.
Pour RUN 1, tout reste dans port-screen.cbl.

### SIM-1 — Supprimer les declarations inutilisees

Apres les renommages, certaines variables WORKING-STORAGE peuvent devenir
orphelines (ex: `WS-I` dans port-screen.cbl apres renommage en
`WS-LOOP-PORT-INDEX`). A nettoyer lors d'un futur refactoring.

### OPT-1 — Test victoire deterministe

Le test WIN (`test-game.ps1` #7) ne peut pas garantir la victoire car les
prix sont aleatoires. Deux solutions pour un test WIN deterministe :

**Option A — Seed fixe pour FUNCTION RANDOM**

Si GnuCOBOL permet d'initialiser `FUNCTION RANDOM` avec une seed via
`MOVE <valeur> TO RANDOM-SEED` (ou equivalent), les memes entrees
produiront toujours les memes prix. Le test WIN peut alors etre cale sur
cette seed. A investiguer.

**Option B — Mode test avec prix previsibles**

Ajouter une variable d'environnement `TEST_MODE=1` lue au demarrage :
- Dans `initialisation.cbl`, ignorer `FUNCTION RANDOM`, utiliser des prix
  fixes garantissant un profit (ex: Electronique a 5000 à Shanghai, 12000
  a Rotterdam, 6000 a Singapour…).
- Pas de fluctuation au depart.
- Le test WIN devient reproductible a 100 %.

Interet supplementaire : les autres tests (achat/revente, navigation)
restent valables sur des prix fixes sans surprise.

Inconvenient : complexite supplementaire pour RUN 1. A implementer en RUN 2
ou avant si les tests deviennent critiques.

### OPT-2 — Strategie de trading (documentation)

L'economie du jeu repose sur un ecart de prix aleatoire entre ports :
`prix = base × (0.5 + RANDOM)`. Un meme bien peut valoir 50 % ou 150 %
de son prix de base selon le port. La strategie optimale s'appuie sur
cet ecart :

1. **Reperer le bien le moins cher** au port courant (prix < base)
2. **Acheter en quantite** (le cargo est illimite en RUN 1)
3. **Au port suivant, reperer le bien le plus cher** (prix > base)
4. **Vendre** ce qu'on transporte si le prix est superieur au prix d'achat
5. **Acheter le bien le moins cher** de ce nouveau port
6. **Recommencer** jusqu'au dernier port, puis tout revendre

L'electronique (base 9000) offre les meilleures marges absolues :
  - A 5000 a Shanghai, revendu 12000 a Rotterdam → +140 % (7000$ × N tonnes)
  - De quoi financer largement les 4 pleins (200 000$)

A noter : en RUN 1, les prix d'achat et de vente au meme port sont
identiques. La marge ne se fait que par l'ecart inter-ports. RUN 2+
pourrait introduire un spread achat/vente (ex: -10 % / +10 %).
