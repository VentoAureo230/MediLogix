import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/services";

@Injectable()
export class MedicationService {
    constructor(private prisma: PrismaService) {}

    async createMedication() {
        //const res = await this.prisma.medication.create({
        //    data: {
        //        medicationId: '123',
        //        name: 'Paracetamol',
        //        description: 'For fever',
        //        price: 100,
        //    }});
        //return res;
    }
}