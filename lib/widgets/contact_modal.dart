import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contact-info dialog — mirrors the HTML contact modal.
/// Shows stall location (Coles Street Market, Tuesday 4pm–7pm) and a
/// "View on Google Maps" button.
class ContactModal extends StatelessWidget {
  const ContactModal({super.key});

  static const _mapsUrl = 'https://share.google/4uIeIVb157g2wtErm';

  Future<void> _openMaps() async {
    final uri = Uri.parse(_mapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 576),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location icon badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.green[700],
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'VISIT OUR STALL',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.syne(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rich location text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'Find us at '),
                        const TextSpan(
                          text: 'Coles Street Market',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: ' every '),
                        TextSpan(
                          text: 'Tuesday',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),
                        ),
                        const TextSpan(text: ' from '),
                        const TextSpan(
                          text: '4pm to 7pm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Google Maps button
                  ElevatedButton.icon(
                    onPressed: _openMaps,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      'VIEW ON GOOGLE MAPS',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 20),
                    ),
                  ),
                ],
              ),
            ),
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
