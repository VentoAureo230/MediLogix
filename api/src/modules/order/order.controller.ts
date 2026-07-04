import { Body, Controller, Get, Param, Patch, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrderService } from './order.service';
import { UpdateOrderDto } from './dto/update-order.dto';
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

  @Patch(':id')
  @ApiOperation({ summary: 'Update an order status' })
  async updateStatus(
    @Param('id') id: string,
    @Body() updateOrderDto: UpdateOrderDto,
  ) {
    return await this.orderService.updateStatus(
      parseInt(id, 10),
      updateOrderDto.status,
    );
  }
}
