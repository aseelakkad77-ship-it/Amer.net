import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Watermark extends StatelessWidget {
  final Widget child;

  const Watermark({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 8,
          right: 8,
          child: Opacity(
            opacity: 0.4,
            child: Text(
              'Powered by aseel.kh',
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
