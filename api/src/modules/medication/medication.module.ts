import { Module } from "@nestjs/common";
import { MedicationController } from "./medication.controller";
import { MedicationService } from "./medication.service";
import { ConfigService, PrismaService } from "src/services";

@Module({
    providers: [
        MedicationController,
        MedicationService,
        ConfigService,
        PrismaService
    ],
})
export class MedicationModule {}