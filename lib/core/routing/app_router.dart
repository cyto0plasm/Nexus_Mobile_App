import 'package:flutter/material.dart';
import 'package:nexus/core/routing/routes.dart';
import 'package:nexus/features/Auth/login_screen.dart';
import 'package:nexus/features/Auth/password_reset_screen.dart';
import 'package:nexus/features/Auth/register_screen.dart';
import 'package:nexus/features/Feedback/error_screen.dart';
import 'package:nexus/features/OnBoarding/onBoarding_screen.dart';
import 'package:nexus/features/screens/home/home_screen.dart';
import 'package:nexus/repositories/auth_repo.dart';

class AppRouter{
    final AuthRepo authRepo;

  AppRouter({required this.authRepo});


  Route generateRoute(RouteSettings settings){
    switch (settings.name){
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_)=> const OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_)=>  LoginScreen());
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (_)=> RegisterScreen());
      case Routes.passwordReset:
        return MaterialPageRoute(builder: (_)=> const PasswordResetScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_)=> HomeScreen());
    default:
    return MaterialPageRoute(builder: (_)=>ErrorScreen());
    }
  }
}