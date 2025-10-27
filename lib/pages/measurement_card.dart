import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeasurementCard extends StatelessWidget {
  final String assetName;
  final String label;
  final String value;

  const MeasurementCard({
    super.key,
    required this.assetName,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  assetName,
                  width: 14,
                  height: 14,
                  colorFilter: ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFE8E8E8), width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
