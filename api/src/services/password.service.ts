import { HttpException, HttpStatus } from '@nestjs/common';
import * as argon2 from 'argon2';

export class PasswordService {
  async hashPassword(password: string): Promise<string> {
    try {
      return await argon2.hash(password);
    } catch (err) {
      console.log('err', err);
      throw new HttpException(
        'Cannot hash password',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async checkHash(hash: string, password: string): Promise<boolean> {
    try {
      return await argon2.verify(hash, password);
    } catch (err) {
      console.log('err', err);
      throw new HttpException(
        'Cannot hash password',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}