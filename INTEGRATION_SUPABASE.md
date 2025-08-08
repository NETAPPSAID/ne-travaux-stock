# 🚀 Guide d'Intégration Supabase - NE TRAVAUX GESTION DE STOCK

## 📋 Étapes d'Intégration

### Étape 1 : Création du Projet Supabase (5 minutes)

1. **Allez sur https://supabase.com**
2. **Créez un compte** ou connectez-vous
3. **Cliquez "New Project"**
4. **Configurez le projet :**
   - Nom : `ne-travaux-stock`
   - Mot de passe : `ne-travaux-2024`
   - Région : Europe (Paris)
   - Cliquez "Create new project"

### Étape 2 : Récupération des Clés API (2 minutes)

1. **Dans le dashboard Supabase**, allez dans **Settings** → **API**
2. **Copiez ces informations :**
   - **URL** : `https://votre-projet.supabase.co`
   - **anon public** : clé publique
   - **service_role** : clé secrète (à garder privée)

### Étape 3 : Configuration de la Base de Données (10 minutes)

1. **Allez dans "SQL Editor"** dans le dashboard Supabase
2. **Copiez et exécutez** le contenu du fichier `database-setup.sql`
3. **Vérifiez que les tables sont créées** dans "Table Editor"

### Étape 4 : Configuration de l'Application (5 minutes)

1. **Créez un fichier `.env`** à la racine du projet :
```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre_clé_anon
```

2. **Installez les dépendances** :
```bash
npm install @supabase/supabase-js
```

### Étape 5 : Intégration dans le Code (15 minutes)

1. **Modifiez `supabase-config.js`** avec vos vraies clés
2. **Décommentez les lignes Supabase** dans le fichier
3. **Remplacez les fonctions localStorage** par les appels Supabase

### Étape 6 : Test et Migration (10 minutes)

1. **Testez la connexion** avec les données existantes
2. **Migrez les données** du localStorage vers Supabase
3. **Vérifiez la synchronisation** en temps réel

## 🔧 Configuration Détaillée

### Structure des Tables

- **users** : Utilisateurs et rôles
- **chantiers** : Chantiers de construction
- **articles** : Articles de stock par chantier
- **stock_movements** : Historique des entrées/sorties
- **commandes** : Commandes passées
- **uploaded_files** : Fichiers uploadés

### Politiques de Sécurité (RLS)

- **Lecture** : Tous les utilisateurs peuvent voir les données
- **Écriture** : Seuls les utilisateurs authentifiés peuvent créer/modifier
- **Admin** : Seul l'admin (matricule 100) peut gérer les utilisateurs et chantiers

### Fonctionnalités Avancées

- **Synchronisation temps réel** : Changements instantanés
- **Upload de fichiers** : Bons d'entrée via Supabase Storage
- **Historique complet** : Tous les mouvements de stock
- **Gestion par chantier** : Stock séparé par chantier

## 🧪 Tests à Effectuer

### Test 1 : Connexion
- [ ] Connexion avec matricule 100 (admin)
- [ ] Connexion avec matricule 200-600 (pointeurs)
- [ ] Vérification des rôles et permissions

### Test 2 : Gestion du Stock
- [ ] Affichage du stock par chantier
- [ ] Saisie d'entrées et sorties
- [ ] Validation des mouvements
- [ ] Upload de bons d'entrée

### Test 3 : Commandes
- [ ] Passage de commandes par pointeurs
- [ ] Visualisation par l'admin
- [ ] Ajout de notes/messages

### Test 4 : Interface Admin
- [ ] Gestion des utilisateurs
- [ ] Gestion des chantiers
- [ ] Gestion des articles
- [ ] Historique des mouvements

### Test 5 : Documents
- [ ] Génération de bons de livraison
- [ ] Impression d'état de stock
- [ ] Intégration du logo

## 🚨 Problèmes Courants

### Problème 1 : Erreur de Connexion
**Solution :** Vérifiez les clés API dans `.env`

### Problème 2 : Données non synchronisées
**Solution :** Vérifiez les politiques RLS

### Problème 3 : Upload de fichiers échoue
**Solution :** Configurez Supabase Storage

## 📈 Prochaines Étapes

1. **Déploiement Netlify** (après tests locaux)
2. **Optimisation des performances**
3. **Ajout de fonctionnalités avancées**
4. **Monitoring et analytics**

## 🆘 Support

Si vous rencontrez des problèmes :
1. Vérifiez la console du navigateur
2. Vérifiez les logs Supabase
3. Testez avec les données de base
4. Contactez le support si nécessaire

---

**Prêt à commencer ?** Suivez les étapes dans l'ordre et testez chaque étape avant de passer à la suivante.
