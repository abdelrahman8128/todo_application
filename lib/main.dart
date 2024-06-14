
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p4all/layout/todo_app/todo_layout.dart';
import 'package:p4all/shared/cubit/cubit.dart';
import 'package:p4all/shared/cubit/states.dart';
import 'package:p4all/shared/network/local/cache_helper.dart';
import 'package:p4all/shared/styles/themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  bool isDarkTheme =(CacheHelper.getDate('isDark')??false);
  bool onBoarding=CacheHelper.getDate('onBoarding')??true ;
  String token= CacheHelper.getDate('token')??'';
 // CacheHelper
  runApp(MyApp(

  ));
}

class MyApp extends StatelessWidget {

  MyApp();


  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return
        BlocProvider(create: (context) => AppCubit(),

      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          print(state.toString());
        },
        builder: (context, state) {
          return MaterialApp(


            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              colorScheme: ColorScheme.light(primary: Colors.blueGrey),
            ),
            home: HomeLayout(),
          );
        },
      ),

    );
  }
}
