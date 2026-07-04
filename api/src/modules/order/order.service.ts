import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../services';

@Injectable()
export class OrderService {
  constructor(private prisma: PrismaService) {}

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
