import { Injectable } from "@nestjs/common";
import { CreateUserDto } from "./model/dto/create-user.dto";
import { PrismaService } from "../../services";

@Injectable()
export class UserService {
    constructor(private prisma: PrismaService) { }

    async createUser(createUserDto: CreateUserDto) {
        const res = await this.prisma.user.create({
            data: {
                email: createUserDto.email,
                password: createUserDto.password,
                firstName: createUserDto.firstName,
                lastName: createUserDto.lastName,
                level: 'user'
            }
        });
        return res;
    }

    async findOneByEmail(email: string) {
        return this.prisma.user.findUnique({
          where: {
            email,
          },
        });
      }

    async getAllUser() {
        return await this.prisma.user.findMany();
    }
}