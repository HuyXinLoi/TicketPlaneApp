// Project: ticket_plane_app
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_plane_app/base/route.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_bloc.dart';
import 'package:ticket_plane_app/screen/flight/bloc/flight_bloc.dart';
import 'package:ticket_plane_app/screen/forgotpassword/bloc/forgot_password_bloc.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_bloc.dart';
import 'package:ticket_plane_app/screen/infomationsingup/bloc/infomation_signup_bloc.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_info_repository.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_bloc.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_event.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_bloc.dart';
import 'package:ticket_plane_app/screen/profile/auth_repository.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_bloc.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
  //DependencyInjection.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(),
        ),
        BlocProvider<UserInfoBloc>(
          create: (context) => UserInfoBloc(
              userInfoRepository: UserInfoRepository(), userId: ''),
        ),
        BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc()), 
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
        BlocProvider<FlightBloc>(
          create: (context) => FlightBloc(),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(),
        ),
        BlocProvider<TicketBloc>(
          create: (context) => TicketBloc(),
        ),
        BlocProvider<HistoryBloc>(
          create: (context) => HistoryBloc(),
        ),
        // Thêm các BLoC khác nếu cần
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            authRepository: AuthRepository(),
            passengerRepository: PassengerRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
