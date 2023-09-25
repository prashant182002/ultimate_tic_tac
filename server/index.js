    //import modules
    const express=require("express")
    const app=express();
    const http=require("http");
    const port=process.env.PORT |3000;
    const mongoose=require("mongoose");
    const Store=require('./models/storage.js');
    var server=http.createServer(app);
    const io=require("socket.io")(server);
    const Room=require('./models/room.js')
    //var socketio =require("socket.io");
    //var io =socketio(server);
    //client -> middleware ->server
    //middleware
    app.use(express.json);
    const DB="mongodb+srv://prashant182002:red123@cluster0.oqpgycj.mongodb.net/?retryWrites=true&w=majority";

    io.on("connection", function(socket){
//        console.log("C.....................");
        socket.on('createRoom',async ({nickname})=>{
        try{
          console.log(nickname);
//          console.log(socket.id);
          //create a room
          let room =new Room();
          let player={
              socketID:socket.id,
              nickname,
              playerType:'X',
          };
          room.players.push(player);
          room.turn=player;
          room=await room.save();
//          console.log(room);
          //room with room id
          const roomId=room._id.toString();
          socket.join(roomId);
          //io ->send data to everyone
          //socket->sending data to yourself
          io.to(roomId).emit('createRoomSuccess',room);
        }
        catch(e){
            console.log(e);
        }
        });
        socket.on('joinRoom',async ({nickname,roomId}) =>{
            console.log(nickname);
            try{
                if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
                    console.log('error');
                    socket.emit('errorOccurred', 'Please enter a valid room ID.');
                    return;
                }

                let room=await Room.findById(roomId);
                if(room.isJoin){
                    let player = {
                        nickname,
                        socketID:socket.id,
                        playerType:'O'
                    }
                    socket.join(roomId);
                    room.players.push(player);
                    room.isJoin=false;
                    room=await room.save();
                    io.to(roomId).emit('joinRoomSuccess',room);
                    io.to(roomId).emit('updatePlayers',room.players);
                    io.to(roomId).emit('updateRoom',room);
                }else{
                    socket.emit('errorOccurred',
                    'The game is in progress, try again later');
                }
            }catch(e){
                console.log(e);
            }
        });
        socket.on('tap', async({mainBoard,localBoard,roomId})=>{
            if(boards[mainBoard][localBoard]==''){
            try{
                let room=await Room.findById(roomId);
                let choice=room.turn.playerType;//x or o
                if(choice=='X')
                    Store.boards[mainBoard][localBoard]=1;
                else
                    Store.boards[mainBoard][localBoard]=-1;
                if(room.turnIndex==0){
                    room.turn=room.players[1];
                    room.turnIndex=1;
                }else{
                    room.turn=room.players[0];
                    room.turnIndex=0;
                }
                room =await room.save();
                var result=Store.checkWinCondition(boards[mainBoard]);
                bool conquered=false;
                bool Won=false;
                if(result!=0){
                    Store.mainBoard[mainBoard]=result;
                    conquered=true;
                }
                if(Store.checkWinCondition(mainBoard)!=0){
                    Won=true;
                }
                io.to(roomId).emit('tapped',{
                    mainBoard,
                    localBoard,
                    choice,
                    room,
                    conquered,
                    Won,

                })
            }
            catch(e){
                console.log(e);
            }}
        })
    });
    //Promise in js = Future of dart
    mongoose.connect(DB).then(()=>{
        console.log('Connection Succesful')
    }).catch((e)=>{
        console.log(e);
    });
    server.listen(port,'0.0.0.0',()=>{
        console.log(`server has started ${port} `);
    });