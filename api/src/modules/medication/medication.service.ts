import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/services";

@Injectable()
export class MedicationService {
    constructor(private prisma: PrismaService) { }

    async getMedications() {
        return this.prisma.medications.findMany();
    }


    // Here we are creating a new medication in the database
    // This would be based on cip code to add a new medication or update an existing one
    // Here we only emit a notification to PostgreSQL to notify client applications
    async createMedication(data: any) {
        const newMedication = await this.prisma.medications.create({
            data,
        });

        // Notification are not supported nativly in Prisma so we use a raw query
        await this.prisma.$executeRawUnsafe(`
          NOTIFY new_notification, '${JSON.stringify(newMedication)}'
        `);

        return newMedication;
    }
}