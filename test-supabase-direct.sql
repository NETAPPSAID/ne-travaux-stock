-- TEST DIRECT SUPABASE - VÉRIFICATION DES DONNÉES
-- À exécuter dans Supabase SQL Editor

-- 1. VÉRIFIER LES DONNÉES ACTUELLES
SELECT '=== DONNÉES ACTUELLES ===' as info;
SELECT 'Chantiers:' as table_name, COUNT(*) as count FROM chantiers;
SELECT 'Articles:' as table_name, COUNT(*) as count FROM articles;

-- 2. AFFICHER LES DONNÉES
SELECT '=== CHANTIERS ===' as info;
SELECT id, nom, description, created_at FROM chantiers ORDER BY id;

SELECT '=== ARTICLES ===' as info;
SELECT id, nom, quantite, chantier_id, created_at FROM articles ORDER BY id;

-- 3. VÉRIFIER LES TRIGGERS
SELECT '=== TRIGGERS ACTIFS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table IN ('chantiers', 'articles');

-- 4. VÉRIFIER LES RLS POLICIES
SELECT '=== RLS POLICIES ===' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('chantiers', 'articles');

-- 5. TEST DE SUPPRESSION DIRECTE
SELECT '=== TEST SUPPRESSION DIRECTE ===' as info;
-- Créer un chantier de test
INSERT INTO chantiers (nom, description, icone) 
VALUES ('TEST SUPPRESSION DIRECTE', 'Test pour vérifier la persistance', '🧪')
ON CONFLICT DO NOTHING;

-- Vérifier qu'il est créé
SELECT 'Chantier de test créé:' as info, id, nom FROM chantiers WHERE nom = 'TEST SUPPRESSION DIRECTE';

-- Le supprimer
DELETE FROM chantiers WHERE nom = 'TEST SUPPRESSION DIRECTE';

-- Vérifier qu'il est supprimé
SELECT 'Chantier de test supprimé:' as info, COUNT(*) as count FROM chantiers WHERE nom = 'TEST SUPPRESSION DIRECTE';

-- 6. VÉRIFIER LES SÉQUENCES (SIMPLIFIÉ)
SELECT '=== SÉQUENCES ===' as info;
SELECT 
    sequence_name,
    start_value,
    minimum_value,
    maximum_value,
    increment
FROM information_schema.sequences 
WHERE sequence_name LIKE '%chantier%' OR sequence_name LIKE '%article%';

-- 7. VÉRIFIER LES VALEURS MAX DES IDS
SELECT '=== VALEURS MAX DES IDS ===' as info;
SELECT 'chantiers' as table_name, COALESCE(MAX(id), 0) as max_id FROM chantiers;
SELECT 'articles' as table_name, COALESCE(MAX(id), 0) as max_id FROM articles;
