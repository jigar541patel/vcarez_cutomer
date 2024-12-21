import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/cubit/internet_cubit.dart';
import 'package:vcarez_new/routes.dart';
import 'package:vcarez_new/theme/theme_manager.dart';
import 'package:vcarez_new/ui/login/bloc/login_bloc.dart';
import 'package:vcarez_new/ui/login/view/login_screen.dart';
import 'package:vcarez_new/ui/signup/bloc/signup_bloc.dart';
import 'package:vcarez_new/ui/splash/view/splash_screen.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';
import 'package:vcarez_new/utils/strings.dart';

import 'commonmodel/cart_provider.dart';
import 'components/custom_snack_bar.dart';
import 'ui/contact_us_screen.dart';
import 'ui/signup/view/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ThemeNotifier()),
              ],
              child: const MyApp(),
            ),
          ));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: darkSkyBluePrimaryColor,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(builder: (context) {
          return BlocProvider(
            create: (context) => InternetCubit(),
            child: BlocListener<InternetCubit, InternetState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state == InternetState.lostState) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(createMessageSnackBar(
                  //     errorNoInternet));
                  CommonUtils.utils.showToast(errorNoInternet,
                      backgroundColor: redColor, textColor: whiteColor);
                }
              },
              child: Consumer<ThemeNotifier>(
                builder: (context, theme, child) => OverlaySupport(
                  child: MaterialApp(
                    title: 'Vcarez_Customer',
                    debugShowCheckedModeBanner: false,
                    theme: theme.lightThemeData(context),
                    darkTheme: theme.darkThemeData(context),
                    themeMode: theme.getThemeMode(),
                    onGenerateRoute: Routes.onGenerateRoute,
                    initialRoute: routeSplash,
                    localizationsDelegates: const [
                      GlobalWidgetsLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [Locale('en', 'US')],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
