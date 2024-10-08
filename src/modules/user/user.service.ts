import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/services";

@Injectable()
export class UserService {
    constructor(private prisma: PrismaService) { }

    async createUser(email: string, password: string, firstName: string, lastName: string) {
        const res = await this.prisma.user.create({
            data: {
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                level: 'user'
            }
        });
        return res;
    }
}