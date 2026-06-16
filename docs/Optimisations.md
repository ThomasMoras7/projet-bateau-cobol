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
