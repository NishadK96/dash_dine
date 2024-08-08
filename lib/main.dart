import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/auth/bloc/bloc/login_bloc.dart';
import 'package:pos_app/cart_page/bloc/cart_bloc.dart';
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/screens/dashboard.dart';
import 'package:pos_app/screens/splash_screen.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/variants/variant_bloc.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';

Future  main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await authentication.init();
    
 SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => 
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ProductListBloc(),
    ), BlocProvider(
      create: (context) => ManagerBloc(),
    ),
    BlocProvider(
      create: (context) => VariantBloc(),
    ),
    BlocProvider(
      create: (context) => CartBloc(),
    ),
    BlocProvider(
    create: (context) => LoginBloc(),
  ),
    BlocProvider(
    create: (context) => ManageWarehouseBloc(),
  ),
    BlocProvider(
    create: (context) => ManageStoreBloc(),
  ),
  ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @ override
  Widget build(BuildContext context) {
   
    return ScreenUtilInit(
        designSize:isTab(context)? const Size(960, 1440):const Size(430, 844),
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (context,child) {
        return MaterialApp(
            title: 'Pos Mobile',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(textSelectionTheme: const TextSelectionThemeData(selectionColor: Colors.black12,selectionHandleColor: Colors.grey),
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
                  .copyWith(background: const Color(0xffF5F5F5)),
                   
            ),
             builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                // ignore: prefer_const_constructors
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
            home:authentication.isAuthenticated?DashBoard(): const SplashScreen()
            // DashBoard()
            );
      }
    );
  }
}
