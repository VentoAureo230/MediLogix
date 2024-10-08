import { Body, Controller, Get, Post } from "@nestjs/common";
import { UserService } from "./user.service";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { CreateUserDto } from "./model/dto/create-user.dto";

@ApiTags('user')
@Controller('user')
export class UserController {
    constructor(private userService: UserService) { }

    @Post()
    @ApiOperation({ summary: 'Create user' })
    async createUser(@Body() createUserDto: CreateUserDto) {
        return await this.userService.createUser(createUserDto);
    }

    @Get('users')
    @ApiOperation({ summary: 'Get all user' })
    async getAllUser() {
        console.log('get all user');
        return await this.userService.getAllUser();
    }

}