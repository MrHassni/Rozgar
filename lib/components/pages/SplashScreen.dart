import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Rozgar/components/pages/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');
    int? lastLaunchTime = prefs.getInt('lastLaunchTime');
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (isFirstLaunch == null || isFirstLaunch) {
      // Update the last launch time and mark the first launch as false
      await prefs.setBool('isFirstLaunch', false);
      await prefs.setInt('lastLaunchTime', currentTime);

      // Display the splash screen for 5 seconds
      await Future.delayed(Duration(seconds: 5));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Check if the last launch was within the last 5 seconds
      if (lastLaunchTime != null && currentTime - lastLaunchTime < 5000) {
        // Navigate immediately if within 5 seconds
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Update the last launch time
        await prefs.setInt('lastLaunchTime', currentTime);

        // Display the splash screen for 5 seconds
        await Future.delayed(Duration(seconds: 5));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'A H K N',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Khawajgan Ba\'izat Rozgar',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
