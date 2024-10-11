import { Controller, Get, Post } from "@nestjs/common";
import { MedicationService } from "./medication.service";

@Controller('medication')
export class MedicationController {
    constructor(private medication: MedicationService) {}

    @Get()
    async getMedications() {
        return await this.medication.getMedications();
    }

    // This query is meant to be used by pharmacists to add a new medication to the database
    // They would add a medication with a bar code scanner
    @Post()
    async createMedication(data: any) {
        return await this.medication.createMedication(data);
    }
    
}