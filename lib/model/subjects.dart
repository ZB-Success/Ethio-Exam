import 'package:flutter/material.dart';

class Subject {
  final String name;
  final IconData icon;
  final Color color;
  final bool locked;

  Subject({
    required this.name,
    required this.icon,
    required this.color,
    required this.locked,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      icon: _iconFromString(json['icon']),
      color: Color(int.parse(json['color'])),
      locked: json['locked'],
    );
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      case 'opacity':
        return Icons.opacity;
      case 'calculate':
        return Icons.calculate;
      case 'gavel':
        return Icons.gavel;
      case 'history':
        return Icons.history;
      default:
        return Icons.help_outline;
    }
  }
} 
