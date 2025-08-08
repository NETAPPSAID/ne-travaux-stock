-- Script pour vérifier et corriger les RLS Policies
-- Exécute ce script dans l'éditeur SQL de Supabase

-- 1. Vérifier les policies existantes
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- 2. Supprimer toutes les policies existantes (optionnel - décommente si nécessaire)
-- DROP POLICY IF EXISTS "Enable all access" ON chantiers;
-- DROP POLICY IF EXISTS "Enable all access" ON users;
-- DROP POLICY IF EXISTS "Enable all access" ON articles;
-- DROP POLICY IF EXISTS "Enable all access" ON commandes;
-- DROP POLICY IF EXISTS "Enable all access" ON stock_movements;
-- DROP POLICY IF EXISTS "Enable all access" ON uploaded_files;

-- 3. Activer RLS sur toutes les tables
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- 4. Créer les policies pour permettre l'accès complet
-- Table chantiers
CREATE POLICY "Enable all access" ON chantiers
    FOR ALL USING (true) WITH CHECK (true);

-- Table users
CREATE POLICY "Enable all access" ON users
    FOR ALL USING (true) WITH CHECK (true);

-- Table articles
CREATE POLICY "Enable all access" ON articles
    FOR ALL USING (true) WITH CHECK (true);

-- Table commandes
CREATE POLICY "Enable all access" ON commandes
    FOR ALL USING (true) WITH CHECK (true);

-- Table stock_movements
CREATE POLICY "Enable all access" ON stock_movements
    FOR ALL USING (true) WITH CHECK (true);

-- Table uploaded_files
CREATE POLICY "Enable all access" ON uploaded_files
    FOR ALL USING (true) WITH CHECK (true);

-- 5. Vérifier que les policies ont été créées
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
