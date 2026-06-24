import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fixed top navigation bar with the brand name and a "CONTACT US" button.
class NavBar extends StatelessWidget {
  final VoidCallback onContactTap;

  const NavBar({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pani, Puri & Paps',
            style: GoogleFonts.syne(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          ElevatedButton(
            onPressed: onContactTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: Text(
              'CONTACT US',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
