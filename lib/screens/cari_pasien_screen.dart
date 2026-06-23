import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../state/kunjungan_state.dart';
import '../widgets/progress_steps.dart';
import 'antrean_screen.dart';

class CariPasienScreen extends StatefulWidget {
  final KunjunganState state;

  const CariPasienScreen({super.key, required this.state});

  @override
  State<CariPasienScreen> createState() => _CariPasienScreenState();
}

class _CariPasienScreenState extends State<CariPasienScreen> {
  final _noRmController = TextEditingController();
  String? _pesanError;

  @override
  void dispose() {
    _noRmController.dispose();
    super.dispose();
  }

  void _cariPasien() {
    final pasien = HospitalData.cariPasienByNoRM(_noRmController.text.trim());
    if (pasien == null) {
      setState(() {
        _pesanError =
            'Nomor rekam medis tidak ditemukan. Periksa kembali atau daftar sebagai pasien baru.';
      });
      return;
    }
    widget.state.pasien = pasien;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AntreanScreen(state: widget.state)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari data pasien')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressSteps(
              langkahSaatIni: 2,
              totalLangkah: 9,
              label: 'Cari pasien terdaftar',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noRmController,
              decoration: const InputDecoration(
                labelText: 'Nomor rekam medis (contoh: RM000001)',
              ),
            ),
            if (_pesanError != null) ...[
              const SizedBox(height: 8),
              Text(_pesanError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _cariPasien,
              child: const Text('Cari & ambil nomor antrean'),
            ),
          ],
        ),
      ),
    );
  }
}
