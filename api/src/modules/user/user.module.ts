import { Module } from '@nestjs/common';
import { PrismaService } from '../../services';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { ConfigService } from '../../services';
import { AuthGuardService } from 'src/services/auth-guard.service';

@Module({
  controllers: [UserController],
  providers: [
    ConfigService,
    UserController,
    UserService,
    PrismaService,
    AuthGuardService,
  ],
})
export class UserModule {}
