import { Injectable } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import { ConfigService } from './config.service';

@Injectable()
export class JwtService {
  constructor(private configService: ConfigService) {}

  async generateToken(userId: number): Promise<string> {
    const privateKey = {
      key: this.configService.jwtPrivateKey,
      //passphrase: this.configService.jwtPassphrase,
    };
    const options: jwt.SignOptions = {
      expiresIn: this.configService
        .jwtExpiresIn as jwt.SignOptions['expiresIn'],
      algorithm: 'RS256',
    };
    return jwt.sign({ userId }, privateKey, options);
  }

  async generateRefreshToken(userId: string) {
    //const refreshTokenSecret = this.configService.jwtRefreshTokenSecret;
    //return jwt.sign({ userId }, refreshTokenSecret, {
    //  expiresIn: this.configService.jwtRefreshTokenExpiresIn, // Par exemple 7 jours
    //});
  }

  async verifyRefreshToken(token: string): Promise<any> {
    //try {
    //  const refreshTokenSecret = this.configService.jwtRefreshTokenSecret;
    //  return jwt.verify(token, refreshTokenSecret);
    //} catch (error) {
    //  throw new Error('Invalid refresh token');
    //}
  }

  async verifyAccessTokenIgnoreExpiration(token: string): Promise<any> {
    // const publicKey = this.configService.jwtPublicKey;
    // return jwt.verify(token, publicKey, { ignoreExpiration: true });
  }
}