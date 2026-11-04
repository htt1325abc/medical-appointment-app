import 'dotenv/config';

import { createApp } from './app.js';
import { database } from './lib/database.js';

const port = Number(process.env.PORT ?? 3000);
const server = createApp().listen(port, '0.0.0.0', () => {
  console.log(`MediCare+ API listening on http://0.0.0.0:${port}`);
});

async function shutdown() {
  server.close();
  database.close();
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
