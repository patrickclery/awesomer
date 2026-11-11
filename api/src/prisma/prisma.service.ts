import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '../generated/prisma/client.js';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';

// Prisma 7 client engine requires an adapter. We cast to allow extending
// while passing adapter options at runtime.
const BasePrismaClient = PrismaClient as unknown as new (
  opts: Record<string, unknown>,
) => PrismaClient;

@Injectable()
export class PrismaService
  extends BasePrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  private pool: pg.Pool;

  constructor() {
    const pool = new pg.Pool({
      connectionString: process.env.DATABASE_URL,
    });
    const adapter = new PrismaPg(pool);
    super({ adapter });
    this.pool = pool;
  }

  async onModuleInit() {
    await this.$connect();
  }

  /**
   * Tries to take a session-level Postgres advisory lock on a dedicated pool connection.
   * Returns a release function, or null when another session already holds the lock.
   * The lock lives as long as that connection: release() unlocks it and returns the
   * connection, and a crashed process drops the lock along with its connection.
   */
  async tryAdvisoryLock(key: number): Promise<(() => Promise<void>) | null> {
    const client = await this.pool.connect();
    try {
      const res = await client.query<{ locked: boolean }>('SELECT pg_try_advisory_lock($1::bigint) AS locked', [key]);
      if (!res.rows[0]?.locked) {
        client.release();
        return null;
      }
    } catch (err) {
      client.release(err as Error);
      throw err;
    }
    let released = false;
    return async () => {
      if (released) return;
      released = true;
      try {
        await client.query('SELECT pg_advisory_unlock($1::bigint)', [key]);
        client.release();
      } catch (err) {
        // Destroying the connection drops the lock with it.
        client.release(err as Error);
      }
    };
  }

  async onModuleDestroy() {
    await this.$disconnect();
    await this.pool.end();
  }
}
