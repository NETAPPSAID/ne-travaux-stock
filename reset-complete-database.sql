-- Script pour nettoyer complètement la base de données NE TRAVAUX
-- Ne garde que l'utilisateur admin

-- Désactiver les contraintes de clés étrangères temporairement
SET session_replication_role = replica;

-- Supprimer toutes les données des tables
DELETE FROM stock_movements;
DELETE FROM commandes;
DELETE FROM articles;
DELETE FROM chantiers;
DELETE FROM users WHERE matricule != 100;

-- Réactiver les contraintes de clés étrangères
SET session_replication_role = DEFAULT;

-- Réinitialiser les séquences
SELECT setval('chantiers_id_seq', 1, false);
SELECT setval('articles_id_seq', 1, false);
SELECT setval('commandes_id_seq', 1, false);
SELECT setval('stock_movements_id_seq', 1, false);

-- Vérifier qu'il ne reste que l'admin
SELECT 'Utilisateurs restants:' as info;
SELECT matricule, nom, role FROM users;

SELECT 'Chantiers restants:' as info;
SELECT * FROM chantiers;

SELECT 'Articles restants:' as info;
SELECT * FROM articles;

SELECT 'Commandes restantes:' as info;
SELECT * FROM commandes;

SELECT 'Mouvements de stock restants:' as info;
SELECT * FROM stock_movements;

