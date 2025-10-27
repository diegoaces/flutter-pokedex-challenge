import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ElementChip extends StatelessWidget {
  const ElementChip({
    required this.color,
    super.key,
    required this.title,
    required this.element,
  });

  final Color color;
  final String title;
  final String element;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SvgPicture.asset(
                        element,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
