import React from 'react';
import { Note } from '../types';
import { motion } from 'framer-motion';

interface NoteCardProps {
  note: Note;
  onClick: () => void;
  layoutId?: string;
}

export const NoteCard: React.FC<NoteCardProps> = ({ note, onClick, layoutId }) => {
  // Truncate content for preview, remove newlines
  const previewText = note.content.length > 0 ? note.content.substring(0, 100) : "Empty thought...";
  const dateStr = new Date(note.updatedAt).toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  return (
    <motion.div 
      layoutId={layoutId}
      onClick={onClick}
      className="
        w-full p-5 mb-4
        bg-white/40 backdrop-blur-sm
        border border-black/5
        rounded-2xl
        cursor-pointer
        relative overflow-hidden
      "
      whileTap={{ scale: 0.98 }}
      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
    >
      <motion.p className="font-mono text-ink text-base leading-relaxed line-clamp-3">
        {previewText}
      </motion.p>
      <div className="mt-3 text-xs font-sans text-ink/40 font-medium">
        {dateStr}
      </div>
    </motion.div>
  );
};