import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/services';
import { CreateUserDto } from '../user/dto/create-user.dto';
import { PasswordService } from 'src/services/password.service';
import { JwtService } from 'src/services/jwt.service';

@Injectable()
export class AuthenticationService {
  constructor(
    private prisma: PrismaService,
    private readonly passwordService: PasswordService,
    private jwtService: JwtService
  ) { }

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

  findAll() {
    return `This action returns all authentication`;
  }

  findOne(id: number) {
    return `This action returns a #${id} authentication`;
  }

  remove(id: number) {
    return `This action removes a #${id} authentication`;
  }
}
