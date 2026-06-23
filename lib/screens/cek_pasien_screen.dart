import 'package:flutter/material.dart';
import '../state/kunjungan_state.dart';
import '../widgets/progress_steps.dart';
import 'cari_pasien_screen.dart';
import 'registrasi_screen.dart';

class CekPasienScreen extends StatelessWidget {
  final KunjunganState state;

  const CekPasienScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek status pasien')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 2,
              totalLangkah: 9,
              label: 'Pasien baru?',
            ),
            const SizedBox(height: 16),
            Text(
              'Apakah Anda pasien baru di RS Sehat Sentosa?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.person_add_alt_outlined),
              label: const Text('Ya, pasien baru'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => RegistrasiScreen(state: state)),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.badge_outlined),
              label: const Text('Tidak, sudah terdaftar'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CariPasienScreen(state: state)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
