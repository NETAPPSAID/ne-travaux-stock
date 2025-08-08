-- Vérification et correction des séquences PostgreSQL
-- Ce script vérifie l'état actuel des séquences et les corrige si nécessaire

-- Vérification de l'état actuel des séquences
SELECT 'État actuel des séquences:' as info;

-- Vérifier la séquence des chantiers
SELECT 
  'chantiers_id_seq' as sequence_name,
  (SELECT MAX(id) FROM chantiers) as max_id_in_table;

-- Vérifier la séquence des articles
SELECT 
  'articles_id_seq' as sequence_name,
  (SELECT MAX(id) FROM articles) as max_id_in_table;

-- Correction des séquences si nécessaire
-- Correction de la séquence pour les chantiers
SELECT setval('chantiers_id_seq', (SELECT MAX(id) FROM chantiers), true) as chantiers_sequence_updated;

-- Correction de la séquence pour les articles  
SELECT setval('articles_id_seq', (SELECT MAX(id) FROM articles), true) as articles_sequence_updated;

-- Vérification finale des séquences
SELECT 'Séquences après correction:' as info;
SELECT 'Séquence chantiers_id_seq:' as info, currval('chantiers_id_seq') as current_value;
SELECT 'Séquence articles_id_seq:' as info, currval('articles_id_seq') as current_value;

-- Message de confirmation
SELECT 'Vérification et correction des séquences terminées!' as message;
