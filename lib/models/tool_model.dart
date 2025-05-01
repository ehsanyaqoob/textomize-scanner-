import '../core/exports.dart';

class Tool {
  final String label;
  final IconData icon;
  final Widget view;

  Tool({required this.label, required this.icon, required this.view});

  // Factory constructor to create Tool from Map
  factory Tool.fromMap(Map<String, dynamic> map) {
    return Tool(
      label: map['label'],
      icon: map['icon'],
      view: map['view'],
    );
  }
}
