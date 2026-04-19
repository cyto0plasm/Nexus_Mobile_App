
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/helpers/extensions.dart';
import 'package:nexus/core/routing/routes.dart';
import 'package:nexus/di.dart';
import 'package:nexus/features/components/text_feild.dart';
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/features/cubit/auth/auth_state.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';
import 'package:nexus/l10n/app_localizations.dart';
import 'package:nexus/repositories/auth_repo.dart';



class LoginScreen extends StatefulWidget {
  
  
   const  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
  //Validation
    if (!_formKey.currentState!.validate()) return;
  //emit login
    context.read<AuthCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      // listener → one-time side-effects: navigation, snackbars
      listener: (context, state) {
         if (state is AuthError) {
        context.read<FlashCubit>().error(state.message);
      }
        if (state is AuthSuccess) {
           context.read<FlashCubit>().success('Welcome, ${state.user.name}!');
          context.pushNamedAndRemoveUntil(Routes.home, predicate: (route)=>false);
         
        }
        if (state is AuthLoggedOut) {
        context.read<FlashCubit>().info('You have been logged out.');
        context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (_) => false);
      }
      },
      // builder → visual state only
      builder: (context, state) {
        final isLoading = state is AuthLoading;
    
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),
          body: Stack(
            children: [
              // Background blobs
              Positioned(
                top: -size.height * 0.1,
                right: -size.width * 0.2,
                child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6C63FF).withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6C63FF).withOpacity(0.05),
                  ),
                ),
              ),
    
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
    
                              // Logo
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF)
                                          .withOpacity(0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.bolt_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 28),
    
                              // Heading
                              Text(
                                l10n.signIn,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E),
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(Routes.registerScreen);
                                },
                                child: RichText(
                                  text:  TextSpan(
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF9E9E9E),
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: l10n.dontHaveAnAccount),
                                      TextSpan(
                                        text: l10n.signUp,
                                        style: TextStyle(
                                          color: Color(0xFF6C63FF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),
    
                              // Email field
                              CustomTextField(
                                type: TextFieldType.email,
                                label: l10n.emailAddress,
                                placeholder: 'you@example.com',
                                controller: _emailController,
                             
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return l10n.emailRequired;
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(val)) {
                                    return l10n.emailInvalid;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
    
                              // Password field
                              CustomTextField(
                                type: TextFieldType.password,
                                label: l10n.password,
                                placeholder: l10n.passwordPlaceholder,
                                controller: _passwordController,
                               
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return l10n.password;
                                  }
                                  if (val.length < 6) {
                                    return l10n.passwordTooShort;
                                  }
                                  return null;
                                },
                              ),
    
                            
                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 12),
                                  ),
                                  child: Text(l10n.forgotPassword ,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF6C63FF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
    
                              // Sign in button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _onSubmit(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C63FF),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        const Color(0xFF6C63FF)
                                            .withOpacity(0.6),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          l10n.signIn,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 28),
    
                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.08),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      l10n.orContinueWith,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color:
                                            Colors.black.withOpacity(0.35),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.08),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
    
                              // Social buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Google',
                                      icon: const Icon(
                                        Icons.g_mobiledata_rounded,
                                        size: 22,
                                        color: Color(0xFF4285F4),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Apple',
                                      icon: const Icon(
                                        Icons.apple_rounded,
                                        size: 20,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Social Button ────────────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFF000000).withOpacity(0.08),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}