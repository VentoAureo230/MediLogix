// create-user.dto.ts
import { ApiProperty } from '@nestjs/swagger';
import { enum_hospital_role } from '@prisma/client';

export class CreateUserDto {
  @ApiProperty()
  email: string;

  @ApiProperty()
  password: string;

  @ApiProperty()
  role: enum_hospital_role;

  @ApiProperty({ required: false })
  created_at?: Date;

  @ApiProperty({ required: false })
  updated_at?: Date;
}