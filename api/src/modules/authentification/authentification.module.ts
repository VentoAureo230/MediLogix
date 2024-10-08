import { Module } from "@nestjs/common";
import { AuthentificationController } from "./authentification.controller";
import { ConfigService, PrismaService } from "src/services";
import { PasswordService } from "src/services/password.service";
import { UserService } from "../user/user.service";

@Module({
    imports: [],
    controllers: [AuthentificationController],
    providers: [
        ConfigService,
        PrismaService,
        PasswordService,
        AuthentificationController,
        UserService,
    ],
})
export class AuthentificationModule {}