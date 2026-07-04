import { Injectable } from '@nestjs/common';
import { NotificationGateway } from 'src/services/notification.gateway';

@Injectable()
export class NotificationService {
  constructor(private readonly notificationGateway: NotificationGateway) {}

  notifyNewMedication(payload: unknown) {
    this.notificationGateway.broadcast('newMedication', payload);
  }
}
