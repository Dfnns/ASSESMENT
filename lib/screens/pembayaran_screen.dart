import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/pembayaran.dart';
import '../state/kunjungan_state.dart';
import '../utils/formatters.dart';
import '../widgets/progress_steps.dart';
import 'kwitansi_screen.dart';

class PembayaranScreen extends StatefulWidget {
  final KunjunganState state;

  const PembayaranScreen({super.key, required this.state});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  String _metode = 'Tunai';

  void _proses({required bool berhasil}) {
    if (!berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran gagal, silakan ulangi proses pembayaran')),
      );
      return;
    }

    final pembayaran = Pembayaran(
      idPembayaran: HospitalData.generateIdPembayaran(),
      idPeriksa: widget.state.pemeriksaan!.idPeriksa,
      tglBayar: DateTime.now(),
      biayaPeriksa: widget.state.biayaPeriksa,
      biayaObat: widget.state.biayaObat,
      metodeBayar: _metode,
      noKwitansi: HospitalData.generateNoKwitansi(),
    );

    HospitalData.daftarPembayaran.add(pembayaran);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => KwitansiScreen(state: widget.state, pembayaran: pembayaran),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 7,
              totalLangkah: 9,
              label: 'Pasien membayar',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total yang harus dibayar', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(widget.state.totalBiaya),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _metode,
              decoration: const InputDecoration(labelText: 'Metode pembayaran'),
              items: const [
                DropdownMenuItem(value: 'Tunai', child: Text('Tunai')),
                DropdownMenuItem(value: 'Debit/Kredit', child: Text('Debit/Kredit')),
                DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
              ],
              onChanged: (v) => setState(() => _metode = v!),
            ),
            const SizedBox(height: 24),
            Text('Simulasi kasir (demo)', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Pembayaran berhasil'),
              onPressed: () => _proses(berhasil: true),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.error_outline),
              label: const Text('Pembayaran gagal, coba lagi'),
              onPressed: () => _proses(berhasil: false),
            ),
          ],
        ),
      ),
    );
  }
}
