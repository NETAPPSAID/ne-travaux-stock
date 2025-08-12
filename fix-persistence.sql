-- ===== CORRECTION DES PROBLÈMES DE PERSISTANCE =====

-- 1. Vérifier les politiques RLS
SELECT '=== POLITIQUES RLS ===' as info;
SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public';

-- 2. Corriger les séquences (seulement celles qui existent)
SELECT '=== CORRECTION DES SÉQUENCES ===' as info;
SELECT setval('chantiers_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM chantiers), false);
SELECT setval('articles_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM articles), false);

-- 3. Vérifier les données actuelles
SELECT '=== DONNÉES ACTUELLES ===' as info;
SELECT 'chantiers' as table, COUNT(*) as count FROM chantiers;
SELECT 'articles' as table, COUNT(*) as count FROM articles;

-- 4. Test de suppression
SELECT '=== TEST DE SUPPRESSION ===' as info;
DELETE FROM articles WHERE nom LIKE '%TEST%';
DELETE FROM chantiers WHERE nom LIKE '%TEST%';
