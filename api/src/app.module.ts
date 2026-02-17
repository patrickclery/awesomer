import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module.js';
import { AwesomeListsModule } from './awesome-lists/awesome-lists.module.js';
import { ReposModule } from './repos/repos.module.js';
import { CategoriesModule } from './categories/categories.module.js';
import { TrendingModule } from './trending/trending.module.js';
import { FeaturedModule } from './featured/featured.module.js';
import { NewsletterModule } from './newsletter/newsletter.module.js';
import { SyncModule } from './sync/sync.module.js';
import { AdminModule } from './admin/admin.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AwesomeListsModule,
    ReposModule,
    CategoriesModule,
    TrendingModule,
    FeaturedModule,
    NewsletterModule,
    SyncModule,
    AdminModule,
  ],
})
export class AppModule {}
