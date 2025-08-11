-- Script de diagnostic pour vérifier l'état des données dans Supabase
-- Exécuter ce script dans l'éditeur SQL de Supabase

-- Vérifier les chantiers actuels
SELECT '=== CHANTIERS ACTUELS ===' as info;
SELECT id, nom, description, icone, created_at, updated_at FROM chantiers ORDER BY id;

-- Vérifier les articles actuels
SELECT '=== ARTICLES ACTUELS ===' as info;
SELECT id, nom, quantite, icone, chantier_id, created_at, updated_at FROM articles ORDER BY id;

-- Vérifier les utilisateurs actuels
SELECT '=== UTILISATEURS ACTUELS ===' as info;
SELECT matricule, nom, role, chantier_id, created_at, updated_at FROM users ORDER BY matricule;

-- Vérifier les séquences
SELECT '=== ÉTAT DES SÉQUENCES ===' as info;
SELECT 
    'chantiers_id_seq' as sequence_name,
    last_value,
    is_called
FROM chantiers_id_seq
UNION ALL
SELECT 
    'articles_id_seq' as sequence_name,
    last_value,
    is_called
FROM articles_id_seq;

-- Vérifier s'il y a des contraintes de clé étrangère qui empêchent la suppression
SELECT '=== CONTRAINTES DE CLÉ ÉTRANGÈRE ===' as info;
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
    AND tc.table_name IN ('articles', 'users', 'stock_movements', 'commandes');
