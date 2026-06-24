import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/menu_item.dart';
import '../painters/menu_icon_painters.dart';
import '../theme/colors.dart';

/// The "Flavor Explosion" menu section with three animated menu cards.
class MenuSection extends StatelessWidget {
  /// Drives the staggered card slide-in animation.
  final Animation<double> animation;

  const MenuSection({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 16),
      child: Column(
        children: [
          Text(
            'THE FLAVOR EXPLOSION',
            style: GoogleFonts.syne(
              fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildCards(),
                )
              : Column(children: _buildCards()),
        ],
      ),
    );
  }

  List<Widget> _buildCards() {
    const delays = [0.0, 0.15, 0.30];
    final spacing = kMenuItems.length;

    return [
      for (int i = 0; i < spacing; i++) ...[
        _AnimatedMenuCard(
          item: kMenuItems[i],
          animation: animation,
          delayStart: delays[i],
        ),
        if (i < spacing - 1) const SizedBox(width: 24, height: 24),
      ],
    ];
  }
}

class _AnimatedMenuCard extends StatelessWidget {
  final MenuItem item;
  final Animation<double> animation;
  final double delayStart;

  const _AnimatedMenuCard({
    required this.item,
    required this.animation,
    this.delayStart = 0,
  });

  @override
  Widget build(BuildContext context) {
    final delayed = CurvedAnimation(
      parent: animation,
      curve: Interval(
        delayStart,
        min(delayStart + 0.7, 1.0),
        curve: const Cubic(0.16, 1, 0.3, 1),
      ),
    );

    return AnimatedBuilder(
      animation: delayed,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, 50 * (1 - delayed.value)),
        child: Opacity(opacity: delayed.value, child: child),
      ),
      child: _MenuCard(item: item),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 64, height: 64, child: _buildIcon()),
          const SizedBox(height: 24),
          Text(
            item.name.toUpperCase(),
            style: GoogleFonts.syne(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: GoogleFonts.outfit(
              color: Colors.grey[600],
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item.price,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (item.icon) {
      case MenuIcon.paniPuri:
        return CustomPaint(painter: const PaniPuriIconPainter());
      case MenuIcon.filterCoffee:
        return const Center(
          child: Text('☕', style: TextStyle(fontSize: 48)),
        );
      case MenuIcon.masalaChai:
        return CustomPaint(painter: const MasalaChaiIconPainter());
    }
  }
}
