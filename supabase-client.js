// Client Supabase pour NE TRAVAUX GESTION DE STOCK

// Configuration Supabase
const SUPABASE_URL = 'https://sltmmvuxcanzhqakrtrw.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNsdG1tdnV4Y2FuemhxYWtydHJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NDk2MDIsImV4cCI6MjA3MDIyNTYwMn0.zlue3-HiLaxu6Frg27pZokTCvW4rlkesT-1RxRyjoxU'

// Créer le client Supabase
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// Fonctions de base de données
window.supabaseDB = {
  // ===== GESTION DES UTILISATEURS =====
  async getUsers() {
    const { data, error } = await supabase
      .from('users')
      .select('*')
    return data || []
  },

  async updateUser(matricule, updates) {
    const { data, error } = await supabase
      .from('users')
      .update(updates)
      .eq('matricule', matricule)
    return { data, error }
  },

  async addUser(user) {
    const { data, error } = await supabase
      .from('users')
      .insert(user)
    return { data, error }
  },

  async deleteUser(matricule) {
    const { data, error } = await supabase
      .from('users')
      .delete()
      .eq('matricule', matricule)
    return { data, error }
  },

  async getUserByMatricule(matricule) {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('matricule', matricule)
    return { data, error }
  },

  // ===== GESTION DES CHANTIERS =====
  async getChantiers() {
    const { data, error } = await supabase
      .from('chantiers')
      .select('*')
    return data || []
  },

  async addChantier(chantier) {
    const { data, error } = await supabase
      .from('chantiers')
      .insert(chantier)
    return { data, error }
  },

  async updateChantier(id, updates) {
    const { data, error } = await supabase
      .from('chantiers')
      .update(updates)
      .eq('id', id)
    return { data, error }
  },

  async deleteChantier(id) {
    const { data, error } = await supabase
      .from('chantiers')
      .delete()
      .eq('id', id)
    return { data, error }
  },

  // ===== GESTION DES ARTICLES =====
  async getArticles() {
    const { data, error } = await supabase
      .from('articles')
      .select('*')
    return data || []
  },

  async addArticle(article) {
    const { data, error } = await supabase
      .from('articles')
      .insert(article)
    return { data, error }
  },

  async updateArticle(id, updates) {
    const { data, error } = await supabase
      .from('articles')
      .update(updates)
      .eq('id', id)
    return { data, error }
  },

  async deleteArticle(id) {
    const { data, error } = await supabase
      .from('articles')
      .delete()
      .eq('id', id)
    return { data, error }
  },

  // ===== GESTION DES COMMANDES =====
  async getCommandes() {
    const { data, error } = await supabase
      .from('commandes')
      .select('*')
    return data || []
  },

  async addCommande(commande) {
    const { data, error } = await supabase
      .from('commandes')
      .insert(commande)
    return { data, error }
  },

  // ===== GESTION DE L'HISTORIQUE =====
  async getHistorique() {
    const { data, error } = await supabase
      .from('stock_movements')
      .select('*')
      .order('created_at', { ascending: false })
    return data || []
  },

  async addHistoriqueEntry(entry) {
    const { data, error } = await supabase
      .from('stock_movements')
      .insert(entry)
    return { data, error }
  },

  // ===== GESTION DES FICHIERS =====
  async uploadFile(file, path) {
    const { data, error } = await supabase.storage
      .from('bons-entree')
      .upload(path, file)
    
    if (error) {
      console.error('Erreur upload fichier:', error)
      return { data: null, error }
    }

    // Générer l'URL publique
    const { data: urlData } = supabase.storage
      .from('bons-entree')
      .getPublicUrl(path)

    return { data: urlData.publicUrl, error: null }
  },

  async deleteFile(path) {
    const { data, error } = await supabase.storage
      .from('bons-entree')
      .remove([path])
    return { data, error }
  },

  // ===== SYNCHRONISATION TEMPS RÉEL =====
  async syncWithSupabase() {
    console.log('🔄 Démarrage de la synchronisation temps réel...')
    
    // Écouter les changements sur les articles
    supabase
      .channel('stock_changes')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'articles' },
        (payload) => {
          console.log('🔄 Changement détecté sur articles:', payload)
          window.dispatchEvent(new CustomEvent('stock-updated', { detail: payload }))
        }
      )
      .subscribe()

    // Écouter les changements sur les mouvements de stock
    supabase
      .channel('movement_changes')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'stock_movements' },
        (payload) => {
          console.log('🔄 Changement détecté sur mouvements:', payload)
          window.dispatchEvent(new CustomEvent('movement-updated', { detail: payload }))
        }
      )
      .subscribe()

    // Écouter les changements sur les commandes
    supabase
      .channel('commande_changes')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: 'commandes' },
        (payload) => {
          console.log('🔄 Changement détecté sur commandes:', payload)
          window.dispatchEvent(new CustomEvent('commande-updated', { detail: payload }))
        }
      )
      .subscribe()

    console.log('✅ Synchronisation temps réel activée')
  }
}
