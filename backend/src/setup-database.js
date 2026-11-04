import { database, initializeDatabase } from './lib/database.js';

initializeDatabase();
console.log('SQLite database and demo data are ready.');
database.close();
