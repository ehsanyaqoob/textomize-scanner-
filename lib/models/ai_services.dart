import '../core/exports.dart';

class AiService {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPremium;

  AiService({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.isPremium,
  });
}
