import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrderService } from './order.service';
import { AuthGuardService } from 'src/services/auth-guard.service';

@ApiTags('order')
@ApiBearerAuth()
@UseGuards(AuthGuardService)
@Controller('order')
export class OrderController {
  constructor(private orderService: OrderService) {}

  @Get()
  @ApiOperation({
    summary:
      'Get all orders (ordered by status: New > Ongoing > Ready > Cancelled)',
  })
  async findAll() {
    return await this.orderService.findAll();
  }
}
