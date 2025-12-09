
import React, { useState } from 'react';
import { ArrowRight } from 'lucide-react';

interface OnboardingFlowProps {
  onComplete: (name: string) => void;
  onSkipToLogin: () => void;
}

export const OnboardingFlow: React.FC<OnboardingFlowProps> = ({ onComplete, onSkipToLogin }) => {
  const [step, setStep] = useState<0 | 1>(0);
  const [name, setName] = useState('');
  const [isExiting, setIsExiting] = useState(false);

  const handleNext = () => {
    if (step === 0) {
      setStep(1);
    } else {
      if (!name.trim()) return;
      setIsExiting(true);
      setTimeout(() => onComplete(name), 500); // Wait for exit animation
    }
  };

  return (
    <div className={`
      fixed inset-0 z-50 bg-paper flex flex-col items-center justify-center p-8
      transition-opacity duration-500
      ${isExiting ? 'opacity-0 pointer-events-none' : 'opacity-100'}
    `}>
      {/* Background Ambience */}
      <div className="absolute top-[-20%] left-[-20%] w-[80vw] h-[80vw] rounded-full bg-blue-100/40 blur-[120px]" />
      <div className="absolute bottom-[-20%] right-[-20%] w-[80vw] h-[80vw] rounded-full bg-orange-100/40 blur-[120px]" />

      <div className="relative z-10 w-full max-w-md flex flex-col items-start min-h-[300px]">
        {step === 0 && (
          <div className="animate-in slide-in-from-bottom-8 fade-in duration-700 flex flex-col gap-6">
            <h1 className="text-5xl font-bold text-ink tracking-tight leading-tight">
              Capture your<br />
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">
                mind.
              </span>
            </h1>
            <p className="text-xl text-ink/60 leading-relaxed font-medium max-w-xs">
              A quiet place for your thoughts, ideas, and notebooks.
            </p>
          </div>
        )}

        {step === 1 && (
          <div className="w-full animate-in slide-in-from-right-8 fade-in duration-500">
            <label className="block text-sm font-bold text-ink/40 uppercase tracking-widest mb-4">
              Let's get introduced
            </label>
            <h2 className="text-3xl font-bold text-ink mb-8">What should we call you?</h2>
            <input
              autoFocus
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Your Name"
              className="
                w-full bg-transparent border-b-2 border-black/10 
                pb-4 text-3xl font-medium text-ink placeholder:text-ink/20
                outline-none focus:border-ink transition-colors
              "
              onKeyDown={(e) => e.key === 'Enter' && handleNext()}
            />
          </div>
        )}
      </div>

      <div className="absolute bottom-12 right-8 flex items-center gap-4">
        {step === 0 && (
          <button 
            onClick={onSkipToLogin}
            className="text-ink/40 font-semibold hover:text-ink transition-colors text-sm px-4"
          >
            I have an account
          </button>
        )}
        
        <button
          onClick={handleNext}
          disabled={step === 1 && !name.trim()}
          className={`
            h-16 w-16 rounded-full bg-ink text-paper shadow-xl
            flex items-center justify-center
            transition-all duration-300 active:scale-90
            disabled:opacity-50 disabled:scale-100
            relative overflow-hidden group
          `}
        >
          <span className="relative z-10">
            <ArrowRight size={28} />
          </span>
          <div className="absolute inset-0 bg-gradient-to-tr from-white/20 to-transparent pointer-events-none" />
        </button>
      </div>
    </div>
  );
};