// lib/features/Auth/register/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/helpers/extensions.dart';
import 'package:nexus/core/routing/routes.dart';
import 'package:nexus/di.dart';

import 'package:nexus/features/components/lang_switcher.dart';
import 'package:nexus/features/components/text_feild.dart';
import 'package:nexus/features/cubit/auth/auth_cubit.dart';
import 'package:nexus/features/cubit/auth/auth_state.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';
import 'package:nexus/l10n/app_localizations.dart';
import 'package:nexus/repositories/auth_repo.dart';

class RegisterScreen extends StatefulWidget {
 const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

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
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

void _onSubmit(BuildContext context) {
  if (!_formKey.currentState!.validate()) return;
  context.read<AuthCubit>().register(
    name: _nameController.text,
    email: _emailController.text,
    phone: _phoneController.text,
    password: _passwordController.text,
    passwordConfirmation: _passwordConfirmationController.text,
  );
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    

    return BlocConsumer<AuthCubit, AuthState>(
     listener: (context, state) {
      if (state is AuthSuccess) {
        context.read<FlashCubit>().success(l10n.accountCreated);
        context.pushNamedAndRemoveUntil(Routes.home, predicate: (route) => false);
      }
      if (state is AuthError) {
        context.read<FlashCubit>().error(state.message);
      }
    },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
    
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Background blobs ──────────────────────────────
              Positioned(
                  top: -size.height * 0.1,
                  right: -size.width * 0.2,
                child: IgnorePointer(
                
                  child: Container(
                    width: size.width * 0.6,
                    height: size.width * 0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6C63FF).withOpacity(0.08),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: -100,
                  left: -80,
                child: IgnorePointer(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6C63FF).withOpacity(0.05),
                    ),
                  ),
                ),
              ),
    
              // ── Content ───────────────────────────────────────
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
                              SafeArea(
                                child: LangSwitcher(),
                              ),
                              // Heading
                              Text(
                                l10n.createAccount,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E),
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF9E9E9E),
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: l10n.alreadyHaveAccount),
                                       TextSpan(
                                        text: l10n.signIn,
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
    
                              // Fields
                              CustomTextField(
                                type: TextFieldType.name,
                                label: l10n.fullName,
                                placeholder: l10n.fullNamePlaceholder,
                                controller: _nameController,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return l10n.nameRequired;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
    
                              CustomTextField(
                                type: TextFieldType.phone,
                                label: l10n.phoneNumber,
                                placeholder: l10n.phonePlaceholder,
                                controller: _phoneController,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return l10n.phoneRequired;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
    
                              CustomTextField(
                                type: TextFieldType.email,
                                label:  l10n.emailAddress,
                                placeholder: l10n.emailPlaceholder,
                                controller: _emailController,
                                validator: (val) {
                                if (val == null || val.isEmpty) return l10n.emailRequired;
                                final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(val)) return l10n.emailInvalid;
                                return null;
                              },
                            ),
                              const SizedBox(height: 18),
    
                              CustomTextField(
                                type: TextFieldType.password,
                                 label: l10n.password,
                                  placeholder: l10n.passwordPlaceholder,
                                controller: _passwordController,
                               validator: (val) {
                                  if (val == null || val.isEmpty) return l10n.passwordRequired;
                                  if (val.length < 6) return l10n.passwordTooShort;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
    
                              CustomTextField(
                                type: TextFieldType.password,
                                 label: l10n.confirmPassword,
                                  controller: _passwordConfirmationController,
                                  placeholder: l10n.confirmPasswordPlaceholder,
                                  validator: (val) {
                                    if (val != _passwordController.text) return l10n.passwordsDoNotMatch;
                                    return null;
                                  },
                                ),
    
                        
                              const SizedBox(height: 24),
    
                              // Sign up button
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
                                      :  Text(
                                         l10n.signUp,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
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