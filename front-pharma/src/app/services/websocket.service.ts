import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class WebSocketService {
  private socket?: WebSocket;
  private listeners = new Set<(data: any) => void>();

  private connect(): void {
    if (
      this.socket &&
      (this.socket.readyState === WebSocket.OPEN ||
        this.socket.readyState === WebSocket.CONNECTING)
    ) {
      return;
    }

    const url = environment.api.url.replace(/^http/, 'ws');
    this.socket = new WebSocket(url);

    this.socket.onmessage = (event) => {
      try {
        const message = JSON.parse(event.data);
        if (message.type === 'newMedication') {
          this.listeners.forEach((cb) => cb(message.data));
        }
      } catch (error) {
        console.error('WebSocket parse error:', error);
      }
    };
  }

  /**
   * Subscribe to `newMedication` events. Returns an unsubscribe function that
   * removes only this listener — the shared socket stays open for others.
   */
  onNewMedication(callback: (data: any) => void): () => void {
    this.connect();
    this.listeners.add(callback);
    return () => this.listeners.delete(callback);
  }
}
