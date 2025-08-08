-- Configuration de la base de données Supabase pour NE TRAVAUX GESTION DE STOCK

-- ===== CRÉATION DES TABLES =====

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
  matricule INTEGER PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  role VARCHAR(20) DEFAULT 'pointeur',
  chantier_id INTEGER,
  password VARCHAR(255) DEFAULT '123456',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table des chantiers
CREATE TABLE IF NOT EXISTS chantiers (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  icone VARCHAR(10) DEFAULT '🏗️',
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table des articles
CREATE TABLE IF NOT EXISTS articles (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  quantite INTEGER DEFAULT 0,
  icone VARCHAR(10) DEFAULT '🛠️',
  chantier_id INTEGER REFERENCES chantiers(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table des mouvements de stock
CREATE TABLE IF NOT EXISTS stock_movements (
  id SERIAL PRIMARY KEY,
  article_id INTEGER REFERENCES articles(id),
  type VARCHAR(10) NOT NULL CHECK (type IN ('entree', 'sortie')),
  quantite INTEGER NOT NULL,
  user_matricule INTEGER REFERENCES users(matricule),
  chantier_id INTEGER REFERENCES chantiers(id),
  notes TEXT,
  uploaded_files TEXT[], -- URLs des fichiers uploadés
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table des commandes
CREATE TABLE IF NOT EXISTS commandes (
  id SERIAL PRIMARY KEY,
  article_id INTEGER REFERENCES articles(id),
  quantite INTEGER NOT NULL,
  user_matricule INTEGER REFERENCES users(matricule),
  chantier_id INTEGER REFERENCES chantiers(id),
  notes TEXT,
  statut VARCHAR(20) DEFAULT 'en_attente',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table des fichiers uploadés
CREATE TABLE IF NOT EXISTS uploaded_files (
  id SERIAL PRIMARY KEY,
  filename VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size INTEGER,
  file_type VARCHAR(100),
  user_matricule INTEGER REFERENCES users(matricule),
  movement_id INTEGER REFERENCES stock_movements(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- ===== DONNÉES INITIALES =====

-- Insérer les chantiers par défaut
INSERT INTO chantiers (id, nom, icone, description) VALUES
(1, 'Chantier A', '🏗️', 'Chantier principal'),
(2, 'Chantier B', '🏢', 'Chantier secondaire'),
(3, 'Chantier C', '🏠', 'Chantier résidentiel'),
(4, 'Chantier D', '🏭', 'Chantier industriel'),
(5, 'Chantier E', '🌉', 'Chantier infrastructure')
ON CONFLICT (id) DO NOTHING;

-- Insérer les utilisateurs par défaut
INSERT INTO users (matricule, nom, role, chantier_id, password) VALUES
(100, 'Said El Khalfaoui', 'admin', NULL, 'admin123'),
(200, 'Pointeur 1', 'pointeur', 1, 'pointeur123'),
(300, 'Pointeur 2', 'pointeur', 2, 'pointeur123'),
(400, 'Pointeur 3', 'pointeur', 3, 'pointeur123'),
(500, 'Pointeur 4', 'pointeur', 4, 'pointeur123'),
(600, 'Pointeur 5', 'pointeur', 5, 'pointeur123')
ON CONFLICT (matricule) DO NOTHING;

-- Insérer les articles par défaut
INSERT INTO articles (nom, quantite, icone, chantier_id) VALUES
('Ciment', 100, '🛠️', 1),
('Sable', 500, '🏖️', 1),
('Briques', 1000, '🧱', 1),
('Ciment', 80, '🛠️', 2),
('Sable', 400, '🏖️', 2),
('Briques', 800, '🧱', 2),
('Ciment', 120, '🛠️', 3),
('Sable', 600, '🏖️', 3),
('Briques', 1200, '🧱', 3),
('Ciment', 90, '🛠️', 4),
('Sable', 450, '🏖️', 4),
('Briques', 900, '🧱', 4),
('Ciment', 110, '🛠️', 5),
('Sable', 550, '🏖️', 5),
('Briques', 1100, '🧱', 5)
ON CONFLICT DO NOTHING;

-- ===== POLITIQUES DE SÉCURITÉ (RLS) =====

-- Activer RLS sur toutes les tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- Politiques pour les utilisateurs
CREATE POLICY "Users are viewable by everyone" ON users
FOR SELECT USING (true);

CREATE POLICY "Users can be updated by admin" ON users
FOR UPDATE USING (auth.jwt() ->> 'matricule' = '100');

CREATE POLICY "Users can be inserted by admin" ON users
FOR INSERT WITH CHECK (auth.jwt() ->> 'matricule' = '100');

CREATE POLICY "Users can be deleted by admin" ON users
FOR DELETE USING (auth.jwt() ->> 'matricule' = '100');

-- Politiques pour les chantiers
CREATE POLICY "Chantiers are viewable by everyone" ON chantiers
FOR SELECT USING (true);

CREATE POLICY "Chantiers can be modified by admin" ON chantiers
FOR ALL USING (auth.jwt() ->> 'matricule' = '100');

-- Politiques pour les articles
CREATE POLICY "Articles are viewable by everyone" ON articles
FOR SELECT USING (true);

CREATE POLICY "Articles can be modified by admin" ON articles
FOR ALL USING (auth.jwt() ->> 'matricule' = '100');

-- Politiques pour les mouvements de stock
CREATE POLICY "Stock movements are viewable by everyone" ON stock_movements
FOR SELECT USING (true);

CREATE POLICY "Stock movements can be created by authenticated users" ON stock_movements
FOR INSERT WITH CHECK (auth.jwt() ->> 'matricule' IS NOT NULL);

-- Politiques pour les commandes
CREATE POLICY "Commandes are viewable by everyone" ON commandes
FOR SELECT USING (true);

CREATE POLICY "Commandes can be created by authenticated users" ON commandes
FOR INSERT WITH CHECK (auth.jwt() ->> 'matricule' IS NOT NULL);

-- Politiques pour les fichiers uploadés
CREATE POLICY "Uploaded files are viewable by everyone" ON uploaded_files
FOR SELECT USING (true);

CREATE POLICY "Uploaded files can be created by authenticated users" ON uploaded_files
FOR INSERT WITH CHECK (auth.jwt() ->> 'matricule' IS NOT NULL);

-- ===== FONCTIONS UTILES =====

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chantiers_updated_at BEFORE UPDATE ON chantiers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===== VUES UTILES =====

-- Vue pour le stock par chantier
CREATE OR REPLACE VIEW stock_by_chantier AS
SELECT 
    c.id as chantier_id,
    c.nom as chantier_nom,
    c.icone as chantier_icone,
    a.id as article_id,
    a.nom as article_nom,
    a.icone as article_icone,
    a.quantite,
    u.nom as responsable
FROM chantiers c
JOIN articles a ON c.id = a.chantier_id
JOIN users u ON c.id = u.chantier_id
WHERE u.role = 'pointeur';

-- Vue pour l'historique des mouvements
CREATE OR REPLACE VIEW mouvement_history AS
SELECT 
    sm.id,
    sm.type,
    sm.quantite,
    sm.notes,
    sm.created_at,
    a.nom as article_nom,
    a.icone as article_icone,
    u.nom as user_nom,
    c.nom as chantier_nom,
    sm.uploaded_files
FROM stock_movements sm
JOIN articles a ON sm.article_id = a.id
JOIN users u ON sm.user_matricule = u.matricule
JOIN chantiers c ON sm.chantier_id = c.id
ORDER BY sm.created_at DESC;

-- ===== INDEX POUR LES PERFORMANCES =====

CREATE INDEX IF NOT EXISTS idx_stock_movements_article_id ON stock_movements(article_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_user_matricule ON stock_movements(user_matricule);
CREATE INDEX IF NOT EXISTS idx_stock_movements_chantier_id ON stock_movements(chantier_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_created_at ON stock_movements(created_at);

CREATE INDEX IF NOT EXISTS idx_commandes_article_id ON commandes(article_id);
CREATE INDEX IF NOT EXISTS idx_commandes_user_matricule ON commandes(user_matricule);
CREATE INDEX IF NOT EXISTS idx_commandes_chantier_id ON commandes(chantier_id);

CREATE INDEX IF NOT EXISTS idx_articles_chantier_id ON articles(chantier_id);
CREATE INDEX IF NOT EXISTS idx_users_chantier_id ON users(chantier_id);