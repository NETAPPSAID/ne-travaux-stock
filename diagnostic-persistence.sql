-- Script de diagnostic pour identifier les problèmes de persistance
-- Exécute ce script dans l'éditeur SQL de Supabase

-- 1. VÉRIFICATION DES POLITIQUES RLS
SELECT '=== POLITIQUES RLS ACTIVES ===' as info;

SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- 2. VÉRIFICATION DES CONTRAINTES DE CLÉS ÉTRANGÈRES
SELECT '=== CONTRAINTES DE CLÉS ÉTRANGÈRES ===' as info;

SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- 3. VÉRIFICATION DES SÉQUENCES
SELECT '=== ÉTAT DES SÉQUENCES ===' as info;

SELECT 
    sequence_name,
    last_value,
    start_value,
    increment_by,
    max_value,
    min_value,
    cache_value,
    is_cycled
FROM information_schema.sequences 
WHERE sequence_schema = 'public'
ORDER BY sequence_name;

-- 4. VÉRIFICATION DES TRIGGERS
SELECT '=== TRIGGERS ACTIFS ===' as info;

SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement,
    action_timing
FROM information_schema.triggers 
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- 5. COMPTAGE DES DONNÉES ACTUELLES
SELECT '=== COMPTAGE DES DONNÉES ===' as info;

SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'chantiers' as table_name, COUNT(*) as count FROM chantiers
UNION ALL
SELECT 'articles' as table_name, COUNT(*) as count FROM articles
UNION ALL
SELECT 'commandes' as table_name, COUNT(*) as count FROM commandes
UNION ALL
SELECT 'stock_movements' as table_name, COUNT(*) as count FROM stock_movements
UNION ALL
SELECT 'uploaded_files' as table_name, COUNT(*) as count FROM uploaded_files;

-- 6. VÉRIFICATION DES DERNIÈRES MODIFICATIONS
SELECT '=== DERNIÈRES MODIFICATIONS ===' as info;

SELECT 'Derniers chantiers modifiés:' as info;
SELECT id, nom, updated_at FROM chantiers ORDER BY updated_at DESC LIMIT 5;

SELECT 'Derniers articles modifiés:' as info;
SELECT id, nom, updated_at FROM articles ORDER BY updated_at DESC LIMIT 5;

SELECT 'Dernières commandes modifiées:' as info;
SELECT id, created_at FROM commandes ORDER BY created_at DESC LIMIT 5;

-- 7. VÉRIFICATION DES PERMISSIONS
SELECT '=== PERMISSIONS UTILISATEUR ANON ===' as info;

SELECT 
    table_name,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges 
WHERE grantee = 'anon' 
    AND table_schema = 'public'
ORDER BY table_name, privilege_type;

-- 8. VÉRIFICATION DES RÈGLES DE RÉPLICATION
SELECT '=== RÈGLES DE RÉPLICATION ===' as info;

SELECT 
    schemaname,
    tablename,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'chantiers', 'articles', 'commandes', 'stock_movements', 'uploaded_files')
ORDER BY tablename;
