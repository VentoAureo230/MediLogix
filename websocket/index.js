const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();
const app = express();
const httpServer = http.createServer(app);
const io = new Server(httpServer, { cors: { origin: '*' } });

const port = process.env.PORT || 5000;
const backendUrl = `${process.env.BACKEND_HOST}:${process.env.BACKEND_PORT}`;
const clients = {};

httpServer.listen(port, () => {
   console.log(`Server listening on port ${port}`);
});

app.post('/notify', (req, res) => {
    const payload = req.body;
    console.log('Received notification:', payload);
  
    io.emit('newMedication', payload);
    
    res.sendStatus(200);
  });

io.on('connection', (socket) => {
  console.log('a user connected');
});
