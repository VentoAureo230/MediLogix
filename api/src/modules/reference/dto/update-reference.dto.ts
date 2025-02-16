import { IsInt, IsNotEmpty, Min  } from 'class-validator';

export class UpdateReferenceDto {
   @IsNotEmpty()
   @IsInt()
   @Min(1)
   quantity: number;
}