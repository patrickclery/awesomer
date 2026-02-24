import { Module } from '@nestjs/common';
import AdminJS from 'adminjs';
import { Database, Resource, getModelByName } from '@adminjs/prisma';
import * as PrismaModule from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';

AdminJS.registerAdapter({ Database, Resource });

@Module({
  imports: [
    import('@adminjs/nestjs').then(({ AdminModule }) =>
      AdminModule.createAdminAsync({
        inject: [PrismaService],
        useFactory: (prisma: PrismaService) => {
          const modelNames = [
            'AwesomeList',
            'Category',
            'CategoryItem',
            'Repo',
            'StarSnapshot',
            'FeaturedProfile',
            'NewsletterSubscriber',
            'NewsletterIssue',
            'Tag',
            'SyncRun',
          ];

          const resources = modelNames.map((name) => ({
            resource: {
              model: getModelByName(name, PrismaModule),
              client: prisma,
              clientModule: PrismaModule,
            },
            options: {
              ...(name === 'StarSnapshot'
                ? { sort: { sortBy: 'snapshotDate', direction: 'desc' as const } }
                : {}),
              ...(name === 'SyncRun'
                ? { sort: { sortBy: 'startedAt', direction: 'desc' as const } }
                : {}),
            },
          }));

          return {
            adminJsOptions: {
              rootPath: '/admin',
              branding: {
                companyName: 'Awesomer',
                logo: false,
                withMadeWithLove: false,
              },
              resources,
            },
            auth: {
              authenticate: async (email: string, password: string) => {
                const adminEmail = process.env.ADMIN_EMAIL || 'admin@awesomer.dev';
                const adminPassword = process.env.ADMIN_PASSWORD || 'changeme';
                if (email === adminEmail && password === adminPassword) {
                  return { email };
                }
                return null;
              },
              cookieName: 'adminjs',
              cookiePassword:
                process.env.ADMIN_COOKIE_SECRET ||
                'awesomer-admin-secret-key-change-me-in-prod-32chars',
            },
            sessionOptions: {
              resave: false,
              saveUninitialized: false,
              secret:
                process.env.ADMIN_SESSION_SECRET ||
                'awesomer-session-secret-key-change-me-in-prod',
            },
          };
        },
      }),
    ),
  ],
})
export class AdminModule {}
