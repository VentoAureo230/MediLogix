import { Module } from "@nestjs/common";
import { PrismaService } from "../../services";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";
import { ConfigService } from "../../services";

@Module({
    controllers: [UserController],
    providers: [
        ConfigService,
        UserController,
        UserService,
        PrismaService
    ],
})
export class UserModule {}