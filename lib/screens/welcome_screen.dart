import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../state/kunjungan_state.dart';
import 'cek_pasien_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.local_hospital_outlined,
                  size: 48,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'RS Sehat Sentosa',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Layanan rawat jalan',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const _RingkasanPoli(),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CekPasienScreen(state: KunjunganState()),
                    ),
                  );
                },
                child: const Text('Mulai pelayanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingkasanPoli extends StatelessWidget {
  const _RingkasanPoli();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Poli yang tersedia hari ini', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            ...HospitalData.daftarPoli.map(
              (poli) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6),
                    const SizedBox(width: 8),
                    Expanded(child: Text(poli.namaPoli)),
                    Text(poli.lokasi, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
