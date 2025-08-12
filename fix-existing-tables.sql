-- Script pour corriger les tables existantes
-- À exécuter dans Supabase SQL Editor

-- ===== ÉTAPE 1 : VÉRIFIER LES TABLES EXISTANTES =====
SELECT '=== TABLES EXISTANTES ===' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('entrees', 'sorties', 'commandes')
ORDER BY table_name;

-- ===== ÉTAPE 2 : SUPPRIMER LES TABLES EXISTANTES =====
-- (Si elles ont une structure incorrecte)

-- Supprimer les politiques RLS d'abord
DROP POLICY IF EXISTS "Tous peuvent voir les entrées" ON entrees;
DROP POLICY IF EXISTS "Tous peuvent créer des entrées" ON entrees;
DROP POLICY IF EXISTS "Tous peuvent voir les sorties" ON sorties;
DROP POLICY IF EXISTS "Tous peuvent créer des sorties" ON sorties;
DROP POLICY IF EXISTS "Tous peuvent voir les commandes" ON commandes;
DROP POLICY IF EXISTS "Tous peuvent créer des commandes" ON commandes;
DROP POLICY IF EXISTS "Tous peuvent modifier les commandes" ON commandes;

-- Supprimer les tables
DROP TABLE IF EXISTS entrees CASCADE;
DROP TABLE IF EXISTS sorties CASCADE;
DROP TABLE IF EXISTS commandes CASCADE;

-- ===== ÉTAPE 3 : CRÉER LES TABLES AVEC LA BONNE STRUCTURE =====

-- Table ENTRÉES
CREATE TABLE entrees (
    id SERIAL PRIMARY KEY,
    article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
    chantier_id INTEGER REFERENCES chantiers(id) ON DELETE CASCADE,
    quantite INTEGER NOT NULL,
    date_entree TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    bon_entree_url TEXT,
    pointeur_matricule INTEGER REFERENCES users(matricule),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table SORTIES
CREATE TABLE sorties (
    id SERIAL PRIMARY KEY,
    article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
    chantier_id INTEGER REFERENCES chantiers(id) ON DELETE CASCADE,
    quantite INTEGER NOT NULL,
    date_sortie TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    motif TEXT,
    bon_sortie_url TEXT,
    pointeur_matricule INTEGER REFERENCES users(matricule),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table COMMANDES
CREATE TABLE commandes (
    id SERIAL PRIMARY KEY,
    chantier_id INTEGER REFERENCES chantiers(id) ON DELETE CASCADE,
    article_nom TEXT NOT NULL,
    quantite INTEGER NOT NULL,
    message TEXT,
    statut TEXT DEFAULT 'en_attente', -- en_attente, approuvee, rejetee
    pointeur_matricule INTEGER REFERENCES users(matricule),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===== ÉTAPE 4 : CRÉER LES POLITIQUES RLS =====

-- Politiques pour les entrées
ALTER TABLE entrees ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tous peuvent voir les entrées" ON entrees FOR SELECT USING (true);
CREATE POLICY "Tous peuvent créer des entrées" ON entrees FOR INSERT WITH CHECK (true);

-- Politiques pour les sorties
ALTER TABLE sorties ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tous peuvent voir les sorties" ON sorties FOR SELECT USING (true);
CREATE POLICY "Tous peuvent créer des sorties" ON sorties FOR INSERT WITH CHECK (true);

-- Politiques pour les commandes
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tous peuvent voir les commandes" ON commandes FOR SELECT USING (true);
CREATE POLICY "Tous peuvent créer des commandes" ON commandes FOR INSERT WITH CHECK (true);
CREATE POLICY "Tous peuvent modifier les commandes" ON commandes FOR UPDATE USING (true);

-- ===== ÉTAPE 5 : CRÉER LES INDEX =====
CREATE INDEX idx_entrees_chantier ON entrees(chantier_id);
CREATE INDEX idx_entrees_pointeur ON entrees(pointeur_matricule);
CREATE INDEX idx_entrees_date ON entrees(date_entree);

CREATE INDEX idx_sorties_chantier ON sorties(chantier_id);
CREATE INDEX idx_sorties_pointeur ON sorties(pointeur_matricule);
CREATE INDEX idx_sorties_date ON sorties(date_sortie);

CREATE INDEX idx_commandes_chantier ON commandes(chantier_id);
CREATE INDEX idx_commandes_pointeur ON commandes(pointeur_matricule);
CREATE INDEX idx_commandes_statut ON commandes(statut);

-- ===== MESSAGE DE CONFIRMATION =====
SELECT '✅ Tables créées avec succès!' as message;
