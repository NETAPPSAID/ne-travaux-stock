-- ===== TEST DE PERSISTANCE DES SUPPRESSIONS =====

-- 1. Voir les données actuelles
SELECT '=== DONNÉES ACTUELLES ===' as info;
SELECT 'chantiers' as table, id, nom FROM chantiers ORDER BY id;
SELECT 'articles' as table, id, nom FROM articles ORDER BY id;

-- 2. Créer un chantier de test
SELECT '=== CRÉATION CHANTIER DE TEST ===' as info;
INSERT INTO chantiers (nom, description, icone) 
VALUES ('TEST SUPPRESSION', 'Test de suppression', '🧪') 
RETURNING id, nom;

-- 3. Vérifier que le chantier a été créé
SELECT '=== VÉRIFICATION CRÉATION ===' as info;
SELECT id, nom FROM chantiers WHERE nom = 'TEST SUPPRESSION';

-- 4. Supprimer le chantier de test
SELECT '=== SUPPRESSION DU CHANTIER ===' as info;
DELETE FROM chantiers WHERE nom = 'TEST SUPPRESSION' RETURNING id, nom;

-- 5. Vérifier que la suppression a fonctionné
SELECT '=== VÉRIFICATION SUPPRESSION ===' as info;
SELECT COUNT(*) as count FROM chantiers WHERE nom = 'TEST SUPPRESSION';

-- 6. Voir les données finales
SELECT '=== DONNÉES FINALES ===' as info;
SELECT 'chantiers' as table, id, nom FROM chantiers ORDER BY id;
SELECT 'articles' as table, id, nom FROM articles ORDER BY id;
