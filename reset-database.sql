-- Script pour RESET COMPLET de la base de données
-- ATTENTION : Ce script va supprimer TOUTES les données existantes
-- Exécuter ce script dans l'éditeur SQL de Supabase

-- 1. Désactiver RLS temporairement
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers DISABLE ROW LEVEL SECURITY;
ALTER TABLE articles DISABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements DISABLE ROW LEVEL SECURITY;
ALTER TABLE commandes DISABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files DISABLE ROW LEVEL SECURITY;

-- 2. Supprimer toutes les données dans l'ordre (respecter les contraintes)
DELETE FROM stock_movements;
DELETE FROM commandes;
DELETE FROM articles;
DELETE FROM users;
DELETE FROM chantiers;
DELETE FROM uploaded_files;

-- 3. Supprimer les tables existantes
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS commandes CASCADE;
DROP TABLE IF EXISTS articles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS chantiers CASCADE;
DROP TABLE IF EXISTS uploaded_files CASCADE;

-- 4. Supprimer les vues
DROP VIEW IF EXISTS stock_by_chantier CASCADE;
DROP VIEW IF EXISTS mouvement_history CASCADE;

-- 5. Supprimer les fonctions
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- 6. Recréer les tables proprement
CREATE TABLE users (
    matricule INTEGER PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'pointeur',
    chantier_id INTEGER,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE chantiers (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    icone VARCHAR(10) DEFAULT '🏗️',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    quantite INTEGER NOT NULL DEFAULT 0,
    icone VARCHAR(10) DEFAULT '📦',
    chantier_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (chantier_id) REFERENCES chantiers(id) ON DELETE CASCADE
);

CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('entree', 'sortie')),
    quantite INTEGER NOT NULL,
    user_matricule INTEGER NOT NULL,
    chantier_id INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_matricule) REFERENCES users(matricule) ON DELETE CASCADE,
    FOREIGN KEY (chantier_id) REFERENCES chantiers(id) ON DELETE CASCADE
);

CREATE TABLE commandes (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    quantite INTEGER NOT NULL,
    user_matricule INTEGER NOT NULL,
    chantier_id INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_matricule) REFERENCES users(matricule) ON DELETE CASCADE,
    FOREIGN KEY (chantier_id) REFERENCES chantiers(id) ON DELETE CASCADE
);

CREATE TABLE uploaded_files (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100),
    file_size INTEGER,
    movement_id INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (movement_id) REFERENCES stock_movements(id) ON DELETE CASCADE
);

-- 7. Créer les index
CREATE INDEX idx_stock_movements_article_id ON stock_movements(article_id);
CREATE INDEX idx_stock_movements_user_matricule ON stock_movements(user_matricule);
CREATE INDEX idx_stock_movements_chantier_id ON stock_movements(chantier_id);
CREATE INDEX idx_stock_movements_created_at ON stock_movements(created_at);
CREATE INDEX idx_commandes_article_id ON commandes(article_id);
CREATE INDEX idx_commandes_user_matricule ON commandes(user_matricule);
CREATE INDEX idx_commandes_chantier_id ON commandes(chantier_id);
CREATE INDEX idx_articles_chantier_id ON articles(chantier_id);
CREATE INDEX idx_users_chantier_id ON users(chantier_id);

-- 8. Créer la fonction pour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 9. Créer les triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chantiers_updated_at BEFORE UPDATE ON chantiers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 10. Créer les vues
CREATE OR REPLACE VIEW stock_by_chantier AS
SELECT 
    c.id as chantier_id,
    c.nom as chantier_nom,
    c.icone as chantier_icone,
    a.id as article_id,
    a.nom as article_nom,
    a.icone as article_icone,
    a.quantite as stock_actuel,
    COALESCE(SUM(CASE WHEN sm.type = 'entree' THEN sm.quantite ELSE 0 END), 0) as total_entrees,
    COALESCE(SUM(CASE WHEN sm.type = 'sortie' THEN sm.quantite ELSE 0 END), 0) as total_sorties
FROM chantiers c
LEFT JOIN articles a ON c.id = a.chantier_id
LEFT JOIN stock_movements sm ON a.id = sm.article_id
GROUP BY c.id, c.nom, c.icone, a.id, a.nom, a.icone, a.quantite
ORDER BY c.id, a.nom;

CREATE OR REPLACE VIEW mouvement_history AS
SELECT 
    sm.id,
    sm.created_at as date,
    sm.type,
    a.id as article_id,
    a.nom as article_nom,
    a.icone as article_icone,
    sm.quantite,
    u.matricule as user_matricule,
    u.nom as user_nom,
    c.id as chantier_id,
    c.nom as chantier_nom,
    sm.notes
FROM stock_movements sm
JOIN articles a ON sm.article_id = a.id
JOIN users u ON sm.user_matricule = u.matricule
JOIN chantiers c ON sm.chantier_id = c.id
ORDER BY sm.created_at DESC;

-- 11. Insérer SEULEMENT l'admin
INSERT INTO users (matricule, nom, role, chantier_id, password) VALUES
(100, 'Said El Khalfaoui', 'admin', NULL, 'admin123');

-- 12. Réactiver RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- 13. Créer les politiques RLS
CREATE POLICY "Users are viewable by everyone" ON users FOR SELECT USING (true);
CREATE POLICY "Users can be updated by admin" ON users FOR UPDATE USING (true);
CREATE POLICY "Users can be inserted by admin" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can be deleted by admin" ON users FOR DELETE USING (true);

CREATE POLICY "Chantiers are viewable by everyone" ON chantiers FOR SELECT USING (true);
CREATE POLICY "Chantiers can be modified by admin" ON chantiers FOR ALL USING (true);

CREATE POLICY "Articles are viewable by everyone" ON articles FOR SELECT USING (true);
CREATE POLICY "Articles can be modified by admin" ON articles FOR ALL USING (true);

CREATE POLICY "Stock movements are viewable by everyone" ON stock_movements FOR SELECT USING (true);
CREATE POLICY "Stock movements can be created by authenticated users" ON stock_movements FOR INSERT WITH CHECK (true);

CREATE POLICY "Commandes are viewable by everyone" ON commandes FOR SELECT USING (true);
CREATE POLICY "Commandes can be created by authenticated users" ON commandes FOR INSERT WITH CHECK (true);

CREATE POLICY "Uploaded files are viewable by everyone" ON uploaded_files FOR SELECT USING (true);
CREATE POLICY "Uploaded files can be created by authenticated users" ON uploaded_files FOR INSERT WITH CHECK (true);

-- 14. Vérifier le résultat
SELECT '=== BASE DE DONNÉES RÉINITIALISÉE ===' as info;

SELECT 'Utilisateurs:' as info;
SELECT * FROM users;

SELECT 'Chantiers:' as info;
SELECT * FROM chantiers;

SELECT 'Articles:' as info;
SELECT * FROM articles;
