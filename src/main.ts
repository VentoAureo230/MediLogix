import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv'
import { ConfigService } from './services/config.service';

async function bootstrap() {
  dotenv.config() 
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
  const configService = app.get(ConfigService);
  app.enableCors({
    origin: configService.corsOrigin,
    allowedHeaders: [
      'Access-Control-Allow-Origin',
      'Origin',
      'X-Requested-With',
      'Accept',
      'Content-Type',
      'Authorization',
    ],
    exposedHeaders: 'Authorization',
    credentials: true,
    methods: ['GET', 'PUT', 'OPTIONS', 'POST', 'DELETE'],
  });
  console.log(`Application is running on: ${await app.getUrl()}`);
}
bootstrap();
