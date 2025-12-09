import Dexie, { Table } from 'dexie';
import { Note, Notebook, User } from './types';

class ThoughtsDatabase extends Dexie {
  users!: Table<User>;
  notes!: Table<Note>;
  notebooks!: Table<Notebook>;

  constructor() {
    super('ThoughtsDB');
    (this as any).version(1).stores({
      users: 'id, email', // Primary key and indexed props
      notes: 'id, userId, notebookId, updatedAt',
      notebooks: 'id, userId, createdAt'
    });
  }
}

export const db = new ThoughtsDatabase();

// Helper to simulate network delay for realism
export const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));