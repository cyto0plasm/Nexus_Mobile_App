import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/localization/locale_cubit.dart';

class LangSwitcher extends StatelessWidget {
  const LangSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LocaleCubit>().state;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangOption(label: 'EN', locale: const Locale('en'), current: current),
          const SizedBox(width: 4),
          _LangOption(label: 'ع', locale: const Locale('ar'), current: current),
        ],
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final Locale locale;
  final Locale current;

  const _LangOption({
    required this.label,
    required this.locale,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current.languageCode == locale.languageCode;

    return GestureDetector(
      onTap: () => context.read<LocaleCubit>().setLocale(locale),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C63FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }
}