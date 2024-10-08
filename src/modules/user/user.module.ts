import { Module } from "@nestjs/common";
import { ConfigService, PrismaService } from "src/services";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";

@Module({
    providers: [
        ConfigService,
        UserController,
        UserService,
        PrismaService
    ],
})
export class UserModule {}