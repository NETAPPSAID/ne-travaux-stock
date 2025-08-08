# NE TRAVAUX - Gestion de Stock

Application web PWA pour la gestion de stock dans le secteur BTP, développée avec React, Tailwind CSS et Supabase.

## 🚀 Fonctionnalités

- **Gestion de stock par chantier** : Chaque pointeur gère le stock de son chantier assigné
- **Interface admin complète** : Gestion des articles, utilisateurs, chantiers
- **Synchronisation temps réel** : Mises à jour instantanées via Supabase
- **Upload de fichiers** : Bons d'entrée avec support images et PDF
- **Génération de documents** : Bons de livraison et états de stock
- **PWA installable** : Fonctionne hors ligne et s'installe comme une app

## 👥 Utilisateurs

- **Admin (Matricule 100)** : Accès complet à toutes les fonctionnalités
- **Pointeurs (200-600)** : Gestion du stock de leur chantier assigné

## 🛠️ Technologies

- **Frontend** : React 18, Tailwind CSS
- **Backend** : Supabase (PostgreSQL, Storage, Real-time)
- **PWA** : Service Worker, Manifest
- **Déploiement** : Netlify

## 📦 Installation Locale

1. **Cloner le repository**
   ```bash
   git clone [URL_DU_REPO]
   cd ne-travaux-stock
   ```

2. **Installer les dépendances**
   ```bash
   npm install
   ```

3. **Configurer les variables d'environnement**
   Créer un fichier `.env` :
   ```
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Lancer le serveur local**
   ```bash
   npx http-server -p 8000
   ```

5. **Ouvrir** `http://localhost:8000`

## 🌐 Déploiement

### Déploiement sur Netlify

1. **Connecter le repository Git** à Netlify
2. **Configurer les variables d'environnement** dans Netlify :
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
3. **Déployer automatiquement** à chaque push

### Configuration Supabase

1. **Créer un projet Supabase**
2. **Exécuter le script SQL** (`database-setup.sql`)
3. **Configurer les variables d'environnement**

## 🔧 Configuration

### Variables d'environnement requises

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
```

### Structure de la base de données

- **users** : Utilisateurs et rôles
- **chantiers** : Sites de construction
- **articles** : Stock par chantier
- **stock_movements** : Historique des entrées/sorties
- **commandes** : Commandes avec notes
- **uploaded_files** : Fichiers uploadés

## 📱 Utilisation

### Connexion
- **Admin** : Matricule 100, mot de passe `admin123`
- **Pointeurs** : Matricules 200-600, mot de passe `pointeur123`

### Fonctionnalités principales

#### Pour les Pointeurs :
- Gestion du stock de leur chantier
- Saisie entrées/sorties avec validation
- Upload de bons d'entrée (optionnel)
- Placement de commandes avec notes

#### Pour l'Admin :
- Gestion complète des articles, utilisateurs, chantiers
- Vue globale du stock par chantier
- Historique des mouvements
- Génération d'états de stock

## 🔄 Mise à jour

Pour modifier l'application :

1. **Faire les changements** dans le code
2. **Commiter et pousser** vers Git
3. **Netlify déploie automatiquement**

## 📞 Support

Pour toute question ou problème, consulter la documentation Supabase ou contacter l'équipe de développement.
