import 'package:flutter/material.dart';
import 'package:textomize/core/exports.dart';
import 'package:textomize/widgets/custom_text_widgets.dart';
import 'pre_feature_card.dart';
import 'pre_placeholder.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  bool isLoading = true; 
  final List<String> premiumFeatures = [
    'Unlimited Scans',
    'Cloud Backup',
    'Ad-Free Experience',
    'Enhanced OCR',
  ];

  @override
  void initState() {
    super.initState();
    _loadPremiumData();
  }

  Future<void> _loadPremiumData() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const PremiumShimmerPlaceholder()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Upgrade to Premium',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: premiumFeatures.length,
                      itemBuilder: (context, index) {
                        return PremiumFeatureCard(
                          title: premiumFeatures[index],
                          description:
                              'Detailed description of ${premiumFeatures[index]}',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: 'Upgrade Now',
                    onTap: () {},
                    fillColor: true,
                  )
                ],
              ),
      ),
    );
  }
}
