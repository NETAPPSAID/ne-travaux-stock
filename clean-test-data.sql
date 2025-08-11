-- Script pour nettoyer les données de test et permettre l'utilisation des nouvelles données
-- Exécuter ce script dans l'éditeur SQL de Supabase

-- Supprimer les articles de test (d'abord car ils référencent les chantiers)
DELETE FROM articles WHERE chantier_id IN (1, 2, 3, 4, 5);

-- Supprimer les utilisateurs pointeurs de test (sauf l'admin)
DELETE FROM users WHERE matricule IN (200, 300, 400, 500, 600);

-- Supprimer les chantiers de test
DELETE FROM chantiers WHERE id IN (1, 2, 3, 4, 5);

-- Réinitialiser les séquences pour éviter les conflits d'ID
-- Si les tables sont vides, on remet les séquences à 1
SELECT setval('chantiers_id_seq', GREATEST(COALESCE((SELECT MAX(id) FROM chantiers), 0), 1), true);
SELECT setval('articles_id_seq', GREATEST(COALESCE((SELECT MAX(id) FROM articles), 0), 1), true);

-- Vérifier les données restantes
SELECT 'Chantiers restants:' as info;
SELECT * FROM chantiers;

SELECT 'Articles restants:' as info;
SELECT * FROM articles;

SELECT 'Utilisateurs restants:' as info;
SELECT * FROM users;
