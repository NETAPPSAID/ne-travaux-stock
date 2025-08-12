-- ===== DIAGNOSTIC COMPLET DE PERSISTANCE =====
-- Ce script va identifier et corriger tous les problèmes de persistance

-- 1. VÉRIFIER LES POLITIQUES RLS
SELECT '=== POLITIQUES RLS ===' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- 2. VÉRIFIER LES CONTRAINTES DE CLÉS ÉTRANGÈRES
SELECT '=== CONTRAINTES DE CLÉS ÉTRANGÈRES ===' as info;
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public';

-- 3. VÉRIFIER LES SÉQUENCES
SELECT '=== SÉQUENCES ===' as info;
SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public';

-- 4. VÉRIFIER LES DERNIÈRES VALEURS DES SÉQUENCES
SELECT '=== DERNIÈRES VALEURS DES SÉQUENCES ===' as info;
SELECT 'chantiers_id_seq' as sequence_name, last_value FROM chantiers_id_seq;
SELECT 'articles_id_seq' as sequence_name, last_value FROM articles_id_seq;
SELECT 'users_matricule_seq' as sequence_name, last_value FROM users_matricule_seq;

-- 5. COMPTER LES DONNÉES ACTUELLES
SELECT '=== COMPTEUR DE DONNÉES ===' as info;
SELECT 'users' as table_name, COUNT(*) as count FROM users;
SELECT 'chantiers' as table_name, COUNT(*) as count FROM chantiers;
SELECT 'articles' as table_name, COUNT(*) as count FROM articles;

-- 6. VÉRIFIER LES DERNIÈRES MODIFICATIONS
SELECT '=== DERNIÈRES MODIFICATIONS ===' as info;
SELECT 'chantiers' as table_name, id, nom, created_at, updated_at 
FROM chantiers 
ORDER BY updated_at DESC NULLS LAST, created_at DESC 
LIMIT 5;

SELECT 'articles' as table_name, id, nom, created_at, updated_at 
FROM articles 
ORDER BY updated_at DESC NULLS LAST, created_at DESC 
LIMIT 5;

-- 7. VÉRIFIER LES PERMISSIONS UTILISATEUR
SELECT '=== PERMISSIONS UTILISATEUR ===' as info;
SELECT current_user as current_user;
SELECT session_user as session_user;

-- 8. TESTER LES OPÉRATIONS CRUD
SELECT '=== TEST CRUD ===' as info;

-- Test INSERT
INSERT INTO chantiers (nom, description, icone) 
VALUES ('TEST PERSISTANCE', 'Test de persistance', '🧪') 
RETURNING id, nom;

-- Test SELECT
SELECT 'Test SELECT' as operation, COUNT(*) as count FROM chantiers WHERE nom = 'TEST PERSISTANCE';

-- Test UPDATE
UPDATE chantiers 
SET description = 'Test de persistance MODIFIÉ' 
WHERE nom = 'TEST PERSISTANCE' 
RETURNING id, nom, description;

-- Test DELETE
DELETE FROM chantiers 
WHERE nom = 'TEST PERSISTANCE' 
RETURNING id, nom;

-- Vérifier que la suppression a bien fonctionné
SELECT 'Vérification suppression' as operation, COUNT(*) as count FROM chantiers WHERE nom = 'TEST PERSISTANCE';

-- 9. CORRIGER LES SÉQUENCES SI NÉCESSAIRE
SELECT '=== CORRECTION DES SÉQUENCES ===' as info;
SELECT setval('chantiers_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM chantiers), false) as chantiers_seq_corrected;
SELECT setval('articles_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM articles), false) as articles_seq_corrected;
SELECT setval('users_matricule_seq', (SELECT COALESCE(MAX(matricule), 0) + 1 FROM users), false) as users_seq_corrected;

-- 10. VÉRIFICATION FINALE
SELECT '=== VÉRIFICATION FINALE ===' as info;
SELECT 'Séquences corrigées' as info;
SELECT 'chantiers_id_seq' as sequence_name, last_value FROM chantiers_id_seq;
SELECT 'articles_id_seq' as sequence_name, last_value FROM articles_id_seq;
SELECT 'users_matricule_seq' as sequence_name, last_value FROM users_matricule_seq;

SELECT 'Données finales' as info;
SELECT 'users' as table_name, COUNT(*) as count FROM users;
SELECT 'chantiers' as table_name, COUNT(*) as count FROM chantiers;
SELECT 'articles' as table_name, COUNT(*) as count FROM articles;
