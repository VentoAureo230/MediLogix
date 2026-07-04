import { Controller, Get, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuardService } from 'src/services/auth-guard.service';

@ApiTags('user')
@ApiBearerAuth()
@UseGuards(AuthGuardService)
@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @Get('users')
  @ApiOperation({ summary: 'Get all user' })
  async getAllUser() {
    console.log('get all user');
    return await this.userService.getAllUser();
  }
}
