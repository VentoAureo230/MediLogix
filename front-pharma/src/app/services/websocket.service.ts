import { Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root'
})
export class WebSocketService {
    private socket: WebSocket;

    constructor() {
        this.socket = new WebSocket('ws://localhost:3000');

        this.socket.onopen = () => {
            console.log('WebSocket connection established');
        };

        this.socket.onclose = () => {
            console.log('WebSocket connection closed');
        };

        this.socket.onmessage = (event) => {
            console.log('Message from server:', event);
            console.log('Raw message data:', event.data);
            const message = JSON.parse(event.data);
            if (message.type === 'newMedication') {
                console.log('New medication:', message.data);
            }
        };
    }

    public onNewMedication(callback: (data: any) => void) {
        console.log('Listening for new medications');
        this.socket.addEventListener('message', (event) => {
            console.log('Received message:', event.data);
            try {
                const message = JSON.parse(event.data);
                if (message.type === 'newMedication') {
                    console.log('Callback with new medication data:', message.data);
                    callback(message.data);
                }
            } catch (error) {
                console.error('Error parsing message:', error);
            }
        });
    }

    public disconnect() {
        this.socket.close();
    }
}