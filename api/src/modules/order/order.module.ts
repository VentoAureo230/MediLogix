import { Module } from '@nestjs/common';
import { ConfigService, PrismaService } from '../../services';
import { OrderController } from './order.controller';
import { OrderService } from './order.service';
import { AuthGuardService } from 'src/services/auth-guard.service';

@Module({
  controllers: [OrderController],
  providers: [OrderService, PrismaService, ConfigService, AuthGuardService],
})
export class OrderModule {}
