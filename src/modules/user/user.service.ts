import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/services";

@Injectable()
export class UserService {
    constructor(private prisma: PrismaService) {}

    async createUser() {
        const res = await this.prisma.user.create({
            data: {
                userId: '123',
                email: 'test@test.com',
                password: 'Password123',
                firstName: 'John',
                lastName: 'Doe',
                level: 'user',
            }});
        return res;
    }
}