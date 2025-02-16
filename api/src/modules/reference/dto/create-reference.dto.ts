import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateReferenceDto {
   @IsNotEmpty()
   @IsString()
   cip13: string;

   @IsInt()
   quantity?: number;
}