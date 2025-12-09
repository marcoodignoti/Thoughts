import React from 'react';
import { LogOut, X, User as UserIcon, Mail } from 'lucide-react';
import { User } from '../types';

interface SettingsModalProps {
  user: User;
  isOpen: boolean;
  onClose: () => void;
  onLogout: () => void;
}

export const SettingsModal: React.FC<SettingsModalProps> = ({ user, isOpen, onClose, onLogout }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center px-4">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-black/20 backdrop-blur-sm animate-in fade-in duration-200"
        onClick={onClose}
      />
      
      {/* Modal Card */}
      <div className="
        w-full max-w-sm 
        bg-paper/90 backdrop-blur-2xl
        border border-white/50
        shadow-2xl rounded-[32px] 
        p-6 relative z-10
        animate-in zoom-in-95 slide-in-from-bottom-4 duration-300
      ">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-xl font-bold text-ink">Settings</h2>
          <button 
            onClick={onClose}
            className="p-2 bg-black/5 rounded-full hover:bg-black/10 transition-colors"
          >
            <X size={18} className="text-ink/60" />
          </button>
        </div>

        {/* User Card */}
        <div className="bg-white/60 rounded-2xl p-4 border border-black/5 mb-6 flex items-center gap-4">
          <div className="h-12 w-12 rounded-full bg-ink flex items-center justify-center text-paper font-bold text-lg">
            {user.name.charAt(0).toUpperCase()}
          </div>
          <div className="overflow-hidden">
            <h3 className="font-bold text-ink truncate">{user.name}</h3>
            <p className="text-xs text-ink/50 truncate font-mono">{user.email}</p>
          </div>
        </div>

        {/* Actions */}
        <div className="space-y-2">
            <div className="w-full p-4 rounded-xl bg-white/40 border border-black/5 flex items-center gap-3 text-ink/40 cursor-not-allowed">
                 <UserIcon size={20} />
                 <span className="font-medium text-sm">Account Details</span>
            </div>
             <div className="w-full p-4 rounded-xl bg-white/40 border border-black/5 flex items-center gap-3 text-ink/40 cursor-not-allowed">
                 <Mail size={20} />
                 <span className="font-medium text-sm">Email Preferences</span>
            </div>
            
            <div className="h-4"></div>

            <button 
                onClick={() => {
                    onLogout();
                    onClose();
                }}
                className="w-full p-4 rounded-xl bg-red-500/10 hover:bg-red-500/20 border border-red-500/20 flex items-center gap-3 text-red-600 transition-colors group"
            >
                <LogOut size={20} className="group-active:scale-95 transition-transform" />
                <span className="font-medium text-sm">Sign Out</span>
            </button>
        </div>
        
        <div className="mt-8 text-center">
            <p className="text-[10px] text-ink/20 font-mono uppercase tracking-widest">
                Thoughts v1.1
            </p>
        </div>
      </div>
    </div>
  );
};