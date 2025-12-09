import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { ChevronLeft, FolderOpen, Plus, Search, X, Calendar } from 'lucide-react';
import { Note, Notebook, ViewState, User } from './types';
import { BottomBar, TabType } from './components/BottomBar';
import { NoteCard } from './components/NoteCard';
import { AuthScreen } from './components/AuthScreen';
import { OnboardingFlow } from './components/OnboardingFlow';
import { SettingsModal } from './components/SettingsModal';
import { db } from './db';
import { motion, AnimatePresence } from 'framer-motion';

// --- Types for App Logic ---

type AppStatus = 'loading' | 'onboarding' | 'auth' | 'app';

// --- Sub-Components ---

interface EditorViewProps {
  noteId: string;
  notebookId: string | null;
  userId: string;
  initialContent: string;
  notebookName?: string;
  onSave: (noteId: string, content: string, notebookId: string | null) => Promise<void>;
  onBack: () => void;
  isNew: boolean;
}

const EditorView: React.FC<EditorViewProps> = ({ 
  noteId, 
  notebookId,
  userId,
  initialContent, 
  notebookName, 
  onSave, 
  onBack,
  isNew
}) => {
  const [content, setContent] = useState(initialContent);
  const [isSaving, setIsSaving] = useState(false);

  // Auto-save logic
  useEffect(() => {
    if (content === initialContent) return;
    
    const timer = setTimeout(async () => {
      setIsSaving(true);
      await onSave(noteId, content, notebookId);
      setIsSaving(false);
    }, 1000);

    return () => clearTimeout(timer);
  }, [content, noteId, notebookId, onSave, initialContent]);

  const handleGoBack = async () => {
    if (content !== initialContent) {
      await onSave(noteId, content, notebookId);
    }
    onBack();
  };

  // Determines the source element for the morph: the "New Note" button or the specific Note Card
  const morphLayoutId = isNew ? "create-note-button" : `note-${noteId}`;

  return (
    <motion.div 
      layoutId={morphLayoutId}
      className="flex flex-col h-screen fixed inset-0 z-40 overflow-hidden bg-paper/90 backdrop-blur-3xl shadow-2xl"
      initial={{ opacity: 0, borderRadius: 28 }}
      animate={{ opacity: 1, borderRadius: 0 }}
      exit={{ opacity: 0, scale: 0.95, borderRadius: 28 }}
      transition={{ type: "spring", bounce: 0, duration: 0.5 }}
    >
      <header className="pt-14 pb-4 px-6 flex items-center justify-between sticky top-0 bg-transparent z-10">
        <button 
          onClick={handleGoBack}
          className="
            flex items-center gap-1 px-3 py-2 -ml-2 rounded-full
            text-ink/60 hover:text-ink 
            hover:bg-black/5 active:scale-95 transition-all
          "
        >
          <ChevronLeft size={24} />
          <span className="text-lg font-medium">Back</span>
        </button>
        
        <div className="flex flex-col items-end">
          <div className="text-xs font-sans font-medium text-ink/40 uppercase tracking-widest">
            {notebookName || 'Thought'}
          </div>
          {isSaving && <span className="text-[10px] text-ink/20 font-medium animate-pulse">Saving...</span>}
        </div>
      </header>

      <motion.textarea
        autoFocus
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="Type your thoughts here..."
        className="
          flex-1 w-full p-8 pt-4 
          bg-transparent border-none outline-none resize-none
          font-mono text-xl leading-8 text-ink placeholder:text-ink/20
          pb-32
        "
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      />
    </motion.div>
  );
};

interface HomeViewProps {
  user: User;
  notebooks: Notebook[];
  notes: Note[];
  activeTab: TabType;
  onOpenNotebook: (id: string) => void;
  onOpenNote: (id: string) => void;
  onCreateNotebook: () => void;
  onCreateNote: () => void;
  onOpenSettings: () => void;
  onOpenSearch: () => void;
  onHome: () => void;
}

const HomeView: React.FC<HomeViewProps> = ({ 
  user,
  notebooks, 
  notes, 
  activeTab,
  onOpenNotebook, 
  onOpenNote, 
  onCreateNotebook, 
  onCreateNote,
  onOpenSettings,
  onOpenSearch,
  onHome
}) => {
  const currentDate = new Date().toLocaleDateString('en-US', { weekday: 'long', day: 'numeric', month: 'long' });

  // Group notes by date logic could go here, simplified for now
  const recentNotes = notes.sort((a,b) => b.updatedAt - a.updatedAt);

  return (
    <motion.div 
      className="min-h-screen pb-40 bg-paper"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0, scale: 0.98 }}
      transition={{ duration: 0.4 }}
    >
      
      {/* Header with Date */}
      <header className="pt-16 px-6 sticky top-0 z-20 bg-paper/80 backdrop-blur-xl border-b border-black/0 transition-all duration-200 pb-4">
        <div className="flex justify-between items-start">
            <div>
                <div className="text-xs font-bold text-ink/40 uppercase tracking-widest mb-1 flex items-center gap-1">
                    <Calendar size={10} />
                    {currentDate}
                </div>
                <h1 className="text-3xl font-bold tracking-tight text-ink">
                    Hello, {user.name.split(' ')[0]}.
                </h1>
            </div>
            <div 
                className="
                  h-10 w-10 rounded-full 
                  bg-glass-surface backdrop-blur-md border border-glass-border shadow-sm
                  flex items-center justify-center text-ink/60
                "
            >
                {/* User Avatar Placeholder */}
                <span className="font-bold text-sm">{user.name.charAt(0)}</span>
            </div>
        </div>
      </header>

      {/* Notebooks Shelf (Horizontal Scroll) */}
      <section className="mt-6">
        <div className="px-6 flex justify-between items-center mb-4">
            <h2 className="text-lg font-bold text-ink">Notebooks</h2>
            <button 
              onClick={onCreateNotebook} 
              className="p-2 -mr-2 text-ink/40 hover:text-ink hover:bg-black/5 rounded-full transition-all active:scale-95"
            >
                <Plus size={20} />
            </button>
        </div>
        
        <div className="flex overflow-x-auto px-6 pb-8 gap-4 no-scrollbar snap-x snap-mandatory">
            {/* New Notebook Button (Inline) */}
             <button 
                onClick={onCreateNotebook}
                className="
                    snap-center min-w-[140px] h-[180px] rounded-2xl
                    bg-white/20 backdrop-blur-sm
                    border-2 border-dashed border-black/5 hover:border-black/10
                    flex flex-col items-center justify-center gap-2
                    text-ink/30 hover:bg-white/40 hover:text-ink/50
                    transition-all active:scale-95 duration-300
                "
            >
                <Plus size={24} />
                <span className="text-xs font-bold">New</span>
            </button>

            {notebooks.map(nb => {
                const count = notes.filter(n => n.notebookId === nb.id).length;
                return (
                    <motion.button
                        layoutId={`notebook-${nb.id}`}
                        key={nb.id}
                        onClick={() => onOpenNotebook(nb.id)}
                        className="
                            snap-center min-w-[140px] h-[180px] rounded-2xl
                            bg-gradient-to-br from-white to-white/60
                            shadow-glass border border-white/50
                            p-5 flex flex-col justify-between items-start
                            active:scale-95 transition-transform duration-200
                            relative overflow-hidden group
                        "
                        transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    >
                        <div className="absolute -right-4 -top-4 w-20 h-20 bg-blue-100/30 rounded-full blur-xl group-hover:bg-blue-200/40 transition-colors" />
                        
                        <FolderOpen className="text-ink" size={24} strokeWidth={1.5} />
                        
                        <div className="text-left w-full">
                            <span className="block font-bold text-ink text-lg leading-tight mb-1 truncate w-full">
                                {nb.name}
                            </span>
                            <span className="text-xs text-ink/40 font-medium">
                                {count} {count === 1 ? 'thought' : 'thoughts'}
                            </span>
                        </div>
                    </motion.button>
                )
            })}
        </div>
      </section>

      {/* Recent Thoughts Stream */}
      <section className="px-6">
        <h2 className="text-lg font-bold text-ink mb-4">Recent Thoughts</h2>
        <div className="flex flex-col gap-3">
          {recentNotes.length === 0 ? (
              <div className="py-12 text-center text-ink/30 font-mono text-sm border-2 border-dashed border-black/5 rounded-2xl">
                Tap the pencil to write your first thought.
              </div>
          ) : (
            recentNotes.slice(0, 10).map(note => (
                <div key={note.id} className="relative group">
                    <NoteCard 
                        layoutId={`note-${note.id}`}
                        note={note} 
                        onClick={() => onOpenNote(note.id)}
                    />
                </div>
            ))
          )}
        </div>
        <div className="h-12" /> {/* Spacer */}
      </section>

      <BottomBar 
        activeTab={activeTab}
        onHome={onHome}
        onNewNote={onCreateNote}
        onSettings={onOpenSettings}
        onSearch={onOpenSearch}
      />
    </motion.div>
  );
};

interface NotebookDetailViewProps {
  notebook: Notebook;
  notes: Note[];
  onBack: () => void;
  onOpenNote: (id: string) => void;
  onCreateNote: () => void;
}

const NotebookDetailView: React.FC<NotebookDetailViewProps> = ({ 
  notebook, 
  notes, 
  onBack, 
  onOpenNote, 
  onCreateNote 
}) => {
  return (
    <motion.div 
      layoutId={`notebook-${notebook.id}`}
      className="min-h-screen pb-32 fixed inset-0 z-40 bg-paper/90 backdrop-blur-3xl overflow-y-auto"
      initial={{ borderRadius: 32 }}
      animate={{ borderRadius: 0 }}
      exit={{ borderRadius: 32, opacity: 0 }}
      transition={{ type: "spring", bounce: 0, duration: 0.5 }}
    >
        <header className="pt-14 pb-4 px-6 sticky top-0 bg-transparent z-10 border-b border-black/5">
        <div className="flex items-center justify-between mb-4">
          <button 
            onClick={onBack}
            className="
                flex items-center gap-1 px-3 py-2 -ml-2 rounded-full
                text-ink/60 hover:text-ink 
                hover:bg-black/5 active:scale-95 transition-all
            "
          >
            <ChevronLeft size={24} />
            <span className="text-lg font-medium">Home</span>
          </button>
        </div>
        <motion.h1 className="text-3xl font-bold text-ink" layoutId={`notebook-title-${notebook.id}`}>{notebook.name}</motion.h1>
        <p className="text-ink/40 text-sm font-medium mt-1">{notes.length} thoughts</p>
      </header>

      <div className="px-6 mt-6">
          {notes.length === 0 ? (
              <div className="py-20 text-center text-ink/30 font-mono">
                This notebook is empty.
              </div>
          ) : (
            notes
              .sort((a,b) => b.updatedAt - a.updatedAt)
              .map(note => (
                <NoteCard 
                  layoutId={`note-${note.id}`}
                  key={note.id} 
                  note={note} 
                  onClick={() => onOpenNote(note.id)}
                />
              ))
          )}
      </div>

      <div className="fixed bottom-8 right-6 z-50">
          <motion.button
            layoutId="create-note-button"
            onClick={onCreateNote}
            className="
              group relative overflow-hidden
              h-14 w-14
              rounded-full
              flex items-center justify-center
              bg-ink text-paper
              shadow-lg hover:shadow-xl hover:-translate-y-1
              transition-all duration-300
            "
            whileTap={{ scale: 0.9 }}
          >
            <div className="transition-colors duration-200 relative z-10">
              <Plus size={24} strokeWidth={3} />
            </div>
            {/* Gloss Overlay */}
            <div className="absolute inset-0 bg-gradient-to-tr from-white/20 to-transparent pointer-events-none" />
          </motion.button>
      </div>
    </motion.div>
  );
};

interface SearchOverlayProps {
  isOpen: boolean;
  onClose: () => void;
  notes: Note[];
  onOpenNote: (id: string) => void;
}

const SearchOverlay: React.FC<SearchOverlayProps> = ({ isOpen, onClose, notes, onOpenNote }) => {
  const [query, setQuery] = useState('');

  useEffect(() => {
    if (!isOpen) setQuery('');
  }, [isOpen]);

  const filteredNotes = useMemo(() => {
    if (!query) return [];
    const lowerQ = query.toLowerCase();
    return notes.filter(n => n.content.toLowerCase().includes(lowerQ));
  }, [query, notes]);

  // If we are closed, render nothing
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[60] flex flex-col pointer-events-none">
      {/* Background Dimmer */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="absolute inset-0 bg-paper/95 backdrop-blur-xl pointer-events-auto"
        onClick={onClose}
      />
      
      <div className="relative z-10 pt-16 px-6 pb-4 flex items-center gap-4 pointer-events-auto">
        {/* Morphing Container: The BottomBar search button morphs into this search input container */}
        <motion.div 
          layoutId="search-container"
          className="flex-1 bg-glass-surface border border-glass-border shadow-glass rounded-2xl flex items-center px-4 h-14"
          transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
        >
          <Search size={20} className="text-ink/40" />
          <input
            autoFocus
            className="flex-1 bg-transparent border-none outline-none ml-3 text-ink font-medium placeholder:text-ink/30"
            placeholder="Search thoughts..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
          {query && (
             <button onClick={() => setQuery('')} className="text-ink/40 hover:text-ink">
               <X size={16} />
             </button>
          )}
        </motion.div>
        
        <motion.button 
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: 20 }}
          onClick={onClose}
          className="text-ink font-semibold"
        >
          Cancel
        </motion.button>
      </div>

      <div className="relative z-10 flex-1 overflow-y-auto px-6 pb-10 pointer-events-auto">
        {query === '' ? (
          <motion.div 
            initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
            className="text-center mt-20 text-ink/30 font-medium"
          >
            Type to search...
          </motion.div>
        ) : filteredNotes.length === 0 ? (
          <motion.div 
            initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
            className="text-center mt-20 text-ink/30 font-medium"
          >
            No results found.
          </motion.div>
        ) : (
          <div className="flex flex-col gap-2">
            <h3 className="text-xs font-bold text-ink/30 uppercase tracking-widest mb-2">Results</h3>
            {filteredNotes.map(note => (
               <NoteCard 
                  layoutId={`note-${note.id}`}
                  key={note.id}
                  note={note}
                  onClick={() => {
                    onOpenNote(note.id);
                    onClose();
                  }}
               />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

// --- Main App ---

const App: React.FC = () => {
  // --- State ---
  const [appStatus, setAppStatus] = useState<AppStatus>('loading');
  
  // Onboarding specific state
  const [onboardingName, setOnboardingName] = useState('');

  const [user, setUser] = useState<User | null>(null);
  const [notes, setNotes] = useState<Note[]>([]);
  const [notebooks, setNotebooks] = useState<Notebook[]>([]);
  const [view, setView] = useState<ViewState>({ type: 'home' });
  
  // Modals
  const [isNotebookModalOpen, setIsNotebookModalOpen] = useState(false);
  const [newNotebookName, setNewNotebookName] = useState('');
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSearchOpen, setIsSearchOpen] = useState(false);

  // --- Initial Auth Check ---
  useEffect(() => {
    const savedUser = localStorage.getItem('thoughts_user_session');
    if (savedUser) {
      setUser(JSON.parse(savedUser));
      setAppStatus('app');
    } else {
      setAppStatus('onboarding');
    }
  }, []);

  // --- Data Fetching ---
  const refreshData = useCallback(async () => {
    if (!user) return;
    const userNotes = await db.notes.where('userId').equals(user.id).toArray();
    const userNotebooks = await db.notebooks.where('userId').equals(user.id).toArray();
    setNotes(userNotes);
    setNotebooks(userNotebooks);
  }, [user]);

  useEffect(() => {
    if (user) {
      refreshData();
    } else {
      setNotes([]);
      setNotebooks([]);
    }
  }, [user, refreshData]);

  // --- Auth Handlers ---
  const handleOnboardingComplete = (name: string) => {
    setOnboardingName(name);
    setAppStatus('auth');
  };

  const handleLogin = (loggedInUser: User) => {
    setUser(loggedInUser);
    localStorage.setItem('thoughts_user_session', JSON.stringify(loggedInUser));
    setAppStatus('app');
    // Clear temporary onboarding data
    setOnboardingName('');
  };

  const handleLogout = () => {
    setUser(null);
    localStorage.removeItem('thoughts_user_session');
    setView({ type: 'home' });
    setIsSettingsOpen(false);
    setAppStatus('onboarding'); // Go back to start
  };

  // --- Actions ---

  const handleCreateNote = useCallback(() => {
    const notebookId = view.type === 'notebook' ? view.notebookId : null;
    const newId = Math.random().toString(36).substr(2, 9);
    setView({ type: 'editor', noteId: newId, notebookId });
  }, [view]);

  const handleSaveNote = useCallback(async (noteId: string, content: string, notebookId: string | null) => {
    if (!user) return;

    const timestamp = Date.now();
    const existing = await db.notes.get(noteId);
    
    if (existing) {
      await db.notes.update(noteId, { content, updatedAt: timestamp });
    } else {
      if (!content.trim()) return; 
      const newNote: Note = {
        id: noteId,
        userId: user.id,
        content,
        notebookId,
        createdAt: timestamp,
        updatedAt: timestamp
      };
      await db.notes.add(newNote);
    }
    refreshData();
  }, [user, refreshData]);

  const handleCreateNotebook = async () => {
    if (!newNotebookName.trim() || !user) return;
    const newNotebook: Notebook = {
      id: Math.random().toString(36).substr(2, 9),
      userId: user.id,
      name: newNotebookName,
      createdAt: Date.now()
    };
    
    await db.notebooks.add(newNotebook);
    await refreshData();
    
    setNewNotebookName('');
    setIsNotebookModalOpen(false);
  };

  // --- Render based on Status ---

  if (appStatus === 'loading') {
    return <div className="min-h-screen bg-paper" />;
  }

  if (appStatus === 'onboarding') {
    return (
      <OnboardingFlow 
        onComplete={handleOnboardingComplete}
        onSkipToLogin={() => setAppStatus('auth')}
      />
    );
  }

  if (appStatus === 'auth') {
    return (
      <AuthScreen 
        onLogin={handleLogin} 
        initialName={onboardingName} 
        onBackToOnboarding={onboardingName ? undefined : () => setAppStatus('onboarding')}
      />
    );
  }

  // --- Main App Logic (appStatus === 'app') ---
  if (!user) return null; // Should be handled by status

  const getActiveTab = (): TabType => {
    if (isSearchOpen) return 'search';
    if (isSettingsOpen) return 'settings';
    if (view.type === 'home') return 'home';
    return 'notes';
  };

  return (
    <div className="min-h-screen w-full bg-paper text-ink relative overflow-hidden">
      
      <AnimatePresence mode="popLayout" initial={false}>
        {view.type === 'home' && (
          <HomeView 
            key="home"
            user={user}
            notebooks={notebooks}
            notes={notes}
            activeTab={getActiveTab()}
            onOpenNotebook={(id) => setView({ type: 'notebook', notebookId: id })}
            onOpenNote={(id) => setView({ type: 'editor', noteId: id, notebookId: null })}
            onCreateNotebook={() => setIsNotebookModalOpen(true)}
            onCreateNote={handleCreateNote}
            onOpenSettings={() => setIsSettingsOpen(true)}
            onOpenSearch={() => setIsSearchOpen(true)}
            onHome={() => {
               window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
          />
        )}

        {view.type === 'notebook' && (() => {
          const nb = notebooks.find(n => n.id === view.notebookId);
          if (!nb) {
              setView({ type: 'home' });
              return null;
          }
          return (
            <NotebookDetailView 
              key={`notebook-view-${nb.id}`}
              notebook={nb}
              notes={notes.filter(n => n.notebookId === nb.id)}
              onBack={() => setView({ type: 'home' })}
              onOpenNote={(id) => setView({ type: 'editor', noteId: id, notebookId: nb.id })}
              onCreateNote={handleCreateNote}
            />
          );
        })()}

        {view.type === 'editor' && view.noteId && (
          <EditorView 
            key={`editor-view-${view.noteId}`}
            noteId={view.noteId}
            notebookId={view.notebookId}
            userId={user.id}
            initialContent={notes.find(n => n.id === view.noteId)?.content || ''}
            notebookName={view.notebookId ? notebooks.find(n => n.id === view.notebookId)?.name : undefined}
            onSave={handleSaveNote}
            onBack={() => setView(view.notebookId ? { type: 'notebook', notebookId: view.notebookId } : { type: 'home' })}
            isNew={!notes.find(n => n.id === view.noteId)}
          />
        )}
      </AnimatePresence>

      {/* Modal for New Notebook */}
      <AnimatePresence>
        {isNotebookModalOpen && (
            <div className="fixed inset-0 z-[100] flex items-center justify-center px-4">
            <motion.div 
                initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
                className="absolute inset-0 bg-black/20 backdrop-blur-sm"
                onClick={() => setIsNotebookModalOpen(false)}
            />
            <motion.div 
                initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.9, opacity: 0 }}
                className="
                w-full max-w-xs 
                bg-white/80 backdrop-blur-xl 
                border border-white/40 
                shadow-2xl rounded-[32px] 
                p-6 relative z-10
                "
            >
                <h3 className="text-lg font-bold text-center mb-4">New Notebook</h3>
                <input 
                autoFocus
                type="text" 
                placeholder="e.g. Artificial Intelligence"
                className="w-full bg-black/5 rounded-xl px-4 py-3 mb-6 outline-none text-center font-medium"
                value={newNotebookName}
                onChange={(e) => setNewNotebookName(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleCreateNotebook()}
                />
                <div className="flex gap-2">
                <button 
                    onClick={() => setIsNotebookModalOpen(false)}
                    className="flex-1 py-3 font-medium text-ink/50 hover:bg-black/5 rounded-xl transition-colors"
                >
                    Cancel
                </button>
                <button 
                    onClick={handleCreateNotebook}
                    disabled={!newNotebookName.trim()}
                    className="flex-1 py-3 font-bold bg-ink text-white rounded-xl shadow-lg disabled:opacity-50 disabled:shadow-none transition-all active:scale-95"
                >
                    Create
                </button>
                </div>
            </motion.div>
            </div>
        )}
      </AnimatePresence>

      <SettingsModal 
        user={user}
        isOpen={isSettingsOpen}
        onClose={() => setIsSettingsOpen(false)}
        onLogout={handleLogout}
      />

      <AnimatePresence>
        {isSearchOpen && (
            <SearchOverlay 
                isOpen={isSearchOpen} 
                onClose={() => setIsSearchOpen(false)}
                notes={notes}
                onOpenNote={(id) => setView({ type: 'editor', noteId: id, notebookId: null })}
            />
        )}
      </AnimatePresence>

    </div>
  );
};

export default App;