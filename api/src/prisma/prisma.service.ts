import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '../../generated/prisma/client.js';

// Prisma 7 requires options arg for `new PrismaClient(options)`.
// We cast to work around the strict constructor type while still extending.
const BasePrismaClient = PrismaClient as unknown as new () => PrismaClient;

@Injectable()
export class PrismaService
  extends BasePrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
