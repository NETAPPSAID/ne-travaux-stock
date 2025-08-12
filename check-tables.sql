-- Script de diagnostic pour vérifier la structure des tables existantes
-- À exécuter dans Supabase SQL Editor

-- Vérifier la structure de la table users
SELECT '=== TABLE USERS ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- Vérifier la structure de la table articles
SELECT '=== TABLE ARTICLES ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'articles' 
ORDER BY ordinal_position;

-- Vérifier la structure de la table chantiers
SELECT '=== TABLE CHANTIERS ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'chantiers' 
ORDER BY ordinal_position;

-- Vérifier les clés primaires
SELECT '=== CLÉS PRIMAIRES ===' as info;
SELECT 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_name IN ('users', 'articles', 'chantiers')
ORDER BY tc.table_name;
