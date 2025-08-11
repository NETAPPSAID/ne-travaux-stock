-- Script pour nettoyer TOUTES les données de test en respectant les contraintes
-- Exécuter ce script dans l'éditeur SQL de Supabase

-- 1. Supprimer d'abord les mouvements de stock (ils référencent articles, chantiers et users)
DELETE FROM stock_movements;

-- 2. Supprimer les commandes (elles référencent articles, chantiers et users)
DELETE FROM commandes;

-- 3. Supprimer les articles (ils référencent chantiers)
DELETE FROM articles;

-- 4. Supprimer les utilisateurs pointeurs de test (sauf l'admin)
DELETE FROM users WHERE matricule IN (200, 300, 400, 500, 600);

-- 5. Supprimer les chantiers de test
DELETE FROM chantiers WHERE id IN (1, 2, 3, 4, 5);

-- 6. Réinitialiser les séquences
SELECT setval('chantiers_id_seq', GREATEST(COALESCE((SELECT MAX(id) FROM chantiers), 0), 1), true);
SELECT setval('articles_id_seq', GREATEST(COALESCE((SELECT MAX(id) FROM articles), 0), 1), true);

-- 7. Vérifier le résultat
SELECT '=== RÉSULTAT APRÈS NETTOYAGE ===' as info;

SELECT 'Chantiers restants:' as info;
SELECT * FROM chantiers;

SELECT 'Articles restants:' as info;
SELECT * FROM articles;

SELECT 'Utilisateurs restants:' as info;
SELECT * FROM users;

SELECT 'Mouvements de stock restants:' as info;
SELECT * FROM stock_movements;

SELECT 'Commandes restantes:' as info;
SELECT * FROM commandes;
