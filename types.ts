export interface Note {
  id: string;
  userId: string;
  content: string;
  notebookId: string | null; // null means "Uncategorized" or "Quick Note"
  createdAt: number;
  updatedAt: number;
}

export interface Notebook {
  id: string;
  userId: string;
  name: string;
  createdAt: number;
}

export interface User {
  id: string;
  email: string;
  passwordHash: string; // In a real app, this would be salted and hashed properly
  name: string;
}

export type ViewState = 
  | { type: 'home' }
  | { type: 'notebook', notebookId: string }
  | { type: 'editor', noteId: string | null, notebookId: string | null }; // noteId null means new note