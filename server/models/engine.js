var checkWinCondition =require('./storage.js').checkWinCondition;
//var versionCode = "Alpha 0.9";
//var currentTurn = 1;
var player = 1;
var ai = -1;
var currentBoard = 4;
//
//var gameRunning = false;
//
var RUNS = 0;
//
var MOVES = 0;
//
//var switchAroo = 1;
//
//var AIACTIVE = true;
//
//var playerNames = ["PLAYER", "AI"];

// ---------------------------------------------------------- FUNCTIONS ------------------------------------------------------------------------ //

//The most important function, returns a numerical evaluation of the whole game in it's current state
function evaluateGame(position, currentBoard) {
    var evale = 0;
    var mainBd = [];
    var evaluatorMul = [1.4, 1, 1.4, 1, 1.75, 1, 1.4, 1, 1.4];
    for (var eh = 0; eh < 9; eh++){
        evale += realEvaluateSquare(position[eh])*1.5*evaluatorMul[eh];
        if(eh === currentBoard){
            evale += realEvaluateSquare(position[eh])*evaluatorMul[eh];
        }
        var tmpEv = checkWinCondition(position[eh]);
        evale -= tmpEv*evaluatorMul[eh];
        mainBd.push(tmpEv);
    }
    evale -= checkWinCondition(mainBd)*5000;
    evale += realEvaluateSquare(mainBd)*150;
    return evale;
}
//minimax algorithm
function miniMax(position, boardToPlayOn, depth, alpha, beta, maximizingPlayer) {
    RUNS++;

    var tmpPlay = -1;

    var calcEval = evaluateGame(position, boardToPlayOn);
    if(depth <= 0 || Math.abs(calcEval) > 5000) {
        return {"mE": calcEval, "tP": tmpPlay};
    }
    //If the board to play on is -1, it means you can play on any board
    if(boardToPlayOn !== -1 && checkWinCondition(position[boardToPlayOn]) !== 0){
        boardToPlayOn = -1;
    }
    //If a board is full (doesn't include 0), it also sets the board to play on to -1
    if(boardToPlayOn !== -1 && !position[boardToPlayOn].includes(0)){
        boardToPlayOn = -1;
    }

    if(maximizingPlayer){
        var maxEval = -Infinity;
        for(var mm = 0; mm < 9; mm++){
            var evalut = -Infinity;
            //If you can play on any board, you have to go through all of them
            if(boardToPlayOn === -1){
                for(var trr = 0; trr < 9; trr++){
                    //Except the ones which are won
                    if(checkWinCondition(position[mm]) === 0){
                        if(position[mm][trr] === 0){
                            position[mm][trr] = ai;
                            //tmpPlay = pickBoard(position, true);
                            evalut = miniMax(position, trr, depth-1, alpha, beta, false).mE;
                            //evalut+=150;
                            position[mm][trr] = 0;
                        }
                        if(evalut > maxEval){
                            maxEval = evalut;
                            tmpPlay = mm;
                        }
                        alpha = Math.max(alpha, evalut);
                    }

                }
                if(beta <= alpha){
                    break;
                }
            //If there's a specific board to play on, you just go through it's squares
            }else{
                if(position[boardToPlayOn][mm] === 0){
                    position[boardToPlayOn][mm] = ai;
                    evalut = miniMax(position, mm, depth-1, alpha, beta, false);
                    position[boardToPlayOn][mm] = 0;
                }
                //Beautiful variable naming
                var blop = evalut.mE;
                if(blop > maxEval){
                    maxEval = blop;
                    //Saves which board you should play on, so that this can be passed on when the AI is allowed to play in any board
                    tmpPlay = evalut.tP;
                }
                alpha = Math.max(alpha, blop);
                if(beta <= alpha){
                    break;
                }
            }
        }
        return {"mE": maxEval, "tP": tmpPlay};
    }else{
        //Same for the minimizing end
        var minEval = Infinity;
        for(var mm = 0; mm < 9; mm++){
            var evalua = Infinity;
            if(boardToPlayOn === -1){
                for(var trr = 0; trr < 9; trr++){
                    if(checkWinCondition(position[mm]) === 0){
                        if(position[mm][trr] === 0){
                            position[mm][trr] = player;
                            //tmpPlay = pickBoard(position, true);
                            evalua = miniMax(position, trr, depth-1, alpha, beta, true).mE;
                            //evalua -= 150;
                            position[mm][trr] = 0;
                        }
                        if(evalua < minEval){
                            minEval = evalua;
                            tmpPlay = mm;
                        }
                        beta = Math.min(beta, evalua);
                    }

                }
                if(beta <= alpha){
                    break;
                }
            }else{
                if(position[boardToPlayOn][mm] === 0){
                    position[boardToPlayOn][mm] = player;
                    evalua = miniMax(position, mm, depth-1, alpha, beta, true);
                    position[boardToPlayOn][mm] = 0;
                }
                var blep = evalua.mE;
                if(blep < minEval){
                    minEval = blep;
                    tmpPlay = evalua.tP;
                }
                beta = Math.min(beta, blep);
                if(beta <= alpha){
                    break;
                }
            }
        }
        return {"mE": minEval, "tP": tmpPlay};
    }
}

//Low number means losing the board, big number means winning
//Tbf this is less an evaluation algorithm and more something that figures out where the AI shud move to win normal Tic Tac Toe
function evaluatePos(pos, square){
    pos[square] = ai;
    var evaluation = 0;
    //Prefer center over corners over edges
    //evaluation -= (pos[0]*0.2+pos[1]*0.1+pos[2]*0.2+pos[3]*0.1+pos[4]*0.25+pos[5]*0.1+pos[6]*0.2+pos[7]*0.1+pos[8]*0.2);
    var points = [0.2, 0.17, 0.2, 0.17, 0.22, 0.17, 0.2, 0.17, 0.2];

    var a = 2;
    evaluation+=points[square];
    //console.log("Eyy");
    //Prefer creating pairs
    a = -2;
    if(pos[0] + pos[1] + pos[2] === a || pos[3] + pos[4] + pos[5] === a || pos[6] + pos[7] + pos[8] === a || pos[0] + pos[3] + pos[6] === a || pos[1] + pos[4] + pos[7] === a ||
        pos[2] + pos[5] + pos[8] === a || pos[0] + pos[4] + pos[8] === a || pos[2] + pos[4] + pos[6] === a) {
        evaluation += 1;
    }
    //Take victories
    a = -3;
    if(pos[0] + pos[1] + pos[2] === a || pos[3] + pos[4] + pos[5] === a || pos[6] + pos[7] + pos[8] === a || pos[0] + pos[3] + pos[6] === a || pos[1] + pos[4] + pos[7] === a ||
        pos[2] + pos[5] + pos[8] === a || pos[0] + pos[4] + pos[8] === a || pos[2] + pos[4] + pos[6] === a) {
        evaluation += 5;
    }

    //Block a players turn if necessary
    pos[square] = player;

    a = 3;
    if(pos[0] + pos[1] + pos[2] === a || pos[3] + pos[4] + pos[5] === a || pos[6] + pos[7] + pos[8] === a || pos[0] + pos[3] + pos[6] === a || pos[1] + pos[4] + pos[7] === a ||
        pos[2] + pos[5] + pos[8] === a || pos[0] + pos[4] + pos[8] === a || pos[2] + pos[4] + pos[6] === a) {
        evaluation += 2;
    }

    pos[square] = ai;

    evaluation-=checkWinCondition(pos)*15;

    pos[square] = 0;

    //evaluation -= checkWinCondition(pos)*4;

    return evaluation;
}

//This function actually evaluates a board fairly, is talked about in video.
function realEvaluateSquare(pos){
    var evaluation = 0;
    var points = [0.2, 0.17, 0.2, 0.17, 0.22, 0.17, 0.2, 0.17, 0.2];

    for(var bw in pos){
        evaluation -= pos[bw]*points[bw];
    }

    var a = 2;
    if(pos[0] + pos[1] + pos[2] === a || pos[3] + pos[4] + pos[5] === a || pos[6] + pos[7] + pos[8] === a) {
        evaluation -= 6;
    }
    if(pos[0] + pos[3] + pos[6] === a || pos[1] + pos[4] + pos[7] === a || pos[2] + pos[5] + pos[8] === a) {
        evaluation -= 6;
    }
    if(pos[0] + pos[4] + pos[8] === a || pos[2] + pos[4] + pos[6] === a) {
        evaluation -= 7;
    }

    a = -1;
    if((pos[0] + pos[1] === 2*a && pos[2] === -a) || (pos[1] + pos[2] === 2*a && pos[0] === -a) || (pos[0] + pos[2] === 2*a && pos[1] === -a)
        || (pos[3] + pos[4] === 2*a && pos[5] === -a) || (pos[3] + pos[5] === 2*a && pos[4] === -a) || (pos[5] + pos[4] === 2*a && pos[3] === -a)
        || (pos[6] + pos[7] === 2*a && pos[8] === -a) || (pos[6] + pos[8] === 2*a && pos[7] === -a) || (pos[7] + pos[8] === 2*a && pos[6] === -a)
        || (pos[0] + pos[3] === 2*a && pos[6] === -a) || (pos[0] + pos[6] === 2*a && pos[3] === -a) || (pos[3] + pos[6] === 2*a && pos[0] === -a)
        || (pos[1] + pos[4] === 2*a && pos[7] === -a) || (pos[1] + pos[7] === 2*a && pos[4] === -a) || (pos[4] + pos[7] === 2*a && pos[1] === -a)
        || (pos[2] + pos[5] === 2*a && pos[8] === -a) || (pos[2] + pos[8] === 2*a && pos[5] === -a) || (pos[5] + pos[8] === 2*a && pos[2] === -a)
        || (pos[0] + pos[4] === 2*a && pos[8] === -a) || (pos[0] + pos[8] === 2*a && pos[4] === -a) || (pos[4] + pos[8] === 2*a && pos[0] === -a)
        || (pos[2] + pos[4] === 2*a && pos[6] === -a) || (pos[2] + pos[6] === 2*a && pos[4] === -a) || (pos[4] + pos[6] === 2*a && pos[2] === -a)){
        evaluation-=9;
    }

    a = -2;
    if(pos[0] + pos[1] + pos[2] === a || pos[3] + pos[4] + pos[5] === a || pos[6] + pos[7] + pos[8] === a) {
        evaluation += 6;
    }
    if(pos[0] + pos[3] + pos[6] === a || pos[1] + pos[4] + pos[7] === a || pos[2] + pos[5] + pos[8] === a) {
        evaluation += 6;
    }
    if(pos[0] + pos[4] + pos[8] === a || pos[2] + pos[4] + pos[6] === a) {
        evaluation += 7;
    }

    a = 1;
    if((pos[0] + pos[1] === 2*a && pos[2] === -a) || (pos[1] + pos[2] === 2*a && pos[0] === -a) || (pos[0] + pos[2] === 2*a && pos[1] === -a)
        || (pos[3] + pos[4] === 2*a && pos[5] === -a) || (pos[3] + pos[5] === 2*a && pos[4] === -a) || (pos[5] + pos[4] === 2*a && pos[3] === -a)
        || (pos[6] + pos[7] === 2*a && pos[8] === -a) || (pos[6] + pos[8] === 2*a && pos[7] === -a) || (pos[7] + pos[8] === 2*a && pos[6] === -a)
        || (pos[0] + pos[3] === 2*a && pos[6] === -a) || (pos[0] + pos[6] === 2*a && pos[3] === -a) || (pos[3] + pos[6] === 2*a && pos[0] === -a)
        || (pos[1] + pos[4] === 2*a && pos[7] === -a) || (pos[1] + pos[7] === 2*a && pos[4] === -a) || (pos[4] + pos[7] === 2*a && pos[1] === -a)
        || (pos[2] + pos[5] === 2*a && pos[8] === -a) || (pos[2] + pos[8] === 2*a && pos[5] === -a) || (pos[5] + pos[8] === 2*a && pos[2] === -a)
        || (pos[0] + pos[4] === 2*a && pos[8] === -a) || (pos[0] + pos[8] === 2*a && pos[4] === -a) || (pos[4] + pos[8] === 2*a && pos[0] === -a)
        || (pos[2] + pos[4] === 2*a && pos[6] === -a) || (pos[2] + pos[6] === 2*a && pos[4] === -a) || (pos[4] + pos[6] === 2*a && pos[2] === -a)){
        evaluation+=9;
    }

    evaluation -= checkWinCondition(pos)*12;

    return evaluation;
}

//Just a quick function to return the sign of a number
function sign(x){
    if(x > 0){
        return 1;
    }else if(x < 0){
        return -1;
    }else{
        return 0;
    }
}

// ---------------------------------------------------------- GAME FUNCTION ------------------------------------------------------------------------ //

//var bestMove = -1;
//var bestScore = [-Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity];

function game(boards,mainBoard,currentBoard,MOVES){
    //AI HANDLER
//        console.log("Start AI");
        bestMove = -1;
        bestScore = [-Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity];
        RUNS = 0;
        //Just a variable where I store how many times minimax has run
        //Calculates the remaining amount of empty squares
        var count = 0;
        for(var bt = 0; bt < boards.length; bt++){
            if(checkWinCondition(boards[bt]) === 0){
                boards[bt].forEach((v) => (v === 0 && count++));
            }
        }

        if(currentBoard === -1 || checkWinCondition(boards[currentBoard]) !== 0){
            var savedMm;
//            console.log("Remaining: " + count);

            //This minimax doesn't actually play a move, it simply figures out which board you should play on
            if(MOVES < 10) {
                savedMm = miniMax(boards, -1, Math.min(4, count), -Infinity, Infinity, true);
                //Putting math.min makes sure that minimax doesn't run when the board is full
            }else if(MOVES < 18){
                savedMm = miniMax(boards, -1, Math.min(5, count), -Infinity, Infinity, true);
            }else{
                savedMm = miniMax(boards, -1, Math.min(6, count), -Infinity, Infinity, true);
            }
//            console.log(savedMm.tP);
            currentBoard = savedMm.tP;
        }
//        console.log("......");
        //Just makes a quick default move for if all else fails
        for (var i = 0; i < 9; i++) {
            if (boards[currentBoard][i] == 0) {
//                console.log(i);
                bestMove = i;
                break;
            }
        }
        if(bestMove !== -1) { //This condition should only be false if the board is full, but it's here in case

            //Best score is an array which contains individual scores for each square, here we're just changing them based on how good the move is on that one local board
            for (var a = 0; a < 9; a++) {
                if (boards[currentBoard][a] === 0) {
                    var score = evaluatePos(boards[currentBoard], a)*45;
                    bestScore[a] = score;
                }
            }
//            console.log(`${currentBoard}yoyo`);
            //And here we actually run minimax and add those values to the array
            for(var b = 0; b < 9; b++){
                if(checkWinCondition(boards[currentBoard]) === 0){
                    if (boards[currentBoard][b] === 0) {
                        boards[currentBoard][b] = ai;
                        var savedMm;
                        //Notice the stacking, at the beginning of the game, the depth is much lower than at the end
                        if(MOVES < 20){
                            savedMm = miniMax(boards, b, Math.min(5, count), -Infinity, Infinity, false);
                        }else if(MOVES < 32){
//                            console.log("DEEP SEARCH");
                            savedMm = miniMax(boards, b, Math.min(6, count), -Infinity, Infinity, false);
                        }else{
//                            console.log("ULTRA DEEP SEARCH");
                            savedMm = miniMax(boards, b, Math.min(7, count), -Infinity, Infinity, false);
                        }
//                        console.log(savedMm);
                        var score2 = savedMm.mE;
                        boards[currentBoard][b] = 0;
                        bestScore[b] += score2;
                        //boardSel[b] = savedMm.tP;
//                        console.log(score2);
                    }
                }
            }
//            console.log(`${bestScore} .....`);
            //Choses to play on the square with the highest evaluation in the bestScore array
            for(var i=0;i<9;i++){
                if(bestScore[i] > bestScore[bestMove]){
                    bestMove = i;
                }
            }
        }
        return {bestMove,currentBoard};
}
function setGame(boards,mainBoard,currentBoard,MOVES){
    for(var i=0;i<9;i++){
        for(var j=0;j<9;j++){
            if(boards[i][j]=='X') boards[i][j]=1;
            else if(boards[i][j]=='O') boards[i][j]=-1;
            else boards[i][j]=0;
        }
    }
    for(var i=0;i<9;i++){
        if(mainBoard[i][j]=='X') mainBoard[i][j]=1;
        else if(mainBoard[i][j]=='O') mainBoard[i][j]=-1;
        else mainBoard[i][j]=0;
    }
    return game(boards,mainBoard,currentBoard,MOVES);
}
module.exports = {
  setGame,// Export the function
};
//console.log(`${game(boards,mainBoard,-1,7)}...........`);
//            console.log(bestMove);
//            //Actually places the cross/nought
//            if(boards[currentBoard][bestMove] === 0){
//                boards[currentBoard][bestMove] = ai;
//                currentBoard = bestMove;
//            }
//            console.log(evaluateGame(boards, currentBoard));

//        currentTurn = -currentTurn;

//    }
    // console.log(',,,,,,')
//    for(var i in boards){
//        if(mainBoard[i] === 0) {
//            if (checkWinCondition(boards[i]) !== 0) {
//                mainBoard[i] = checkWinCondition(boards[i]);
//            }
//        }
//    }
//    console.log(gameRunning)
    //Checks the win conditions
//    if(gameRunning){
//        if (checkWinCondition(mainBoard) !== 0){
//            gameRunning = false;
//        }
//        //Once again, count the amount of playable squares, if it's 0, game is a tie
//        var countw = 0;
//        for(var bt = 0; bt < boards.length; bt++){
//            if(checkWinCondition(boards[bt]) === 0){
//                boards[bt].forEach((v) => (v === 0 && countw++));
//            }
//        }
//        if(countw === 0){
//            gameRunning = false;
//        }
//    }
    // console.log(gameRunning)
//    if(mainBoard[currentBoard] !== 0 || !boards[currentBoard].includes(0)){currentBoard = -1;}
    // console.log(currentBoard)
//    playerTurn(currentBoard);
//}
//
//function startGame(type){
//    boards = [
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0],
//        [0, 0, 0, 0, 0, 0, 0, 0, 0]
//    ];
//
//    mainBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0];
//
//    MOVES = 0;
//
//    //currentTurn = 1;
//    currentBoard = -1;
//
//    if(type === 0){
//        AIACTIVE = true;
//        gameRunning = true;
//        playerNames[0] = "PLAYER";
//        playerNames[1] = "AI";
//    }else{
//        AIACTIVE = false;
//        gameRunning = true;
//        switchAroo = 1;
//        playerNames[0] = "PLAYER 1";
//        playerNames[1] = "PLAYER 2";
//    }
//}
//
//function setGame(type){
//    if(type === 0){
//        currentTurn = 1;
//        switchAroo = 1;
//    }else{
//        currentTurn = -1;
//        switchAroo = -1;
//    }
//    startGame(0);
//}

//setGame(1);
//game();
//console.log(boards)
//game();
//console.log(boards)