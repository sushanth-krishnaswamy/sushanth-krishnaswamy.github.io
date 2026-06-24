import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Footer widget — mirrors the HTML footer.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Text(
          '© 2026 Pani, Puri & Paps. STAY FUNKY.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
