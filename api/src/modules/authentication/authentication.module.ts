import { Module } from '@nestjs/common';
import { AuthenticationService } from './authentication.service';
import { AuthenticationController } from './authentication.controller';
import { ConfigService, PrismaService } from 'src/services';
import { AuthGuardService } from 'src/services/auth-guard.service';
import { PasswordService } from 'src/services/password.service';
import { JwtService } from 'src/services/jwt.service';

@Module({
  controllers: [AuthenticationController],
  providers: [
    AuthenticationService,
    ConfigService,
    AuthGuardService,
    PrismaService,
    PasswordService,
    JwtService
  ],
})
export class AuthenticationModule {}
