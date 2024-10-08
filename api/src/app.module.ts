import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user.module';
import { MedicationModule } from './modules/medication/medication.module';
import { AuthentificationModule } from './modules/authentification/authentification.module';

@Module({
  imports: [
    AuthentificationModule,
    UserModule,
    MedicationModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule { }
