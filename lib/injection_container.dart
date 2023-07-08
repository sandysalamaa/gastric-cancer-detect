import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/util/api_basehelper.dart';
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/get_new_messages.dart';
import 'features/chat/domain/usecases/mark_peer_messages_as_read.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/domain/usecases/set_chatting_Id_for_users.dart';
import 'features/chat/domain/usecases/uplaod_Image_to_server.dart';
import 'features/chat/presentation/provider/chat_provider.dart';

final sl = GetIt.instance;
final ApiBaseHelper helper = ApiBaseHelper();
late final SharedPreferences sharedPreferences;
Future<void> init() async {
  // await initAuthInjection(sl);

  // core
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  sl.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  helper.dioInit();
  sl.registerLazySingleton(() => helper);
  sl.registerFactory(() => ChatProvider(
        getNewMessagesCount: sl(),
        markPeerMessagesAsRead: sl(),
        uplaodImageToServer: sl(),
        getAllMessages: sl(),
        sendMessage: sl(),
        setChattingIdForUsers: sl(),
      ));
  sl.registerLazySingleton(() => SetChattingIdForUsers(repository: sl()));
  sl.registerLazySingleton(() => SendMessage(repository: sl()));
  sl.registerLazySingleton(() => GetAllMessages(repository: sl()));
  sl.registerLazySingleton(() => UplaodImageToServer(repository: sl()));
  sl.registerLazySingleton(() => MarkPeerMessagesAsRead(repository: sl()));
  sl.registerLazySingleton(() => GetNewMessagesCount(repository: sl()));

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firebaseMessaging: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );
}
