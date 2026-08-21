import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the landing page.
class AppColors {
  static const black = Color(0xFF0A0C10); // Deep rich dark tone
  static const cream = Color(0xFFF3EFC9);
  static const paleYellow = Color(0xFFF5E6A8);
  static const indigoGlow = Color(0xFF6366F1);
  static const violetGlow = Color(0xFF8B5CF6);
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true); // Continuous ambient pulse
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            // 1. Animated Grid Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: GlowingGridPainter(progress: _controller.value),
                  );
                },
              ),
            ),

            // 2. Foreground Content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNavRow(context),
                          const SizedBox(height: 64),
                          _buildHero(context),
                          const SizedBox(height: 48),
                          _buildGlowingCta(context),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SCHEDULR.AI',
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.cream,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/login'),
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(color: AppColors.cream),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedules that\nresolve themselves.',
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.cream,
            fontWeight: FontWeight.w700,
            fontSize: 48,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 520,
          child: Text(
            'AI-generated, conflict-free timetables with automatic '
            'substitute allocation — for schools, colleges, and teams.',
            style: GoogleFonts.inter(
              color: AppColors.paleYellow,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Glowing Gradient CTA Button with Ambient Glow Behind It
  Widget _buildGlowingCta(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigoGlow.withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.violetGlow.withValues(alpha: 0.3),
            blurRadius: 36,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [
              AppColors.cream,
              AppColors.paleYellow,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Text(
            'Get Started',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter drawing a grid with animated glowing intersection nodes
class GlowingGridPainter extends CustomPainter {
  final double progress;

  GlowingGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const double step = 48.0;
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    // 1. Draw Grid Lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw Pulsing Glowing Nodes at Intersections
    int index = 0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        index++;
        // Apply sine phase offsets so nodes pulse at different times
        final double phase = math.sin((progress * math.pi * 2) + index * 0.5);
        final double alpha = ((phase + 1) / 2) * 0.4;

        if (alpha > 0.15) {
          final glowPaint = Paint()
            ..color = (index % 2 == 0 ? AppColors.indigoGlow : AppColors.violetGlow)
                .withValues(alpha: alpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

          final corePaint = Paint()
            ..color = AppColors.cream.withValues(alpha: alpha + 0.2);

          canvas.drawCircle(Offset(x, y), 3.0, glowPaint);
          canvas.drawCircle(Offset(x, y), 1.5, corePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GlowingGridPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}