-- Script de vérification des tables
-- À exécuter dans Supabase SQL Editor

-- Vérifier si les tables existent
SELECT '=== TABLES EXISTANTES ===' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('entrees', 'sorties', 'commandes')
ORDER BY table_name;

-- Vérifier la structure de la table entrees si elle existe
SELECT '=== STRUCTURE TABLE ENTRÉES ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'entrees' 
ORDER BY ordinal_position;

-- Vérifier la structure de la table sorties si elle existe
SELECT '=== STRUCTURE TABLE SORTIES ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sorties' 
ORDER BY ordinal_position;

-- Vérifier la structure de la table commandes si elle existe
SELECT '=== STRUCTURE TABLE COMMANDES ===' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'commandes' 
ORDER BY ordinal_position;
