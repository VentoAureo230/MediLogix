import { Controller, Get, Post, Put } from "@nestjs/common";
import { UserService } from "./user.service";

@Controller('user')
export class UserController {
    constructor(private userService: UserService) {}

    @Post()
    async createUser(
        
    ) {
        return await this.userService.createUser();
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