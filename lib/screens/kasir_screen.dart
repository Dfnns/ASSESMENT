import 'package:flutter/material.dart';
import '../state/kunjungan_state.dart';
import '../utils/formatters.dart';
import '../widgets/progress_steps.dart';
import 'pembayaran_screen.dart';

class KasirScreen extends StatelessWidget {
  final KunjunganState state;

  const KasirScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian biaya')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 6,
              totalLangkah: 9,
              label: 'Hitung total biaya',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _baris('Biaya periksa', state.biayaPeriksa),
                    const Divider(),
                    _baris('Biaya obat', state.biayaObat),
                    const Divider(),
                    _baris('Total bayar', state.totalBiaya, tebal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PembayaranScreen(state: state)),
                );
              },
              child: const Text('Lanjut ke pembayaran'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, int nilai, {bool tebal = false}) {
    final style = TextStyle(
      fontWeight: tebal ? FontWeight.w500 : FontWeight.w400,
      fontSize: tebal ? 18 : 15,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatRupiah(nilai), style: style),
        ],
      ),
    );
  }
}
