import 'package:flutter/material.dart';
import '../painters/puri_rain_painter.dart';
import '../theme/colors.dart';
import '../widgets/contact_modal.dart';
import '../widgets/footer.dart';
import '../widgets/hero_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/nav_bar.dart';

/// The main (and only) screen.
///
/// Manages:
/// * Scroll tracking → drives [PuriRainPainter]
/// * Menu-card stagger animation (triggered once on scroll-in)
/// * Animated background blobs
/// * Contact modal
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // ── scroll state ──────────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0;
  double _scrollOffset = 0;

  // ── blob animation ────────────────────────────────────────────────────────
  late final AnimationController _blobController;

  // ── menu-card animation ───────────────────────────────────────────────────
  late final AnimationController _menuController;
  bool _menuTriggered = false;

  // ── rain drops (generated once, deterministic) ────────────────────────────
  static final List<RainDropData> _rainDrops = generateRainDrops();

  @override
  void initState() {
    super.initState();

    _blobController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    // Total duration = 0.30 stagger start + 0.70 active window = 1.0 × 1200ms
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final viewportHeight = MediaQuery.of(context).size.height;
    final offset = _scrollController.offset;
    final progress = (offset / (viewportHeight * 0.9)).clamp(0.0, 1.2);

    setState(() {
      _scrollProgress = progress;
      _scrollOffset = offset;
    });

    // Start menu animation once the section scrolls into view
    if (!_menuTriggered && offset > viewportHeight * 0.15) {
      _menuTriggered = true;
      _menuController.forward();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _blobController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _showContactModal() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const ContactModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── gradient background ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [pastelMint, pastelPeach, pastelLavender],
              ),
            ),
          ),

          // ── animated blobs ──────────────────────────────────────────────
          AnimatedBuilder(
            animation: _blobController,
            builder: (_, __) {
              final t = _blobController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + t * 40,
                    left: -80 + t * 40,
                    child: _Blob(
                      size: 384,
                      color: const Color(0xFFBBDEFB),
                    ),
                  ),
                  Positioned(
                    bottom: -80 + (1 - t) * 40,
                    right: -80 + (1 - t) * 40,
                    child: _Blob(
                      size: 320,
                      color: const Color(0xFFF8BBD0),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── scrollable page content ─────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(screenHeight: screenSize.height),
                MenuSection(animation: _menuController),
                const AppFooter(),
              ],
            ),
          ),

          // ── puri + rain painter (non-interactive overlay) ───────────────
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: PuriRainPainter(
                    scrollProgress: _scrollProgress,
                    scrollOffset: _scrollOffset,
                    rainDrops: _rainDrops,
                    screenSize: screenSize,
                  ),
                ),
              ),
            ),
          ),

          // ── nav bar ─────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(onContactTap: _showContactModal),
          ),
        ],
      ),
    );
  }
}

/// Blurred soft circle used as background blob decoration.
class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
