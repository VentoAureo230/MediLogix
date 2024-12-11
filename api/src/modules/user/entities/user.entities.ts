import { ApiProperty } from "@nestjs/swagger";
import { enum_hospital_role } from "@prisma/client";

export class UserModel {
    @ApiProperty({ example: "1AbC3", description: "The id of the user" })
    userId: number;

    @ApiProperty({ example: "john@doe.com", description: "The email of the user" })
    email: string;

    @ApiProperty({ example: "password", description: "The password of the user" })
    password: string;

    @ApiProperty({ example: "user", description: "The level of the user" })
    role: enum_hospital_role;

    @ApiProperty({ example: "2021-09-01T00:00:00.000Z", description: "The date the user was created" })
    createdAt: Date;
    
    @ApiProperty({ example: "2021-09-01T00:00:00.000Z", description: "The date the user was last updated" })
    updatedAt: Date;
}