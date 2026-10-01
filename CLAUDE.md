# CLAUDE.md

## Commandes

```bash
bundle install     # Installer les dépendances
bundle exec rspec  # Lancer les tests
bin/ci test        # Point d'entrée CI (identique en local)
```

`bundle exec rspec` laisse la couverture éteinte. `bin/ci` exporte `COVERAGE=true` par défaut, sauf si la variable est déjà posée. `spec/coverage_helper.rb` n'écrit `coverage/lcov.info` que lorsque `COVERAGE` vaut `true`.

## Dépendances

- `immosquare-constants` - Fournit le mapping des noms de couleurs vers HEX
