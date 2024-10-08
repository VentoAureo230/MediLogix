import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user.module';
import { MedicationModule } from './modules/medication/medication.module';

@Module({
  imports: [
    UserModule,
    MedicationModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
