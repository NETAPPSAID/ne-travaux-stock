-- ÉTAPE 2 : Création des index (après les tables)
-- À exécuter dans Supabase SQL Editor APRÈS l'étape 1

-- ===== INDEXES POUR PERFORMANCE =====
CREATE INDEX IF NOT EXISTS idx_entrees_chantier ON entrees(chantier_id);
CREATE INDEX IF NOT EXISTS idx_entrees_pointeur ON entrees(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_entrees_date ON entrees(date_entree);

CREATE INDEX IF NOT EXISTS idx_sorties_chantier ON sorties(chantier_id);
CREATE INDEX IF NOT EXISTS idx_sorties_pointeur ON sorties(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_sorties_date ON sorties(date_sortie);

CREATE INDEX IF NOT EXISTS idx_commandes_chantier ON commandes(chantier_id);
CREATE INDEX IF NOT EXISTS idx_commandes_pointeur ON commandes(pointeur_matricule);
CREATE INDEX IF NOT EXISTS idx_commandes_statut ON commandes(statut);

-- ===== MESSAGE DE CONFIRMATION =====
SELECT 'Indexes créés avec succès! Toutes les tables sont prêtes.' as message;
