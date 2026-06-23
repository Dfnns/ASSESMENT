import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/pembayaran.dart';
import '../state/kunjungan_state.dart';
import '../utils/formatters.dart';
import '../widgets/progress_steps.dart';
import 'welcome_screen.dart';

class KwitansiScreen extends StatelessWidget {
  final KunjunganState state;
  final Pembayaran pembayaran;

  const KwitansiScreen({super.key, required this.state, required this.pembayaran});

  @override
  Widget build(BuildContext context) {
    final pasien = state.pasien!;
    final periksa = state.pemeriksaan!;
    final poli = HospitalData.poliById(periksa.idPoli);
    final dokter = HospitalData.dokterById(periksa.idDokter);

    return Scaffold(
      appBar: AppBar(title: const Text('Kwitansi pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 9,
              totalLangkah: 9,
              label: 'Pelayanan selesai',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'No. kwitansi: ${pembayaran.noKwitansi}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        _baris('Nama pasien', pasien.namaPasien),
                        _baris('No. rekam medis', pasien.noRkmMedis),
                        _baris('Poli', poli.namaPoli),
                        _baris('Dokter', dokter.namaDokter),
                        _baris('Diagnosis', periksa.diagnosis),
                        _baris('Tanggal', formatTanggal(pembayaran.tglBayar)),
                        const Divider(),
                        _baris('Biaya periksa', formatRupiah(pembayaran.biayaPeriksa)),
                        _baris('Biaya obat', formatRupiah(pembayaran.biayaObat)),
                        _baris('Total dibayar', formatRupiah(pembayaran.totalBayar), tebal: true),
                        _baris('Metode bayar', pembayaran.metodeBayar),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Selesai, layani pasien berikutnya'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai, {bool tebal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nilai,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: tebal ? FontWeight.w500 : FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
