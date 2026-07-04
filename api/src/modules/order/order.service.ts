import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { enum_order_status } from '@prisma/client';
import { PrismaService } from '../../services';

@Injectable()
export class OrderService {
  constructor(private prisma: PrismaService) {}

  async updateStatus(id: number, status: enum_order_status) {
    if (isNaN(id)) {
      throw new HttpException('Invalid order id', HttpStatus.BAD_REQUEST);
    }
    if (!Object.values(enum_order_status).includes(status)) {
      throw new HttpException(
        `Invalid status. Allowed: ${Object.values(enum_order_status).join(', ')}`,
        HttpStatus.BAD_REQUEST,
      );
    }
    const order = await this.prisma.order.findUnique({ where: { id } });
    if (!order) {
      throw new HttpException(
        `Order ${id} not found`,
        HttpStatus.NOT_FOUND,
      );
    }
    return await this.prisma.order.update({
      where: { id },
      data: { status, updated_at: new Date() },
    });
  }

  // Postgres sorts enum columns by their declaration order, which is
  // New < Ongoing < Ready < Cancelled — exactly the wanted order.
  async findAll() {
    return await this.prisma.order.findMany({
      orderBy: [{ status: 'asc' }, { created_at: 'desc' }],
      include: {
        user: { select: { id: true, email: true, role: true } },
        references: {
          select: {
            quantity: true,
            reference: { select: { id: true, name: true, cip13: true } },
          },
        },
      },
    });
  }
}
