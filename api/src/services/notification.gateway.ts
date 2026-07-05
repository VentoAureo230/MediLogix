import { Injectable } from '@nestjs/common';
import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server } from 'ws';

@Injectable()
@WebSocketGateway()
export class NotificationGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  handleConnection() {
    console.log('Client connected to notification gateway');
  }

  handleDisconnect() {
    console.log('Client disconnected from notification gateway');
  }

  broadcast(type: string, data: unknown) {
    const message = JSON.stringify({ type, data });
    this.server.clients.forEach((client) => {
      if (client.readyState === client.OPEN) {
        client.send(message);
      }
    });
  }
}
