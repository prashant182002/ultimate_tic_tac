var boards = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0]
];
var mainBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0];

function checkWinCondition(map) {
    var a = 1;
    if (map[0] + map[1] + map[2] === a * 3 || map[3] + map[4] + map[5] === a * 3 || map[6] + map[7] + map[8] === a * 3 || map[0] + map[3] + map[6] === a * 3 || map[1] + map[4] + map[7] === a * 3 ||
        map[2] + map[5] + map[8] === a * 3 || map[0] + map[4] + map[8] === a * 3 || map[2] + map[4] + map[6] === a * 3) {
        return a;
    }
    a = -1;
    if (map[0] + map[1] + map[2] === a * 3 || map[3] + map[4] + map[5] === a * 3 || map[6] + map[7] + map[8] === a * 3 || map[0] + map[3] + map[6] === a * 3 || map[1] + map[4] + map[7] === a * 3 ||
        map[2] + map[5] + map[8] === a * 3 || map[0] + map[4] + map[8] === a * 3 || map[2] + map[4] + map[6] === a * 3) {
        return a;
    }
    return 0;
}
//module.exports=boards;
//module.exports=mainBoard;