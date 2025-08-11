-- Script de nettoyage COMPLET et ROBUSTE pour NE TRAVAUX
-- Ce script va supprimer TOUTES les données et réinitialiser complètement la base

-- 1. DÉSACTIVER RLS TEMPORAIREMENT pour permettre les suppressions
ALTER TABLE stock_movements DISABLE ROW LEVEL SECURITY;
ALTER TABLE commandes DISABLE ROW LEVEL SECURITY;
ALTER TABLE articles DISABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files DISABLE ROW LEVEL SECURITY;

-- 2. DÉSACTIVER LES CONTRAINTES DE CLÉS ÉTRANGÈRES
SET session_replication_role = replica;

-- 3. SUPPRIMER TOUTES LES DONNÉES (ordre important pour éviter les conflits)
-- Commencer par les tables dépendantes
DELETE FROM stock_movements;
DELETE FROM commandes;
DELETE FROM articles;
DELETE FROM chantiers;
DELETE FROM uploaded_files;

-- Supprimer tous les utilisateurs sauf l'admin (matricule 100)
DELETE FROM users WHERE matricule != 100;

-- 4. RÉACTIVER LES CONTRAINTES
SET session_replication_role = DEFAULT;

-- 5. RÉINITIALISER TOUTES LES SÉQUENCES À 1
-- Forcer la réinitialisation même si les tables sont vides
SELECT setval('stock_movements_id_seq', 1, false);
SELECT setval('commandes_id_seq', 1, false);
SELECT setval('articles_id_seq', 1, false);
SELECT setval('chantiers_id_seq', 1, false);
SELECT setval('uploaded_files_id_seq', 1, false);

-- 6. RÉACTIVER RLS
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- 7. VÉRIFICATION COMPLÈTE
SELECT '=== VÉRIFICATION APRÈS NETTOYAGE ===' as info;

SELECT 'Utilisateurs restants:' as info;
SELECT matricule, nom, role FROM users;

SELECT 'Chantiers restants:' as info;
SELECT COUNT(*) as nombre_chantiers FROM chantiers;

SELECT 'Articles restants:' as info;
SELECT COUNT(*) as nombre_articles FROM articles;

SELECT 'Commandes restantes:' as info;
SELECT COUNT(*) as nombre_commandes FROM commandes;

SELECT 'Mouvements de stock restants:' as info;
SELECT COUNT(*) as nombre_mouvements FROM stock_movements;

SELECT 'Fichiers uploadés restants:' as info;
SELECT COUNT(*) as nombre_fichiers FROM uploaded_files;

-- 8. VÉRIFICATION DES SÉQUENCES
SELECT '=== ÉTAT DES SÉQUENCES ===' as info;
SELECT 'chantiers_id_seq' as sequence, last_value FROM chantiers_id_seq;
SELECT 'articles_id_seq' as sequence, last_value FROM articles_id_seq;
SELECT 'commandes_id_seq' as sequence, last_value FROM commandes_id_seq;
SELECT 'stock_movements_id_seq' as sequence, last_value FROM stock_movements_id_seq;

SELECT '=== NETTOYAGE TERMINÉ AVEC SUCCÈS ===' as message;
