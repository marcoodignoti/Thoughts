import React from 'react';

interface LiquidButtonProps {
  onClick: () => void;
  icon: React.ReactNode;
  label?: string; // For accessibility
  side: 'left' | 'right';
}

/**
 * LiquidButton Component
 * Implements the "Liquid Glass" philosophy:
 * - High blur (backdrop-blur-xl)
 * - Translucent white background
 * - Subtle border for light refraction
 * - Spring animation on press (scale-90)
 * - Minimum 44pt touch target (implemented as h-14 w-14 / 56px)
 */
export const LiquidButton: React.FC<LiquidButtonProps> = ({ onClick, icon, label, side }) => {
  return (
    <button
      onClick={onClick}
      aria-label={label}
      className={`
        group
        absolute bottom-8 ${side === 'left' ? 'left-6' : 'right-6'}
        h-14 w-14
        rounded-full
        flex items-center justify-center
        bg-glass-surface backdrop-blur-xl
        border border-glass-border
        shadow-glass
        transition-all duration-300 ease-[cubic-bezier(0.25,0.1,0.25,1)]
        active:scale-90 active:shadow-glass-pressed active:bg-white/80
        z-50
      `}
    >
      <div className="text-ink/80 group-active:text-ink transition-colors duration-200">
        {icon}
      </div>
      {/* Glossy reflection overlay */}
      <div className="absolute inset-0 rounded-full bg-gradient-to-tr from-white/40 to-transparent pointer-events-none" />
    </button>
  );
};