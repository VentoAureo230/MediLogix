import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { AuthenticationService } from './authentication.service';
import { ApiOperation, ApiHeader, ApiBody, ApiResponse } from '@nestjs/swagger';
import { CreateUserDto } from '../user/dto/create-user.dto';

@Controller('authentication')
export class AuthenticationController {
  constructor(private readonly authenticationService: AuthenticationService) { }

  @Post()
  @ApiOperation({ summary: 'Create user' })
  async createUser(@Body() createUserDto: CreateUserDto) {
    return await this.authenticationService.createUser(createUserDto);
  }

  @Post('login')
  @ApiOperation({ summary: 'Login a user', description: 'Logs in a user to the Medilogix system.' })
  @ApiHeader({ name: 'Content-Type', description: 'Content-Type header', required: true, example: 'application/json' })
  @ApiBody({
    description: 'User login data',
    schema: {
      type: 'object',
      properties: {
        email: { type: 'string', example: 'user@example.com' },
        password: { type: 'string', example: 'password123' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'User logged in successfully', schema: { example: { userId: 'uuid', token: 'jwt-token' } } })
  @ApiResponse({ status: 201, description: 'User not found' })
  @ApiResponse({ status: 400, description: 'Invalid password' })
  async login(
    @Body('email') email: string,
    @Body('password') password: string
  ) {
    return await this.authenticationService.login(email, password);
  }
}
