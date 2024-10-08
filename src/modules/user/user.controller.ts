import { Controller, Get, Param, Post, Put } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('user')
export class UserController {
    constructor(private userService: UserService) {}

    @Post()
    async createUser(
        @Param('email') email: string,
        @Param('password') password: string,
        @Param('firstName') firstName: string,
        @Param('lastName') lastName: string,
    ) {
        return await this.userService.createUser(email, password, firstName, lastName);
    }

    @Post('login')
    async login() {
        return 'User logged in';
    }

    @Get()
    async getUser() {
        return 'User fetched';
    }

    @Put()
    async updateUser() {
        return 'User updated';
    }
}