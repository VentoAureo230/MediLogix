import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, HttpException, HttpStatus } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import { JwtPayload } from 'jsonwebtoken';
import { ConfigService } from './config.service';
import { PrismaService } from './prisma.service';
import { enum_hospital_role } from '@prisma/client';

@Injectable()
export class AuthGuardService implements CanActivate {
  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) { }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers['authorization'];

    if (!authHeader) {
      throw new UnauthorizedException('Authorization header missing');
    }

    const token = authHeader.split(' ')[1];
    const decodedToken = await this.validateToken(token);

    if (!decodedToken || typeof decodedToken === 'string' || !decodedToken.userId) {
      throw new UnauthorizedException('Invalid token or userId missing');
    }

    // Assigner le `userId` au request pour accès dans le contrôleur
    request['userId'] = decodedToken.userId;
    return true;
  }

  async validateToken(token: string): Promise<JwtPayload | string> {
    try {
      return jwt.verify(token, this.configService.jwtPublicKey, {
        algorithms: ['RS256'],
      });
    } catch (err) {
      console.error('Token validation error:', err.message);
      if (err.name === 'TokenExpiredError') {
        throw new HttpException('Token expired', HttpStatus.UNAUTHORIZED);
      } else {
        throw new HttpException('Invalid token', HttpStatus.UNAUTHORIZED);
      }
    }
  }

  // Could be used to validate specific user roles
  //async validateUser(id: number): Promise<void> {
  //  const user = await this.prisma.user.findFirst({
  //    where: { id },
  //    select: {
  //      email: true,
  //      role: true,
  //    },
  //  });
  //
  //  if (!user || !['Admin', 'Doctor', 'Pharmacist'].includes(user.role)) {
  //    throw new UnauthorizedException('User not authorized');
  //  }
  //}

  // Example of a function to validate an admin user
  async validateAdmin(userId: string): Promise<void> {
    const user = await this.prisma.user.findFirst({
      where: {  },
      select: {
        email: true,
        role: true,
      },
    });
    
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    if (user.role !== enum_hospital_role.Admin) {
      throw new UnauthorizedException('Unauthorized');
    }
  }
}