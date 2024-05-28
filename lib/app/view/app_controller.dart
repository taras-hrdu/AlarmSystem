import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensory_alarm/app/repositories/device_repository.dart';
import 'package:sensory_alarm/app/repositories/user_repository.dart';
import 'package:sensory_alarm/app/view/splash_controller.dart';
import 'package:sensory_alarm/features/auth/cubit/auth_cubit.dart';
import 'package:sensory_alarm/features/auth/cubit/user/user_cubit.dart';
import 'package:sensory_alarm/features/auth/repositories/auth_repository.dart';
import 'package:sensory_alarm/features/auth/view/login_controller.dart';
import 'package:sensory_alarm/features/auth/view/register_controller.dart';
import 'package:sensory_alarm/features/devices/cubit/device_cubit.dart';
import 'package:sensory_alarm/features/devices/view/devices_controller.dart';
import 'package:sensory_alarm/features/devices/view/home_controller.dart';
import 'package:sensory_alarm/features/devices/view/profile_controller.dart';
import 'package:sensory_alarm/firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  NavigatorState? get navigator => navigatorKey.currentState;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (await Permission.notification.isGranted) {
      await startFCM();
    }
  }

  Future<void> startFCM() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final channel = await initNotificationPlugin();

    FirebaseMessaging.onMessage
        .listen((event) => handleMessage(event, channel));
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => DeviceRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthCubit(context.read<AuthRepository>())..init()),
          BlocProvider(
              create: (context) =>
                  DeviceCubit(repository: context.read<DeviceRepository>())),
          BlocProvider(
              create: (context) =>
                  UserCubit(repository: context.read<UserRepository>())),
        ],
        child: MaterialApp(
          title: 'Sensory alarm',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthCubit, AuthState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == AuthStatus.authenticated) {
                    navigator?.pushNamedAndRemoveUntil(
                        HomeController.routeName, (route) => false);
                  } else if (state.status == AuthStatus.unauthenticated) {
                    navigator?.pushNamedAndRemoveUntil(
                        LoginController.routeName, (route) => false);
                  }
                },
                child: child);
          },
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          routes: {
            LoginController.routeName: (context) => const LoginController(),
            RegisterController.routeName: (context) =>
                const RegisterController(),
            HomeController.routeName: (context) => const HomeController(),
            DevicesController.routeName: (context) => const DevicesController(),
            ProfileController.routeName: (context) => const ProfileController(),
            SplashController.routeName: (context) => const SplashController()
          },
          initialRoute: SplashController.routeName,
        ),
      ),
    );
  }
}

Future<AndroidNotificationChannel> initNotificationPlugin() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '1',
    'test',
    description: 'test',
    importance: Importance.max,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('alarm_system_icon');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  return channel;
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  final channel = await initNotificationPlugin();
  await handleMessage(message, channel);
}

Future<void> handleMessage(
    RemoteMessage message, AndroidNotificationChannel channel) async {
  final notification = message.notification;
  if (notification != null) {
    FlutterLocalNotificationsPlugin().show(
        0,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ));
  }
}
