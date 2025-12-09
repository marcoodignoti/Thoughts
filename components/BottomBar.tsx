import React from 'react';
import { Home, PenLine, Settings, Search } from 'lucide-react';
import { motion } from 'framer-motion';

export type TabType = 'home' | 'notes' | 'settings' | 'search';

interface BottomBarProps {
  activeTab: TabType;
  onHome: () => void;
  onNewNote: () => void;
  onSettings: () => void;
  onSearch: () => void;
}

export const BottomBar: React.FC<BottomBarProps> = ({ 
  activeTab,
  onHome, 
  onNewNote, 
  onSettings,
  onSearch
}) => {
  return (
    <div className="fixed bottom-8 w-full flex justify-center items-end z-50 pointer-events-none px-6">
      <div className="flex items-center gap-3 pointer-events-auto">
        
        {/* Main Dock Capsule */}
        <motion.div 
          initial={{ y: 100, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ type: 'spring', damping: 20, stiffness: 300, delay: 0.1 }}
          className="
            flex items-center gap-1 p-2
            bg-glass-surface backdrop-blur-xl
            border border-glass-border
            shadow-glass
            rounded-full
            relative overflow-hidden
          "
        >
          <BarButton 
            isActive={activeTab === 'home'}
            icon={<Home size={20} />} 
            label="Home" 
            onClick={onHome} 
          />
          
          <div className="w-px h-6 bg-black/5 mx-1" />
          
          {/* New Note Button with layoutId for Morphing */}
          <BarButton 
            layoutId="create-note-button"
            isActive={activeTab === 'notes'}
            icon={<PenLine size={24} />} 
            label="New Note" 
            onClick={onNewNote}
            isPrimary
          />

          <div className="w-px h-6 bg-black/5 mx-1" />

          <BarButton 
            isActive={activeTab === 'settings'}
            icon={<Settings size={20} />} 
            label="Settings" 
            onClick={onSettings} 
          />
          
          {/* Subtle reflection overlay for the whole dock */}
          <div className="absolute inset-0 bg-gradient-to-b from-white/20 to-transparent pointer-events-none rounded-full" />
        </motion.div>

        {/* Detached Accessory: Search */}
        <motion.button
          layoutId="search-container"
          onClick={onSearch}
          className={`
            group relative
            h-[60px] w-[60px]
            rounded-full
            flex items-center justify-center
            bg-glass-surface backdrop-blur-xl
            border border-glass-border
            shadow-glass
            transition-all duration-300
            active:scale-90 active:bg-white/80
            hover:bg-white/60
            ${activeTab === 'search' ? 'bg-white ring-2 ring-black/5' : ''}
          `}
          whileTap={{ scale: 0.9 }}
          transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
        >
          <Search 
            size={22} 
            className={`
              text-ink/70 transition-colors duration-300
              ${activeTab === 'search' ? 'text-ink' : ''}
            `} 
          />
        </motion.button>

      </div>
    </div>
  );
};

interface BarButtonProps {
  icon: React.ReactNode;
  label: string;
  onClick: () => void;
  isActive: boolean;
  isPrimary?: boolean;
  layoutId?: string;
}

const BarButton: React.FC<BarButtonProps> = ({ icon, label, onClick, isActive, isPrimary, layoutId }) => {
  return (
    <motion.button
      layoutId={layoutId}
      onClick={onClick}
      aria-label={label}
      className={`
        relative group
        flex items-center justify-center
        rounded-full
        transition-all duration-300 ease-[cubic-bezier(0.25,0.1,0.25,1)]
        z-10 overflow-hidden
        ${isActive && isPrimary
          ? 'w-14 h-14 bg-ink text-paper shadow-lg' 
          : isActive 
            ? 'w-12 h-12 bg-black/10 text-ink'
            : isPrimary
              ? 'w-14 h-14 bg-ink text-paper shadow-lg hover:shadow-xl hover:-translate-y-0.5'
              : 'w-12 h-12 text-ink/60 hover:bg-black/5 hover:text-ink'
        }
      `}
      whileTap={{ scale: 0.9 }}
    >
      {/* Icon Container */}
      <div className={`transition-transform duration-500 relative z-10 ${isActive ? 'scale-110' : 'scale-100'}`}>
        {icon}
      </div>

      {/* Gloss Effect for Primary Button */}
      {isPrimary && (
        <div className="absolute inset-0 bg-gradient-to-tr from-white/20 to-transparent pointer-events-none opacity-100" />
      )}
    </motion.button>
  );
};
