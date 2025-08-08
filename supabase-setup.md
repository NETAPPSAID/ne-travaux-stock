# Configuration Supabase pour NE TRAVAUX GESTION DE STOCK

## 1. Créer un projet Supabase

1. Allez sur https://supabase.com
2. Créez un compte ou connectez-vous
3. Cliquez sur "New Project"
4. Nommez le projet : "ne-travaux-stock"
5. Créez un mot de passe pour la base de données
6. Sélectionnez une région (Europe de l'Ouest recommandée)
7. Cliquez sur "Create new project"

## 2. Structure de la base de données

### Tables à créer :

1. **users** - Utilisateurs et leurs rôles
2. **chantiers** - Chantiers de construction
3. **articles** - Articles de stock
4. **stock_movements** - Historique des entrées/sorties
5. **commandes** - Commandes passées
6. **uploaded_files** - Fichiers uploadés (bons d'entrée)

## 3. Configuration des variables d'environnement

Créer un fichier `.env` avec :
```
VITE_SUPABASE_URL=votre_url_supabase
VITE_SUPABASE_ANON_KEY=votre_clé_anon
```

## 4. Installation des dépendances

```bash
npm install @supabase/supabase-js
```

## 5. Migration des données

- Migrer les données existantes de localStorage vers Supabase
- Configurer les politiques de sécurité (RLS)
- Tester la synchronisation en temps réel
