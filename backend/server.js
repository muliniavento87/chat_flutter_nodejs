const express = require('express');
const http = require('http');
const socketio = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketio(server);

PORT = 4200

io.on('connection', (socket) => {
    console.log('Un nuovo utente si è connesso.');

    // questo attiva un socket in ascolto sul server (id => "test-message")
    socket.on('test-message', (init_msg) => {
        // se sono qui dentro vuol dire che il client ha inviato
        // un msg al server sul socket (id => "test-message")
        console.log('[Client] Messaggio di test: ', init_msg);
        // questo emette un messaggio di risposta al client che
        // mi ha contattato sul socket (id => "test-message")
        io.emit('test-message', 'Hello, client! (ho ricevuto il tuo msg: ' + init_msg + ' )');
    });

    socket.on('disconnect', () => {
        console.log('Un utente si è disconnesso.');
    });

    // questo attiva un socket in ascolto sul server (id => "msg-client-2-server")
    socket.on('msg-client-2-server', (msg) => {
        console.log('Client: ', msg);
        //io.emit('msg-client-2-server', msg);
        // faccio echo a tutti i client connessi del messaggio
        // che mi è arrivato da uno dei client
        io.emit('msg-server-2-client', msg);
    });
});

server.listen(PORT, () => {
    console.log('Il server è in ascolto sulla porta ' + PORT);
});
