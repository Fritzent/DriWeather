import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../resources/style_config.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.includeIcon});
  final VoidCallback onTap;
  final String buttonText;
  final bool includeIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: FontList.font20),
        decoration: BoxDecoration(
          color: ColorList.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.25),
              offset: Offset(-6, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(2, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              offset: Offset(-4, 8),
              blurRadius: 50,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 11,
            children: [
              Text(
                buttonText,
                style: GoogleFonts.overpass(
                    fontSize: FontList.font18,
                    fontWeight: FontWeight.w500,
                    color: ColorList.blueColor),
              ),
              if (includeIcon)
                SvgPicture.asset(
                  alignment: Alignment.topCenter,
                  'assets/icons/up.svg',
                )
            ],
          ),
        ),
      ),
    );
  }
}
