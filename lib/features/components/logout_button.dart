import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/features/cubit/auth/auth_state.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';
import 'package:nexus/core/helpers/extensions.dart';
import 'package:nexus/core/routing/routes.dart';

class LogoutButton extends StatelessWidget {
  final Widget? child; // optional — defaults to icon+text if not provided

  const LogoutButton({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          context.read<FlashCubit>().info('You have been logged out.');
          context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (_) => false);
        }
      },
      child: GestureDetector(
        onTap: () => context.read<AuthCubit>().logout(),
        child: child ?? const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, size: 20, color: Color(0xFFE53935)),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}