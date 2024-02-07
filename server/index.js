    //import modules
    const express=require("express")
    const app=express();
    const http=require("http");
    const port=process.env.PORT |3000;
    const mongoose=require("mongoose");
    var checkWinCondition =require('./models/storage.js').checkWinCondition;
    var setGame =require('./models/engine.js').setGame;
    var server=http.createServer(app);
    const io=require("socket.io")(server);
    const Room=require('./models/room.js')
    const { spawn } = require('child_process');
    const fs = require('fs');
    //var socketio =require("socket.io");
    //var io =socketio(server);
    //client -> middleware ->server
    //middleware
    app.use(express.json);
    function pythonSpawn(board,boardToPlayOn){
    return new Promise((resolve, reject) => {
    for(var i=0;i<9;i++){
        for(var j=0;j<9;j++){
            if(board[i][j]==''){
             board[i][j]=" ";
            }
        }
    }
//    console.log(board)
        const boardString = JSON.stringify(board);
        const boardToPlayOnString= JSON.stringify(boardToPlayOn);
//        console.log(boardString);
        pythonProcess = spawn(
              'C:\\Users\\pranky\\android\\tic_tac\\server\\ml\\env\\Scripts\\python.exe',
              ['C:\\Users\\pranky\\android\\tic_tac\\server\\ml\\comp_vs_human.py',boardString,boardToPlayOnString],
              {
                // Set the working directory to the virtual environment
                cwd: 'C:\\Users\\pranky\\android\\tic_tac\\server\\ml\\env',
                // Activate the virtual environment
                shell: true,
                env: {
                  ...process.env,
                  PATH: 'C:\\Users\\pranky\\android\\tic_tac\\server\\ml\\env\\Scripts\\activate.bat',
                },
              }
            );
            var ans='';
            var main;
            var local;
            console.log('inside');
                pythonProcess.stdout.on('data', (data) => {
//                    console.log('datadata')
//                  console.log(data.toString())
                  ans+=data.toString();
                  main=Number(ans[1]);
                  local=Number(ans[4]);
                   resolve({ main, local });
                });
                });
                 pythonProcess.on('close', (code) => {
                      console.log(`Python process exited with code ${code}`);
                      // Handle any final logic or error checks before resolving the promise
                    });
    }
    const DB="mongodb+srv://prashant182002:red123@cluster0.oqpgycj.mongodb.net/?retryWrites=true&w=majority";
    io.on("connection", function(socket){
        console.log("connected");
        socket.on('createRoom',async ({nickname,AI})=>{
        console.log('created');
        try{
          let room =new Room();
          room.lastActivity = new Date();
          let player={
              socketID:socket.id,
              nickname,
              playerType:'X',
          };
          console.log(socket.id);
          room.players.push(player);
          room.turn=player;
          room=await room.save()
          console.log(room);
          //room with room id
          const roomId=room._id.toString();
          socket.join(roomId);
          //io ->send data to everyone
          //socket->sending data to yourself
          io.to(roomId).emit('createRoomSuccess',{room,AI});
//          console.log('wojwfakjbsdn;afk');
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
                room.lastActivity = new Date();
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
        socket.on('tap', async({mainBoard,localBoard,roomId,board,wholeBoard})=>{
            if(board[mainBoard][localBoard]==''){
            try{
                let room=await Room.findById(roomId);
                room.lastActivity = new Date();
                let choice=room.turn.playerType;//x or o
                board[mainBoard][localBoard]=choice;
                if(room.turnIndex==0){
                    room.turn=room.players[1];
                    room.turnIndex=1;
                }else{
                    room.turn=room.players[0];
                    room.turnIndex=0;
                }
                room =await room.save();
                var result=checkWinCondition(board[mainBoard]);
                var Winner='N';
                if(result==1)
                    wholeBoard[mainBoard]='X';
                else if(result==-1)
                    wholeBoard[mainBoard]='O';
                if(checkWinCondition(wholeBoard)==1){
                    console.log('is there any winner?????????????????????????')
                    console.log('X');
//                    console.log(choice)
                    Winner='X';
                  }
                 else if(checkWinCondition(wholeBoard)==-1){
                    console.log('is there any winner?????????????????????????')
                    console.log('0');
                   Winner='0';
                 }
                var boardToPlayOn=-1;
                if(wholeBoard[localBoard]==''){
                    boardToPlayOn=localBoard;
                }
                var countw = 0;
                for(var bt = 0; bt < 9; bt++){
                    if(mainBoard[bt]==''){
                        for(var lt=0;lt<9;lt++){
                            if(board[bt][lt]=='') countw++;
                        }
                    }
                }
                if(countw === 0){
                    Winner="D";
                }
                io.to(roomId).emit('tapped',{
                    board,
                    wholeBoard,
                    room,
                    Winner,
                    boardToPlayOn
                })
            }
            catch(e){
                console.log(e);
            }}
        })
        socket.on('check', async({mainBoard,localBoard,board,wholeBoard,choice,roomId,moves,AI,AItype})=>{
            console.log('checking??')
//            console.log(AI)
            if(board[mainBoard][localBoard]===''){
            try{
                let room=await Room.findById(roomId);
                room.lastActivity = new Date();
                board[mainBoard][localBoard]=choice;
                var result=checkWinCondition(board[mainBoard]);
                var Winner='N';
                if(result===1)
                    wholeBoard[mainBoard]='X';
                else if(result===-1)
                    wholeBoard[mainBoard]='O';
                if(checkWinCondition(wholeBoard)==1){
                    console.log('is there any winner?????????????????????????')
                    console.log('X');
//                    console.log(choice)
                    Winner='X';
                }
                else if(checkWinCondition(wholeBoard)==-1){
                    console.log('is there any winner?????????????????????????')
                    console.log('0');
//                  console.log(choice)
                    Winner='0';
                }
                var boardToPlayOn=-1;
                if(wholeBoard[localBoard]===''){
                    boardToPlayOn=localBoard;
                }
                var countw = 0;
                for(var bt = 0; bt < 9; bt++){
                    if(wholeBoard[bt]===''){
                        for(var lt = 0; lt < 9; lt++){
                            if(board[bt][lt]==='') countw++;
                        }
                    }
                }
                if(countw === 0){
                    Winner="D";
                }
                Winner=Winner.toString();
                io.to(roomId).emit('checked',{
                    board,
                    wholeBoard,
                    room,
                    Winner,
                    boardToPlayOn,
                    AI,
                    AItype
                })
                if(AI===0 && AItype===1)
                {
                    var ans=setGame(board,wholeBoard,boardToPlayOn,moves);
                    var local=ans.bestMove;
                    var main=ans.currentBoard;
                    try{
                        io.to(roomId).emit('AIres',{
                            main,local
                        })
                    }
                    catch(e){
                        console.log(e);
                    }
                }
                if(AI===0 && AItype===2)
                {
                    var main;
                    var local;
                    console.log("Alpha");
                    var ans='';
                    try{
                        (async () => {
                          try {
                            const result = await pythonSpawn(board, boardToPlayOn);
                            console.log(result.main);
                            main=result.main
                            console.log(result.local);
                            local=result.local
                          } catch (error) {
                            console.error('Error:', error);
                          }
                          io.to(roomId).emit('AIres',{
                              main,local
                          })
                        })();

                    }
                    catch(e){
                        console.log(e);
                    }
                }
            }
            catch(e){
                console.log(e);
            }}
        });
    });


    function deleteInactiveRooms() {
      const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000); // 1 hour ago

      Room.deleteMany({ lastActivity: { $lt: oneHourAgo } });
    }
    setInterval(deleteInactiveRooms, 1000 * 60 * 15);


    //Promise in js = Future of dart
    mongoose.connect(DB).then(()=>{
        console.log('Connection Succesful')
    }).catch((e)=>{
        console.log(e);
    });
    server.listen(port,'0.0.0.0',()=>{
        console.log(`server has started ${port} `);
    });
    var board =
        [   [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," ","X"," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "],
            [" "," "," "," "," "," "," "," "," "]
          ];

    var boardToPlayOn =4;

