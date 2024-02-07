
function checkWinCondition(map) {
//    console.log(map);
//    console.log(map[2] == 'X');
//    console.log(map[4] == 'X');
//    console.log(map[6] == 'X');
//    console.log('mmmmmmmmmmmmm');
    if ((map[0] == 'X' && map[1]=='X' && map[2] == 'X' )|| (map[3] == 'X' && map[4]=='X' && map[5] == 'X' )||
        (map[6] == 'X' && map[7]=='X' && map[8] == 'X' )|| (map[0] == 'X' && map[3]=='X' && map[6] == 'X' )||
         (map[1] == 'X' && map[4]=='X' && map[7] == 'X' )||(map[2] == 'X' && map[5]=='X' && map[8] == 'X' )||
        (map[0] == 'X' && map[4]=='X' && map[8] == 'X' )||(map[2] == 'X' && map[4]=='X' && map[6] == 'X' )){
        return 1;
    }
    if ((map[0] == 'O' && map[1]=='O' && map[2] == 'O' )|| (map[3] == 'O' && map[4]=='O' && map[5] == 'O' )||
            (map[6] == 'O' && map[7]=='O' && map[8] == 'O' )|| (map[0] == 'O' && map[3]=='O' && map[6] == 'O' )||
             (map[1] == 'O' && map[4]=='O' && map[7] == 'O' )||(map[2] == 'O' && map[5]=='O' && map[8] == 'O' )||
            (map[0] == 'O' && map[4]=='O' && map[8] == 'O' )||(map[2] == 'O' && map[4]=='O' && map[6] == 'O' )){
            return -1;
        }
    return 0;
}
module.exports = {
  checkWinCondition// Export the function
};