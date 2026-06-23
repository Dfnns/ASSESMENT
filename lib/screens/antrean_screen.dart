import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/poli.dart';
import '../state/kunjungan_state.dart';
import '../widgets/progress_steps.dart';
import 'pemeriksaan_screen.dart';

class AntreanScreen extends StatefulWidget {
  final KunjunganState state;

  const AntreanScreen({super.key, required this.state});

  @override
  State<AntreanScreen> createState() => _AntreanScreenState();
}

class _AntreanScreenState extends State<AntreanScreen> {
  Poli? _poliDipilih;
  int? _noAntrean;

  void _ambilAntrean() {
    if (_poliDipilih == null) return;
    final nomor = HospitalData.generateNoAntrean(_poliDipilih!.idPoli);
    setState(() {
      _noAntrean = nomor;
      widget.state.idPoli = _poliDipilih!.idPoli;
      widget.state.noAntrean = nomor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pasien = widget.state.pasien!;
    return Scaffold(
      appBar: AppBar(title: const Text('Ambil nomor antrean')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 3,
              totalLangkah: 9,
              label: 'Ambil nomor antrean',
            ),
            const SizedBox(height: 16),
            Text('Pasien: ${pasien.namaPasien} (${pasien.noRkmMedis})'),
            const SizedBox(height: 16),
            Text('Pilih poli', style: Theme.of(context).textTheme.labelLarge),
            ...HospitalData.daftarPoli.map(
              (poli) => RadioListTile<Poli>(
                value: poli,
                groupValue: _poliDipilih,
                title: Text(poli.namaPoli),
                subtitle: Text(poli.lokasi),
                onChanged: _noAntrean == null ? (v) => setState(() => _poliDipilih = v) : null,
              ),
            ),
            const SizedBox(height: 12),
            if (_noAntrean == null)
              FilledButton(
                onPressed: _poliDipilih == null ? null : _ambilAntrean,
                child: const Text('Ambil nomor antrean'),
              )
            else ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Nomor antrean Anda', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text('$_noAntrean', style: Theme.of(context).textTheme.displayMedium),
                      Text(_poliDipilih!.namaPoli),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PemeriksaanScreen(state: widget.state)),
                  );
                },
                child: const Text('Antrean dipanggil, lanjut periksa'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
