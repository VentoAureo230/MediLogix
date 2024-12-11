import { Module } from '@nestjs/common';
import { AuthenticationService } from './authentication.service';
import { AuthenticationController } from './authentication.controller';
import { ConfigService, PrismaService } from 'src/services';
import { AuthGuardService } from 'src/services/auth-guard.service';

@Module({
  controllers: [AuthenticationController],
  providers: [
    AuthenticationService,
    ConfigService,
    AuthGuardService,
    PrismaService,
  ],
})
export class AuthenticationModule {}
