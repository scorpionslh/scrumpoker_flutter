import 'package:flutter_modular/flutter_modular.dart';
import 'package:scrumpoker_flutter/atoms/core_reduce.dart';
import 'package:scrumpoker_flutter/modules/core/adapters/cache_impl.dart';
import 'package:scrumpoker_flutter/modules/core/adapters/socket_impl.dart';
import 'package:scrumpoker_flutter/modules/core/presenter/pages/home_page.dart';
import 'package:scrumpoker_flutter/modules/core/presenter/pages/room_page.dart';
import 'package:scrumpoker_flutter/modules/core/protocols/adapters/cache.dart';
import 'package:scrumpoker_flutter/modules/core/protocols/adapters/i_socket.dart';
import 'package:scrumpoker_flutter/modules/core/protocols/services/room_service.dart';
import 'package:scrumpoker_flutter/modules/core/services/room_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppModule extends Module {
  final SharedPreferences prefs;
  final IO.Socket socket;

  AppModule({
    required this.prefs,
    required this.socket,
  });

  @override
  void binds(i) {
    i.addInstance(prefs);
    i.addInstance<ISocket>(SocketImpl(
      socket: socket,
    ));
    i.addLazySingleton<Cache>(CacheImpl.new);
    i.addSingleton<RoomService>(RoomServiceImpl.new);
    i.addSingleton(CoreReduce.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const HomePage(),
    );
    r.child('/room/:roomId',
        child: (_) => RoomPage(
              roomId: r.args.params['roomId'] as String,
            ));
  }
}
