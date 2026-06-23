import 'package:flutter/material.dart';

class ProgressSteps extends StatelessWidget {
  final int langkahSaatIni;
  final int totalLangkah;
  final String label;

  const ProgressSteps({
    super.key,
    required this.langkahSaatIni,
    required this.totalLangkah,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final progress = langkahSaatIni / totalLangkah;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(
              'Langkah $langkahSaatIni dari $totalLangkah',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: progress, minHeight: 6),
        ),
      ],
    );
  }
}
