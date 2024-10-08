import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

let prisma: PrismaClient;

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {

    constructor() {
        if (!prisma) {
            prisma = new PrismaClient();
        }
        super();
    }

    async onModuleInit() {
        this.$use(async (params, next) => {
            await this.$connect();
            try {
                //console.log('Connecting to database');
                const result = await next(params);
                return result;
            } catch (error) {
                console.error('Database query error:', error);
                throw error;
            } finally {
                //console.log('Disconnecting from database');
                await this.$disconnect();
            }
        });
    }

    async onModuleDestroy() {
        await this.$disconnect();
    }
}