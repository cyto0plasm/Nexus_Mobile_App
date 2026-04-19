import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/features/cubit/feedback/flash_cubit.dart';

class FlashBar extends StatelessWidget {
  final Widget child;
  const FlashBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // ✅ UI underneath — never pushed
        Positioned(
          top: MediaQuery.of(context).padding.top + 12, // respects status bar
          left: 24,
          right: 24,
          child: BlocBuilder<FlashCubit, FlashState>(
            builder: (context, state) {
              return AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                offset: state.visible ? Offset.zero : const Offset(0, -0.3),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state.visible ? 1.0 : 0.0,
                  child: state.visible
                      ? _FlashContent(state: state)
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FlashContent extends StatelessWidget {
  final FlashState state;
  const _FlashContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final config = _FlashConfig.from(state.type);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(color: config.color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // icon
            Icon(config.icon, color: config.color, size: 20),
            const SizedBox(width: 10),

            // message
            Expanded(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),

            // count badge — only shows when same error fires multiple times
            if (state.count > 1) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${state.count}x',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: config.color,
                  ),
                ),
              ),
            ],

            // close button
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.read<FlashCubit>().hide(),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// config per type — one place to change colors/icons
class _FlashConfig {
  final Color color;
  final IconData icon;

  const _FlashConfig({required this.color, required this.icon});

  factory _FlashConfig.from(FlashType type) {
    return switch (type) {
      FlashType.success => const _FlashConfig(
          color: Color(0xFF22C55E),
          icon: Icons.check_circle_outline_rounded,
        ),
      FlashType.error => const _FlashConfig(
          color: Color(0xFFE53935),
          icon: Icons.error_outline_rounded,
        ),
      FlashType.info => const _FlashConfig(
          color: Color(0xFF6C63FF),
          icon: Icons.info_outline_rounded,
        ),
    };
  }
}