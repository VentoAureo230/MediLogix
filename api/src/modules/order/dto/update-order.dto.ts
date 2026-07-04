import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { enum_order_status } from '@prisma/client';

export class UpdateOrderDto {
  @ApiProperty({ enum: enum_order_status })
  @IsEnum(enum_order_status)
  status: enum_order_status;
}
