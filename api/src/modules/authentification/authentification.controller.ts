import { Body, Controller, HttpException, HttpStatus, Post } from "@nestjs/common";
import { LoginDto } from "./model/dto/loginDto";
import { PasswordService } from "src/services/password.service";
import { UserService } from "../user/user.service";
import { RegisterDto } from "./model/dto/registerDto";

@Controller('authentification')
export class AuthentificationController {
    constructor(
        private readonly passwordService: PasswordService,
        private readonly userService: UserService,
    ) { }

    @Post('register')
    async register(
        @Body() registerDto: RegisterDto
    ) {
        const hashedPassword = await this.passwordService.hashPassword(registerDto.password);
        const user = await this.userService.createUser({
            email: registerDto.email,
            password: hashedPassword,
            firstName: registerDto.firstName,
            lastName: registerDto.lastName,
        });
        return user;
    }

    @Post('login')
    async login(
        @Body() loginDto: LoginDto
    ) {
        const user = await this.userService.findOneByEmail(loginDto.email);
        if (!user) {
            throw new HttpException('No such user', HttpStatus.NOT_FOUND);
        }

        const isPasswordValid = await this.passwordService.checkHash(user.password, loginDto.password);
        if (!isPasswordValid) {
            throw new HttpException('Invalid password', HttpStatus.BAD_REQUEST);
        }

        return user;
    }
}