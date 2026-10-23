import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/View/Auth/ResetPassword.dart';
import 'package:travelmate/View/theme/colors.dart';
import 'package:travelmate/View/Traveler/homescreen.dart';
import 'package:travelmate/View/Auth/signin.dart';
import 'package:travelmate/ViewModel/chat_view_model.dart';
import 'package:travelmate/ViewModel/Auth/user_view_model.dart'; // Add this import
import 'package:travelmate/ViewModel/notification_view_model.dart';
import 'package:travelmate/global.dart';
import 'package:travelmate/onboardingScreens.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Model/FilterModel.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    await NotificationViewModel().initNotifications();
    print('Firebase initialized');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool isLoading = true;
  bool showOnboarding = true;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await checkOnboardingStatus();
    await checkAuthState();
    initUniLinks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkAuthState() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String currentUserID = currentUser.uid;
      AppConstants.currentUser.id = currentUserID;
      print("Current user ID: $currentUserID");
      await LoginViewModel.getUserInfoFromFirestore(currentUserID);
      await LoginViewModel.getImageFromStorage(currentUserID);
      await userViewModel.getUserReservations();
      await userViewModel.getMyPropertiesFromFirestore();
      await userViewModel.updateUserToken();
    }
    setState(() {
      user = currentUser;
    });
  }

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('showOnboarding');
    setState(() {
      showOnboarding = seen == null || seen == true;
    });
  }

  void _handleIncomingLink(String link) {
    final uri = Uri.parse(link);
    if (uri.scheme == 'travelmate' && uri.host == 'reset-password') {
      final email = uri.queryParameters['email'];
      final oobCode = uri.queryParameters['oobCode'];
      final mode = uri.queryParameters['mode'];
      if (email != null && oobCode != null && mode == 'action') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPassword(email: email, resetCode: oobCode),
          ),
        );
      }
    }
  }

  void initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleIncomingLink(initialLink);
      }

      linkStream.listen((String? link) {
        if (link != null) {
          _handleIncomingLink(link);
        }
      });
    } catch (e) {
      print('Failed to initialize UniLinks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FilterModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()), // Add ChatViewModel
        ChangeNotifierProvider(create: (_) => UserViewModel(AppConstants.currentUser)), // Provide UserViewModel
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: appRed),
        ),
        home: isLoading
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(
                        255, 255, 146, 99), // Use your specified color
                  ),
                ),
              )
            : showOnboarding
                ? OnboardingScreen()
                : (user == null ? SignInScreen() : HomeScreen(userId: user!.uid)),
      ),
    );
  }
}
