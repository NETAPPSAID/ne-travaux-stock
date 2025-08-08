-- Correction des séquences PostgreSQL pour éviter les erreurs de clé dupliquée
-- Ce fichier doit être exécuté après l'insertion des données initiales

-- Correction de la séquence pour les chantiers
SELECT setval('chantiers_id_seq', (SELECT MAX(id) FROM chantiers), true);

-- Correction de la séquence pour les articles  
SELECT setval('articles_id_seq', (SELECT MAX(id) FROM articles), true);

-- Note: users.matricule n'utilise pas de séquence car c'est INTEGER PRIMARY KEY
-- Les matricules sont gérés manuellement

-- Vérification des séquences
SELECT 'Séquence chantiers_id_seq:' as info, currval('chantiers_id_seq') as current_value;
SELECT 'Séquence articles_id_seq:' as info, currval('articles_id_seq') as current_value;

-- Message de confirmation
SELECT 'Séquences corrigées avec succès!' as message;
