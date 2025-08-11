-- Script de nettoyage COMPLET et ROBUSTE pour NE TRAVAUX
-- Ce script va supprimer TOUTES les données et réinitialiser complètement la base
-- TENANT COMPTE DES TRIGGERS DÉTECTÉS

-- 1. DÉSACTIVER TOUS LES TRIGGERS TEMPORAIREMENT
SELECT '=== DÉSACTIVATION DES TRIGGERS ===' as info;

-- Désactiver les triggers sur toutes les tables
ALTER TABLE stock_movements DISABLE TRIGGER ALL;
ALTER TABLE commandes DISABLE TRIGGER ALL;
ALTER TABLE articles DISABLE TRIGGER ALL;
ALTER TABLE chantiers DISABLE TRIGGER ALL;
ALTER TABLE users DISABLE TRIGGER ALL;
ALTER TABLE uploaded_files DISABLE TRIGGER ALL;

-- 2. DÉSACTIVER RLS TEMPORAIREMENT pour permettre les suppressions
SELECT '=== DÉSACTIVATION RLS ===' as info;

ALTER TABLE stock_movements DISABLE ROW LEVEL SECURITY;
ALTER TABLE commandes DISABLE ROW LEVEL SECURITY;
ALTER TABLE articles DISABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files DISABLE ROW LEVEL SECURITY;

-- 3. DÉSACTIVER LES CONTRAINTES DE CLÉS ÉTRANGÈRES
SELECT '=== DÉSACTIVATION CONTRAINTES ===' as info;

SET session_replication_role = replica;

-- 4. SUPPRIMER TOUTES LES DONNÉES (ordre important pour éviter les conflits)
SELECT '=== SUPPRESSION DES DONNÉES ===' as info;

-- Commencer par les tables dépendantes
DELETE FROM stock_movements;
SELECT 'Stock movements supprimés' as status;

DELETE FROM commandes;
SELECT 'Commandes supprimées' as status;

DELETE FROM articles;
SELECT 'Articles supprimés' as status;

DELETE FROM chantiers;
SELECT 'Chantiers supprimés' as status;

DELETE FROM uploaded_files;
SELECT 'Fichiers uploadés supprimés' as status;

-- Supprimer tous les utilisateurs sauf l'admin (matricule 100)
DELETE FROM users WHERE matricule != 100;
SELECT 'Utilisateurs supprimés (sauf admin)' as status;

-- 5. RÉACTIVER LES CONTRAINTES
SELECT '=== RÉACTIVATION CONTRAINTES ===' as info;

SET session_replication_role = DEFAULT;

-- 6. RÉINITIALISER TOUTES LES SÉQUENCES À 1
SELECT '=== RÉINITIALISATION SÉQUENCES ===' as info;

-- Forcer la réinitialisation même si les tables sont vides
SELECT setval('stock_movements_id_seq', 1, false);
SELECT setval('commandes_id_seq', 1, false);
SELECT setval('articles_id_seq', 1, false);
SELECT setval('chantiers_id_seq', 1, false);
SELECT setval('uploaded_files_id_seq', 1, false);

-- 7. RÉACTIVER RLS
SELECT '=== RÉACTIVATION RLS ===' as info;

ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE chantiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;

-- 8. RÉACTIVER LES TRIGGERS
SELECT '=== RÉACTIVATION DES TRIGGERS ===' as info;

ALTER TABLE stock_movements ENABLE TRIGGER ALL;
ALTER TABLE commandes ENABLE TRIGGER ALL;
ALTER TABLE articles ENABLE TRIGGER ALL;
ALTER TABLE chantiers ENABLE TRIGGER ALL;
ALTER TABLE users ENABLE TRIGGER ALL;
ALTER TABLE uploaded_files ENABLE TRIGGER ALL;

-- 9. VÉRIFICATION COMPLÈTE
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

-- 10. VÉRIFICATION DES SÉQUENCES
SELECT '=== ÉTAT DES SÉQUENCES ===' as info;
SELECT 'chantiers_id_seq' as sequence, last_value FROM chantiers_id_seq;
SELECT 'articles_id_seq' as sequence, last_value FROM articles_id_seq;
SELECT 'commandes_id_seq' as sequence, last_value FROM commandes_id_seq;
SELECT 'stock_movements_id_seq' as sequence, last_value FROM stock_movements_id_seq;

SELECT '=== NETTOYAGE TERMINÉ AVEC SUCCÈS ===' as message;
