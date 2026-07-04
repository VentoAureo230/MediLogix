import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from '../../services';
import { CreateReferenceDto } from './dto/create-reference.dto';
import { searchReferenceInCSV } from './utils/utils';
import * as path from 'path';
import { UpdateReferenceDto } from './dto/update-reference.dto';
import { NotificationService } from 'src/services/notification.service';

@Injectable()
export class ReferenceService {
  constructor(
    private prisma: PrismaService,
    private notificationService: NotificationService,
  ) {}

  async findAll(page = 1, limit = 15) {
    const safePage = page > 0 ? page : 1;
    const safeLimit = limit > 0 ? limit : 15;
    const [data, total] = await this.prisma.$transaction([
      this.prisma.reference.findMany({
        skip: (safePage - 1) * safeLimit,
        take: safeLimit,
        orderBy: { id: 'asc' },
      }),
      this.prisma.reference.count(),
    ]);
    return { data, total, page: safePage, limit: safeLimit };
  }

  async getByCip13(cip13: string) {
    return await this.prisma.reference.findFirst({ where: { cip13 } });
  }

  async create(createReferenceDto: CreateReferenceDto) {
    if (
      await this.prisma.reference.findFirst({
        where: { cip13: createReferenceDto.cip13 },
      })
    )
      throw new HttpException(
        `Reference with CIP13 : ${createReferenceDto.cip13} is already existing`,
        HttpStatus.CONFLICT,
      );

    // TODO Move path in .env
    const foundReference = await searchReferenceInCSV(
      path.join(process.cwd(), 'data', 'medicaments.csv'),
      createReferenceDto.cip13,
    );

    if (!foundReference)
      throw new HttpException(
        `Reference with CIP13 : ${createReferenceDto.cip13} isnt existing`,
        HttpStatus.NOT_FOUND,
      );

    const reference = await this.prisma.reference.create({
      data: {
        ...foundReference,
        quantity: createReferenceDto?.quantity ?? 0,
        created_at: new Date(),
        updated_at: new Date(),
      },
    });

    this.notificationService.notifyNewMedication(reference);

    return reference;
  }

  async updateQuantity(cip13: string, updataReferenceDto: UpdateReferenceDto) {
    const reference = await this.prisma.reference.findFirst({
      where: { cip13 },
    });

    if (!reference)
      throw new HttpException(
        `Reference with CIP13 : ${cip13} doesnt exist`,
        HttpStatus.NOT_FOUND,
      );

    return await this.prisma.reference.update({
      where: { id: reference.id },
      data: {
        quantity: reference.quantity + updataReferenceDto.quantity,
        updated_at: new Date(),
      },
    });
  }
}
