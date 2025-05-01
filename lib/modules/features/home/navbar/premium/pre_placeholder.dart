import 'package:flutter/material.dart';
import '../../../../../widgets/shimmer_widget.dart';

class PremiumShimmerPlaceholder extends StatelessWidget {
  const PremiumShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const ShimmerWidget.circular(
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerWidget.rectangular(
                        width: double.infinity,
                        height: 16,
                      ),
                      SizedBox(height: 8),
                      ShimmerWidget.rectangular(
                        width: 150,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
