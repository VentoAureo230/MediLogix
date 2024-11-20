import { Injectable, HttpServer } from '@nestjs/common';

@Injectable()
export class NotificationService {
  constructor(private readonly httpService: HttpServer) {}

  handleNotification(payload: any) {
    this.httpService.post('http://localhost:5000/notify', payload).subscribe({
      next: () => console.log('Notification sent to WebSocket server'),
      error: (err) => console.error('Failed to notify WebSocket server', err),
    });
  }
}