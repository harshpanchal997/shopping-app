import 'package:shopping/ui/product/product_list_screen.dart';
import 'package:shopping/utils/database/database_manager.dart';
import 'package:shopping/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shopping/utils/theme_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ///Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      DBManager.instance.initializeDatabase().then((database) async {
        print("________Database Initialized________");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
      });
    });
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          appName,
          style: TextStyles.txtBold30,
        ),
      ),
    );
  }
}
