import 'package:bloc/bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/layout_screen.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/share/bloc_observe.dart';
import 'package:shop_app/share/network/remote/cach_helper.dart';
import 'package:shop_app/share/network/remote/dio_helper.dart';
import 'package:shop_app/share/style/const.dart';
import 'modules/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;

  if (onBoarding == true) {
    if (token != null) {
      widget = const LayoutScreen();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final bool? isDark;

  const MyApp({required this.startWidget, this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()
        ..getHomeData()
        ..getProfileData()
        ..getCategoriesData()
        ..getFavoriteData()
        ..getDataSetting()
        ..getCartsData()
        ..switchChange(fromShared: isDark),
      child: BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {},
        builder: (context, state) {
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: defaultColor,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 1.0,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: .4,
                ),
                backgroundColor: Colors.white10,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.white,
              ),
              appBarTheme:
                  const AppBarTheme(elevation: 0.0, color: Colors.white12),
              iconTheme: IconThemeData(
                color: defaultColor,
                size: 30,
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: defaultColor, fontSize: 25.5),
                bodyMedium: TextStyle(color: defaultColor, fontSize: 16.0),
              ),
              indicatorColor: Theme.of(context).primaryColor,
            ),
            debugShowCheckedModeBanner: false,
            home: OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connect = connectivity != ConnectivityResult.none;
                if (connect) {
                  return startWidget;
                } else {
                  return Scaffold(
                      body: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No Internet Connection'),
                              Icon(EvaIcons.wifiOff)
                            ],
                          )));
                }
              },
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
