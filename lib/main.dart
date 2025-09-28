import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:meeting_app/core/api/api_helper.dart';
import 'package:meeting_app/core/constant/string_constant.dart';
import 'package:meeting_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:meeting_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:meeting_app/feature/auth/domain/usecases/login_usecase.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:meeting_app/feature/splash/splash.dart';
import 'package:meeting_app/feature/users/data/datasource/userdatasource.dart';
import 'package:meeting_app/feature/users/data/repositories/userrepositories.dart';
import 'package:meeting_app/feature/users/domain/usecases/userdata_usecase.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.openBox('usersBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              LoginUseCase(
                AuthRepositoryImpl(AuthRemoteDataSource(ApiHelper())),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              UserdataUsecase(
                UserRepositoryImpl(UserRemoteDataSource(ApiHelper())),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: StringConstant.appFontFamily,
          ),
          home: const Splash(),
        ),
      ),
    );
  }
}
