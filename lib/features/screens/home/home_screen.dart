import 'package:flutter/material.dart';
import 'package:nexus/features/components/logout_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children:[
    Text("Home Screen"),
    LogoutButton()

    ] 
    );
  }
}