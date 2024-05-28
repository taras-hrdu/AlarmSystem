import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensory_alarm/app/view/app_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sensory_alarm/firebase_options.dart';

void main() => runZoned(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      WidgetsFlutterBinding.ensureInitialized();

      runApp(const AppController());
    });
