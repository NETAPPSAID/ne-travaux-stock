-- Script de création des tables pour les fonctionnalités pointeur (CORRIGÉ)
-- À exécuter dans Supabase SQL Editor

-- ===== TABLE ENTRÉES =====
CREATE TABLE IF NOT EXISTS entrees (
    id SERIAL PRIMARY KEY,
    article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
    chantier_id INTEGER REFERENCES chantiers(id) ON DELETE CASCADE,
    quantite INTEGER NOT NULL,
    date_entree TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    bon_entree_url TEXT,
    pointeur_matricule INTEGER REFERENCES users(matricule),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===== TABLE SORTIES =====
CREATE TABLE IF NOT EXISTS sorties (
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

-- ===== TABLE COMMANDES =====
CREATE TABLE IF NOT EXISTS commandes (
    id SERIAL PRIMARY KEY,
    chantier_id INTEGER REFERENCES chantiers(id) ON DELETE CASCADE,
    article_nom TEXT NOT NULL,
    quantite INTEGER NOT NULL,
    message TEXT,
    statut TEXT DEFAULT 'en_attente', -- en_attente, approuvee, rejetee
    pointeur_matricule INTEGER REFERENCES users(matricule),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===== RLS POLICIES (SIMPLIFIÉES) =====

-- Politiques pour les entrées
ALTER TABLE entrees ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tous peuvent voir les entrées" ON entrees
    FOR SELECT USING (true);

CREATE POLICY "Tous peuvent créer des entrées" ON entrees
    FOR INSERT WITH CHECK (true);

-- Politiques pour les sorties
ALTER TABLE sorties ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tous peuvent voir les sorties" ON sorties
    FOR SELECT USING (true);

CREATE POLICY "Tous peuvent créer des sorties" ON sorties
    FOR INSERT WITH CHECK (true);

-- Politiques pour les commandes
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tous peuvent voir les commandes" ON commandes
    FOR SELECT USING (true);

CREATE POLICY "Tous peuvent créer des commandes" ON commandes
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Tous peuvent modifier les commandes" ON commandes
    FOR UPDATE USING (true);

-- ===== INDEXES POUR PERFORMANCE =====
CREATE INDEX IF NOT EXISTS idx_entrees_chantier ON entrees(chantier_id);
CREATE INDEX IF NOT EXISTS idx_entrees_pointeur ON entrees(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_entrees_date ON entrees(date_entree);

CREATE INDEX IF NOT EXISTS idx_sorties_chantier ON sorties(chantier_id);
CREATE INDEX IF NOT EXISTS idx_sorties_pointeur ON sorties(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_sorties_date ON sorties(date_sortie);

CREATE INDEX IF NOT EXISTS idx_commandes_chantier ON commandes(chantier_id);
CREATE INDEX IF NOT EXISTS idx_commandes_pointeur ON commandes(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_commandes_statut ON commandes(statut);

-- ===== MESSAGE DE CONFIRMATION =====
SELECT 'Tables créées avec succès!' as message;
