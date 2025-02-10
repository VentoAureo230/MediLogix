import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user.module';
import { AuthenticationModule } from './modules/authentication/authentication.module';
import { InfoModule } from './modules/info/info.module';

@Module({
  imports: [
    AuthenticationModule,
    UserModule,
    InfoModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule { }
