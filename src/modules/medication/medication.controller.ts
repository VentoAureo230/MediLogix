import { Controller, Post } from "@nestjs/common";
import { MedicationService } from "./medication.service";

@Controller('medication')
export class MedicationController {
    constructor(private medication: MedicationService) {}

    @Post()
    async createMedication() {
        return await this.medication.createMedication();
    }
}