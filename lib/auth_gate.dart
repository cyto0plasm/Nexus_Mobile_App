import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/helpers/token_storage.dart';
import 'package:nexus/core/helpers/user_storage.dart';
import 'package:nexus/features/Auth/login_screen.dart';
import 'package:nexus/features/screens/home/home_screen.dart'; // temp — replace with AdminApp/CashierApp later
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/models/user_model.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  String? _token;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    _token = await TokenStorage.getToken();
    _user  = await UserStorage.getUser();
    // rehydrate cubit so rest of app knows who's logged in
     if (_user != null) {
    context.read<AuthCubit>().rehydrate(_user!);
  }
  
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // loading — check local storage
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // no token — not logged in
    if (_token == null) return LoginScreen();

    // token exists but no shop — onboarding not done
    // TODO: return OnboardingScreen() when built
    if (_user?.hasShop == false) return HomeScreen(); // temp

    // has shop — route by role
    return switch (_user?.role) {
      'admin'   => HomeScreen(),   // TODO: replace with AdminApp()
      'cashier' => HomeScreen(),   // TODO: replace with CashierApp()
      _         => HomeScreen(),   // fallback — onboarding not done
    };
  }
}