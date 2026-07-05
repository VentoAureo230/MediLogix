import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../services';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getAllUser() {
    return await this.prisma.user.findMany();
  }
}
