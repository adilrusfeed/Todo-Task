import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {this.actions,
      this.titleText = '',
      this.title,
      this.leading,
      this.centerTitle = false,
      this.backgroundColor = Colors.transparent,
      this.foregroundColor = Colors.black,
      this.automaticallyImplyLeading = true,
      this.titleSize = 16});

  final List<Widget>? actions;
  Widget? leading;
  Widget? title;
  final String titleText;
  final bool centerTitle;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool automaticallyImplyLeading;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: title ??
          CustomText(
            text: titleText,
            size: titleSize,
            color: foregroundColor,
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign = TextAlign.center,
    this.bold = true,
    this.overflow = false,
    this.size = 15,
  }) : super(key: key);

  final String text;
  final TextAlign textAlign;
  final Color? color;
  final bool bold;
  final bool overflow;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: overflow ? 1 : null,
      overflow: overflow ? TextOverflow.ellipsis : null,
      style: GoogleFonts.ubuntu(
        color: color ?? Colors.black,
        fontSize: size,
        fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      ),
    );
  }
}
