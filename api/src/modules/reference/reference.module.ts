import { Module } from '@nestjs/common';
import { PrismaService } from '../../services';
import { ConfigService } from '../../services';
import { ReferenceController } from './reference.controller';
import { ReferenceService } from './reference.service';
import { NotificationService } from 'src/services/notification.service';
import { NotificationGateway } from 'src/services/notification.gateway';
import { AuthGuardService } from 'src/services/auth-guard.service';

@Module({
  controllers: [ReferenceController],
  providers: [
    ConfigService,
    ReferenceController,
    ReferenceService,
    PrismaService,
    NotificationService,
    NotificationGateway,
    AuthGuardService,
  ],
})
export class ReferenceModule {}
