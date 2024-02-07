import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient{
  IO.Socket? socket;
  static SocketClient? _instance;

  // 192.168.1.9
  SocketClient._internal(){
    print('vlient');
    try{
      socket = IO.io('http://localhost:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
    }catch(e){
      print(e);
    }
    socket!.connect();
  }
  static SocketClient? get instance{
    _instance=SocketClient._internal();
    return _instance!;
  }
}
