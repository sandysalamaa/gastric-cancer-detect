import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_home/presentation/pages/docter_home_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/patient_home_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/cubit/role/role_cubit.dart';
import 'package:provider/provider.dart';

import 'core/constant/animation/custom_page_transation.dart';
import 'core/constant/colors/colors.dart';
import 'core/constant/dimenssions/size_config.dart';
import 'core/firebase/auth_stream.dart';
import 'core/widgets/toast.dart';
import 'features/auth/model/user.dart';
import 'features/auth/presentation/cubit/login/login_cubit.dart';
import 'features/chat/presentation/provider/chat_provider.dart';
import 'features/patient_features/patient_home/presentation/cubit/patient_home_cubit.dart';
import 'features/settings/presentation/pages/role_screen.dart';
import 'features/settings/presentation/pages/splash_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  await Firebase.initializeApp();

  log("_messaging onBackgroundMessage: $message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var initialzationSettingsAndroid =
      const AndroidInitializationSettings('logo');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  log("_messaging onBackgroundMessage: $message");

  if (notification != null &&
      android != null &&
      notification.title != null &&
      notification.title!.isNotEmpty) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            priority: Priority.max,
            enableLights: true,
            playSound: true,
          ),
        ));
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await EasyLocalization.ensureInitialized();
  await di.init();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: mainColor,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: "assets/translate",
        saveLocale: true,
        startLocale: const Locale('ar'),
        useOnlyLangCode: true,
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => di.helper.updateLocalInHeaders(
        EasyLocalization.of(context)!.currentLocale!.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Builder(builder: (context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatProvider>(
              create: (_) => sl<ChatProvider>())
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RoleCubit>(
              create: (BuildContext context) => RoleCubit(),
            ),
            BlocProvider<PatientHomeCubit>(
              create: (BuildContext context) => PatientHomeCubit(),
            ),
            BlocProvider<RegisterCubit>(
              create: (BuildContext context) => RegisterCubit(),
            ),
            BlocProvider<LoginCubit>(
              create: (BuildContext context) => LoginCubit(),
            ),
          ],
          child: MaterialApp(
            title: 'GCD',
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            theme: ThemeData(
                fontFamily: "Tajawal",
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomePageTransition(),
                  TargetPlatform.iOS: CustomePageTransition()
                }),
                appBarTheme: AppBarTheme(
                    color: ThemeData.light().scaffoldBackgroundColor,
                    iconTheme: const IconThemeData(color: mainColor),
                    elevation: 0)),
            locale: context.locale,
            home: const SafeArea(child: NotificationsHndler()),
          ),
        ),
      );
    });
  }
}

class NotificationsHndler extends StatefulWidget {
  const NotificationsHndler({super.key});

  @override
  State<NotificationsHndler> createState() => _NotificationsHndlerState();
}

class _NotificationsHndlerState extends State<NotificationsHndler> {
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('logo');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {},
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});

    FirebaseMessaging.onMessage.listen((event) {
      AndroidNotification? android = event.notification?.android;
      if (event.notification != null &&
          event.notification!.title != null &&
          event.notification!.title!.isNotEmpty) {
        flutterLocalNotificationsPlugin.show(
          event.hashCode,
          event.notification!.title,
          event.notification?.body ?? "",
          NotificationDetails(
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android?.smallIcon,
              priority: Priority.max,
              enableLights: true,
              playSound: true,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            showToast(
              tr('click_again_to_exit'),
            );
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: const SafeArea(child: GCDApp()));
  }
}

class GCDApp extends StatefulWidget {
  const GCDApp({
    Key? key,
  }) : super(key: key);

  @override
  State<GCDApp> createState() => _GCDAppState();
}

class _GCDAppState extends State<GCDApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      log("locale${context.locale}");
      log("deviceLocale${context.deviceLocale}");
      Locale locale = context.deviceLocale;
      if (context.locale != context.deviceLocale) {
        locale = context.locale;
      }
      context.setLocale(locale);
      di.helper.updateLocalInHeaders(locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ScreenUtil.init(context, designSize: const Size(428, 926));
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const SplashScreen();
        }
        if (snapshot.data == null) {
          return const RoleScreen();
        } else {
          return StreamBuilder<BaseUser>(
              stream: getUserData(snapshot.data!.uid),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SplashScreen();
                }
                context.read<LoginCubit>().setbaseUser = snapshot.data!;
                final baseUser = snapshot.data!;
                if (baseUser.type == UserType.patient) {
                  return const PatientHomeScreen();
                } else {
                  return const DoctorHomeScreen();
                }
              });
        }
      },
    );
  }
}
