import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const ContactAvatar({
    super.key,
    required this.name,
    this.radius = 20,
  });

  Color get avatarColor {
    const colors = [
      Color(0xFF5D38C8),
      Color(0xFF20A9E8),
      Color(0xFF5AA88A),
      Color(0xFFFF7D24),
      Color(0xFFE9509A),
      Color(0xFF32A8BA),
    ];

    final index = name.codeUnits.fold<int>(0, (sum, value) => sum + value);
    return colors[index % colors.length];
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarColor,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.72,
        ),
      ),
    );
  }
}
