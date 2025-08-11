-- Script pour tester les permissions et l'accès aux données
-- Exécuter ce script dans l'éditeur SQL de Supabase

-- 1. Vérifier les politiques RLS actuelles
SELECT '=== POLITIQUES RLS ACTUELLES ===' as info;

SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- 2. Vérifier les données avec l'utilisateur anon (comme l'application)
SELECT '=== DONNEES ACCESSIBLES EN TANT QUUTILISATEUR ANON ===' as info;

-- Tester l'accès aux chantiers
SELECT 'Chantiers accessibles:' as info;
SELECT * FROM chantiers;

-- Tester l'accès aux articles
SELECT 'Articles accessibles:' as info;
SELECT * FROM articles;

-- Tester l'accès aux utilisateurs
SELECT 'Utilisateurs accessibles:' as info;
SELECT * FROM users;

-- 3. Vérifier si les politiques RLS sont trop restrictives
SELECT '=== TEST DES POLITIQUES ===' as info;

-- Désactiver temporairement RLS pour tester
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers DISABLE ROW LEVEL SECURITY;
ALTER TABLE articles DISABLE ROW LEVEL SECURITY;

SELECT 'Après désactivation RLS - Chantiers:' as info;
SELECT * FROM chantiers;

SELECT 'Après désactivation RLS - Articles:' as info;
SELECT * FROM articles;

SELECT 'Après désactivation RLS - Utilisateurs:' as info;
SELECT * FROM users;

-- Réactiver RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- 4. Créer des politiques plus permissives pour tester
SELECT '=== CREATION DE POLITIQUES PERMISSIVES ===' as info;

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Users are viewable by everyone" ON users;
DROP POLICY IF EXISTS "Chantiers are viewable by everyone" ON chantiers;
DROP POLICY IF EXISTS "Articles are viewable by everyone" ON articles;

-- Créer des politiques très permissives pour tester
CREATE POLICY "Allow all operations on users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on chantiers" ON chantiers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on articles" ON articles FOR ALL USING (true) WITH CHECK (true);

SELECT 'Après nouvelles politiques - Chantiers:' as info;
SELECT * FROM chantiers;

SELECT 'Après nouvelles politiques - Articles:' as info;
SELECT * FROM articles;

SELECT 'Après nouvelles politiques - Utilisateurs:' as info;
SELECT * FROM users;
