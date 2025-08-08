-- Script simple pour corriger les RLS Policies dans Supabase
-- Exécute ce script dans l'éditeur SQL de Supabase

-- 1. Désactiver RLS sur toutes les tables
ALTER TABLE chantiers DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE articles DISABLE ROW LEVEL SECURITY;
ALTER TABLE commandes DISABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements DISABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files DISABLE ROW LEVEL SECURITY;

-- 2. Supprimer toutes les policies existantes
DROP POLICY IF EXISTS "Enable all access" ON chantiers;
DROP POLICY IF EXISTS "Enable all access" ON users;
DROP POLICY IF EXISTS "Enable all access" ON articles;
DROP POLICY IF EXISTS "Enable all access" ON commandes;
DROP POLICY IF EXISTS "Enable all access" ON stock_movements;
DROP POLICY IF EXISTS "Enable all access" ON uploaded_files;

-- 3. Réactiver RLS
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- 4. Créer les policies simples
CREATE POLICY "Enable all access" ON chantiers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON articles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON commandes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON stock_movements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access" ON uploaded_files FOR ALL USING (true) WITH CHECK (true);

-- 5. Message de confirmation
SELECT 'Politiques RLS corrigées avec succès!' as message;

-- Correction de la séquence pour les chantiers après insertion des données initiales
SELECT setval('chantiers_id_seq', (SELECT MAX(id) FROM chantiers), true);

-- Correction de la séquence pour les articles après insertion des données initiales  
SELECT setval('articles_id_seq', (SELECT MAX(id) FROM articles), true);

-- Correction de la séquence pour les utilisateurs après insertion des données initiales
SELECT setval('users_matricule_seq', (SELECT MAX(matricule) FROM users), true);
