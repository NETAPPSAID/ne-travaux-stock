# NE TRAVAUX - Gestion de Stock BTP

Application web responsive pour la gestion de stock dans le secteur BTP, conçue comme une PWA (Progressive Web App) installable.

## 🚀 Fonctionnalités

### 🔐 Connexion
- **Matricules disponibles :**
  - `100` : Said El Khalfaoui (Admin)
  - `200` : Pointeur 1 (Chantier A)
  - `300` : Pointeur 2 (Chantier B)
  - `400` : Pointeur 3 (Chantier C)
  - `500` : Pointeur 4 (Chantier D)
  - `600` : Pointeur 5 (Chantier E)

### 📦 Gestion de Stock
- **Articles initiaux :**
  - 🛠️ Ciment (100 unités)
  - 🏖️ Sable (500 unités)
  - 🧱 Briques (1000 unités)

- **Fonctionnalités :**
  - Gestion des entrées/sorties de stock
  - Calcul automatique des quantités
  - Génération de bons de livraison
  - Impression d'états de stock
  - Upload de bons d'entrée (simulation)

### 📋 Commandes
- Système de commandes partagées
- Notifications visuelles pour tous les utilisateurs
- Export CSV des commandes
- Impression de rapports

### ⚙️ Administration (Admin uniquement)
- Gestion des utilisateurs (modifier chantiers, supprimer)
- Gestion des articles (ajouter, supprimer)
- Export des données
- Rapports administratifs

## 🛠️ Technologies

- **Frontend :** React 18
- **Styles :** Tailwind CSS
- **Stockage :** localStorage (simulation backend)
- **PWA :** Manifest + Service Worker
- **Icônes :** Emojis pour une identification visuelle rapide

## 📱 Installation et Utilisation

### 1. Lancement de l'application
```bash
# Ouvrir le fichier index.html dans un navigateur web
# Ou utiliser un serveur local :
python -m http.server 8000
# Puis ouvrir http://localhost:8000
```

### 2. Installation comme PWA
1. Ouvrir l'application dans Chrome/Edge
2. Cliquer sur l'icône d'installation dans la barre d'adresse
3. Ou utiliser le menu "Ajouter à l'écran d'accueil"

### 3. Test des fonctionnalités

#### Connexion Admin (Matricule 100)
- Accès complet à toutes les fonctionnalités
- Gestion des utilisateurs et articles
- Rapports administratifs

#### Connexion Pointeur (Matricules 200-600)
- Consultation du stock
- Passage de commandes
- Gestion des entrées/sorties
- Génération de bons de livraison

## 📋 Guide d'utilisation

### Gestion du Stock
1. **Modifier les quantités :**
   - Saisir les valeurs dans les champs "Entrée" et "Sortie"
   - La quantité totale se met à jour automatiquement

2. **Passer une commande :**
   - Saisir la quantité souhaitée
   - Cliquer sur "Commander"
   - La commande apparaît dans l'onglet "Commandes"

3. **Imprimer l'état :**
   - Cliquer sur "Imprimer État"
   - Une nouvelle fenêtre s'ouvre avec le rapport

4. **Générer un bon de livraison :**
   - Cliquer sur "Bon de Livraison"
   - Le fichier se télécharge automatiquement

### Administration
1. **Gérer les utilisateurs :**
   - Modifier les noms et chantiers
   - Supprimer des utilisateurs (sauf admin)

2. **Gérer les articles :**
   - Ajouter de nouveaux articles avec icônes
   - Supprimer des articles existants

3. **Exporter les données :**
   - Export JSON des données complètes
   - Rapports imprimables

## 🔧 Fonctionnalités PWA

- **Mode hors ligne :** Consultation du stock disponible
- **Installation :** Comme une application native
- **Responsive :** Adapté PC, tablette, mobile
- **Cache :** Données stockées localement

## 📊 Structure des données

### Articles
```javascript
{
  id: number,
  nom: string,
  icone: string,
  quantite: number,
  entree: number,
  sortie: number
}
```

### Utilisateurs
```javascript
{
  matricule: string,
  nom: string,
  role: 'admin' | 'pointeur',
  chantier: string
}
```

### Commandes
```javascript
{
  id: number,
  articleId: number,
  nomArticle: string,
  quantite: number,
  nomUtilisateur: string,
  date: string
}
```

## 🎨 Interface utilisateur

- **Design responsive :** 1 colonne (mobile) → 2 colonnes (tablette) → 3 colonnes (PC)
- **Icônes emoji :** Identification visuelle rapide des articles
- **Couleurs distinctes :** Bleu (actions), Vert (ajouter), Rouge (supprimer)
- **Navigation simple :** Onglets clairs et intuitifs

## 🔒 Sécurité et données

- **Stockage local :** Données persistantes via localStorage
- **Pas de backend :** Simulation complète côté client
- **Rôles :** Admin vs Pointeur avec permissions différentes
- **Validation :** Contrôles de saisie et confirmations

## 📝 Notes techniques

- **Compatibilité :** Navigateurs modernes (Chrome, Firefox, Safari, Edge)
- **Performance :** Application légère et rapide
- **Maintenance :** Code modulaire et commenté
- **Évolutivité :** Structure prête pour l'ajout d'un backend réel

## 🚀 Déploiement

L'application peut être déployée sur :
- Serveur web classique
- GitHub Pages
- Netlify
- Vercel
- Tout hébergeur statique

## 📞 Support

Pour toute question ou amélioration :
- Vérifier la console du navigateur pour les erreurs
- Les données sont sauvegardées automatiquement
- Redémarrer l'application si nécessaire

---

**NE TRAVAUX - Gestion de Stock BTP**  
*Application simple et efficace pour la gestion de stock sur chantier*
