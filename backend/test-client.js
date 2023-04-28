const io = require('socket.io-client');

PORT = 4200;
const socket = io.connect('http://localhost:' + PORT);
//const socket = io.connect('http://muliniavento87.ignorelist.com:' + PORT);


process.stdin.on('data', function (data) {
    // Invia il messaggio al server tramite la connessione Socket.IO
    // id evento "chat message"
    socket.emit('msg-client-2-server', data.toString().trim());
});

socket.on('msg-server-2-client', function (data) {
    console.log("Server: " + data);
});

socket.on('test-message', function (data) {
    console.log(data);
});

function onConnect() {
    console.log('Connesso al server.');

    socket.emit('test-message', 'Hello, server!', (response) => {
        console.log('Server response:', response);
    });

    // Invia il nome utente al server per registrare il client
    //socket.emit('register', username);
}

// Registra il client sul server
socket.on('connect', onConnect);