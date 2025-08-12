-- Script de débogage pour vérifier les chantiers
-- À exécuter dans Supabase SQL Editor

-- Vérifier les chantiers existants
SELECT '=== CHANTIERS EXISTANTS ===' as info;
SELECT id, nom, description, icone, created_at 
FROM chantiers 
ORDER BY id;

-- Vérifier les articles et leurs chantiers
SELECT '=== ARTICLES ET LEURS CHANTIERS ===' as info;
SELECT 
    a.id as article_id,
    a.nom as article_nom,
    a.chantier_id,
    c.nom as chantier_nom
FROM articles a
LEFT JOIN chantiers c ON a.chantier_id = c.id
ORDER BY a.id;

-- Vérifier les utilisateurs et leurs chantiers
SELECT '=== UTILISATEURS ET LEURS CHANTIERS ===' as info;
SELECT 
    u.matricule,
    u.nom,
    u.role,
    u.chantier_id,
    c.nom as chantier_nom
FROM users u
LEFT JOIN chantiers c ON u.chantier_id = c.id
ORDER BY u.matricule;
