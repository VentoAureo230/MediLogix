import { HttpException, HttpStatus, Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaService } from 'src/services';
import { CreateUserDto } from '../user/dto/create-user.dto';
import { PasswordService } from 'src/services/password.service';
import { JwtService } from 'src/services/jwt.service';
import { enum_hospital_role } from '@prisma/client';

@Injectable()
export class AuthenticationService implements OnModuleInit {
  constructor(
    private prisma: PrismaService,
    private readonly passwordService: PasswordService,
    private jwtService: JwtService
  ) { }

  async onModuleInit() {
    const admin = await this.prisma.user.findFirst({
      where: {
        email: 'ios@ios.fr'
      }
    });
    if(!admin) {
      await this.createAdminAccount();
    }
  }

  async createUser(createUserDto: CreateUserDto) {
    const res = await this.prisma.user.create({
      data: {
        email: createUserDto.email,
        password: createUserDto.password,
        role: createUserDto.role
      }
    });
    return res;
  }

  async login(email: string, password: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        email
      }
    });
    if(!user) {
      return { message: 'User not found' }
    }

    const isPasswordValid = await this.passwordService.checkHash(password, user.password);
    if(!isPasswordValid) {
      throw new HttpException('Invalid password', HttpStatus.BAD_REQUEST);
    }

    // this one also returns the user object with the token
    // const accessToken = this.jwtService.generateToken(user.id);
    // const userWithToken = {
    //   ...user,
    //   token: accessToken
    // };
    // return userWithToken;

    const accessToken = this.jwtService.generateToken(user.id);
    return accessToken;
  }

  async createAdminAccount() {
    const hashedPassword = await this.passwordService.hashPassword('Password1&');
    const admin = await this.prisma.user.create({
      data: {
        email: 'ios@ios.fr',
        password: hashedPassword,
        role: enum_hospital_role.Admin
      }
    });
    console.log('Admin account created', admin);
    return admin;
  }
}
