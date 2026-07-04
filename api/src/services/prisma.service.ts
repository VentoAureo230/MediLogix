import {
  Injectable,
  OnModuleDestroy,
  OnModuleInit,
  Logger,
} from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

/**
 * Prisma service with optimized connection pooling for healthcare data security
 * Implements singleton pattern to prevent connection pool exhaustion
 */
@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  private static instance: PrismaService;
  private readonly logger = new Logger(PrismaService.name);
  private pool: Pool;

  constructor() {
    // Prevent multiple instances
    if (PrismaService.instance) {
      return PrismaService.instance;
    }

    // Configure connection pool for GCP Cloud SQL
    const pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      max: 10, // Maximum connections in pool
      idleTimeoutMillis: 30000, // Close idle connections after 30s
      connectionTimeoutMillis: 60000, // Connection timeout 60s (cold start via VPC can take 20-30s)
      maxUses: 7500, // Close connection after 7500 uses
      ssl:
        process.env.DATABASE_URL?.includes('sslmode=disable') ||
        process.env.NODE_ENV === 'local'
          ? false
          : {
              rejectUnauthorized: false, // Accept self-signed certificates from Cloud SQL
              checkServerIdentity: () => undefined, // Skip server identity verification
            },
    });

    const adapter = new PrismaPg(pool);

    super({
      adapter,
      log: [
        { level: 'warn', emit: 'event' },
        { level: 'error', emit: 'event' },
      ],
    });

    this.pool = pool;
    PrismaService.instance = this;
  }

  async onModuleInit() {
    this.logger.log('Connecting to database...');

    // Log connection events for monitoring
    this.$on('warn' as never, (e: any) => {
      this.logger.warn(e);
    });

    this.$on('error' as never, (e: any) => {
      this.logger.error(e);
    });

    await this.$connect();
    this.logger.log('Database connected successfully');
    this.logger.log('Pool stats: ' + JSON.stringify(this.getPoolStats()));
  }

  async onModuleDestroy() {
    this.logger.log('Disconnecting from database...');
    await this.$disconnect();
    await this.pool.end();
    this.logger.log('Database disconnected');
  }

  /**
   * Get current pool statistics for monitoring
   */
  getPoolStats() {
    return {
      totalCount: this.pool.totalCount,
      idleCount: this.pool.idleCount,
      waitingCount: this.pool.waitingCount,
    };
  }
}
