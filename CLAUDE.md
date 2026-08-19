# CLAUDE.md

## Commandes

```bash
bundle install     # Installer les dépendances
bundle exec rspec  # Lancer les tests
bin/ci test        # Point d'entrée CI (identique en local)
```

La couverture est désactivée par défaut : `COVERAGE=true bundle exec rspec` l'active et écrit `coverage/lcov.info`.

## Dépendances

- `immosquare-constants` - Fournit le mapping des noms de couleurs vers HEX
