import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-viewport hero section with "Crunchy Magic." heading and a bouncing
/// scroll indicator — mirrors the HTML hero section.
class HeroSection extends StatefulWidget {
  final double screenHeight;

  const HeroSection({super.key, required this.screenHeight});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Mirrors CSS @keyframes bounce
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -10.0), weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: -10.0, end: 0.0), weight: 10),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -5.0), weight: 10),
      TweenSequenceItem(
          tween: Tween(begin: -5.0, end: 0.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.screenHeight,
      child: Stack(
        children: [
          // Hero text shifted upward (~25 vh), mirroring hero-content transform
          Positioned(
            top: widget.screenHeight * 0.25,
            left: 0,
            right: 0,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.syne(
                      fontSize:
                          MediaQuery.of(context).size.width > 768 ? 96 : 60,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: Colors.black,
                    ),
                    children: const [
                      TextSpan(text: 'CRUNCHY\n'),
                      TextSpan(
                        text: 'MAGIC.',
                        style: TextStyle(color: Color(0xFF4CAF50)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Scroll to pop the flavor',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Bouncing scroll arrow
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _bounceAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _bounceAnim.value),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 32,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
