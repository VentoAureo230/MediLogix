import { Module } from "@nestjs/common";
import { PrismaService } from "../../services";
import { ConfigService } from "../../services";
import { ReferenceController } from "./reference.controller";
import { ReferenceService } from "./reference.service";

@Module({
   controllers: [ReferenceController],
   providers: [
      ConfigService,
      ReferenceController,
      ReferenceService,
      PrismaService
   ],
})
export class ReferenceModule {}