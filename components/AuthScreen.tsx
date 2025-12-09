
import React, { useState, useEffect } from 'react';
import { db, delay } from '../db';
import { User } from '../types';
import { ArrowLeft } from 'lucide-react';

interface AuthScreenProps {
  onLogin: (user: User) => void;
  initialName?: string;
  onBackToOnboarding?: () => void;
}

export const AuthScreen: React.FC<AuthScreenProps> = ({ onLogin, initialName, onBackToOnboarding }) => {
  const [isLogin, setIsLogin] = useState(!initialName);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState(initialName || '');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (initialName) {
      setIsLogin(false);
      setName(initialName);
    }
  }, [initialName]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      // Simulate network request
      await delay(600);

      if (isLogin) {
        const user = await db.users.where('email').equals(email).first();
        if (user && user.passwordHash === password) { // Simple check for demo
          onLogin(user);
        } else {
          setError('Invalid credentials');
        }
      } else {
        // Register
        const existing = await db.users.where('email').equals(email).first();
        if (existing) {
          setError('Email already in use');
          setLoading(false);
          return;
        }

        const newUser: User = {
          id: Math.random().toString(36).substr(2, 9),
          email,
          passwordHash: password,
          name: name || 'Writer'
        };

        await db.users.add(newUser);
        onLogin(newUser);
      }
    } catch (err) {
      setError('An error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen w-full flex flex-col items-center justify-center p-6 relative overflow-hidden bg-paper animate-in fade-in duration-500">
      
      {onBackToOnboarding && (
        <button 
          onClick={onBackToOnboarding}
          className="absolute top-12 left-6 p-2 rounded-full hover:bg-black/5 text-ink/60 transition-colors"
        >
          <ArrowLeft size={24} />
        </button>
      )}

      {/* Ambient background blobs */}
      <div className="absolute top-[-10%] left-[-10%] w-[60vw] h-[60vw] rounded-full bg-blue-200/20 blur-[100px]" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[60vw] h-[60vw] rounded-full bg-orange-100/30 blur-[100px]" />

      <div className="
        w-full max-w-sm
        bg-glass-surface backdrop-blur-xl
        border border-glass-border
        shadow-glass
        rounded-[32px]
        p-8
        relative z-10
      ">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-ink mb-2">
            {initialName ? `Hi, ${initialName}.` : 'thoughts.'}
          </h1>
          <p className="text-ink/50 text-sm font-medium">
            {isLogin ? 'Welcome back.' : 'Create your private space.'}
          </p>
        </div>

        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          {!isLogin && !initialName && (
            <div className="space-y-1">
              <input
                type="text"
                placeholder="Your Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full bg-white/50 border border-black/5 rounded-2xl px-4 py-3 outline-none focus:bg-white/80 transition-all text-ink placeholder:text-ink/30"
                required
              />
            </div>
          )}
          
          <div className="space-y-1">
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-white/50 border border-black/5 rounded-2xl px-4 py-3 outline-none focus:bg-white/80 transition-all text-ink placeholder:text-ink/30"
              required
            />
          </div>

          <div className="space-y-1">
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-white/50 border border-black/5 rounded-2xl px-4 py-3 outline-none focus:bg-white/80 transition-all text-ink placeholder:text-ink/30"
              required
            />
          </div>

          {error && (
            <div className="text-red-500 text-xs text-center font-medium mt-1">
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="
              mt-4 w-full py-4 
              bg-ink text-paper 
              font-bold rounded-2xl 
              shadow-lg active:scale-95 transition-transform duration-200
              disabled:opacity-50 relative overflow-hidden group
            "
          >
            <span className="relative z-10">{loading ? 'Processing...' : (isLogin ? 'Sign In' : 'Create Account')}</span>
            <div className="absolute inset-0 bg-gradient-to-tr from-white/20 to-transparent pointer-events-none" />
          </button>
        </form>

        <div className="mt-6 text-center">
          <button
            onClick={() => {
              setIsLogin(!isLogin);
              setError('');
            }}
            className="text-xs font-semibold text-ink/40 hover:text-ink/80 transition-colors"
          >
            {isLogin ? "New here? Create account" : "Already have an account? Sign in"}
          </button>
        </div>
      </div>
    </div>
  );
};