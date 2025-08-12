-- ===== DÉSACTIVATION COMPLÈTE DE LA SYNCHRONISATION TEMPS RÉEL =====

-- 1. Vérifier les canaux de synchronisation temps réel actifs
SELECT '=== CANAUX TEMPS RÉEL ACTIFS ===' as info;
SELECT * FROM pg_stat_activity WHERE application_name LIKE '%supabase%' OR query LIKE '%LISTEN%';

-- 2. Désactiver les triggers de synchronisation temps réel
SELECT '=== DÉSACTIVATION DES TRIGGERS ===' as info;

-- 3. Vérifier les politiques RLS qui pourraient causer des problèmes
SELECT '=== POLITIQUES RLS ===' as info;
SELECT tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- 4. Test de suppression directe
SELECT '=== TEST SUPPRESSION DIRECTE ===' as info;
DELETE FROM chantiers WHERE nom = 'agad' RETURNING id, nom;

-- 5. Vérifier les données restantes
SELECT '=== DONNÉES RESTANTES ===' as info;
SELECT 'chantiers' as table, COUNT(*) as count FROM chantiers;
SELECT 'articles' as table, COUNT(*) as count FROM articles;
