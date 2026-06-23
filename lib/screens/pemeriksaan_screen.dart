import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/dokter.dart';
import '../models/pemeriksaan.dart';
import '../state/kunjungan_state.dart';
import '../widgets/progress_steps.dart';
import 'kasir_screen.dart';
import 'resep_screen.dart';

class PemeriksaanScreen extends StatefulWidget {
  final KunjunganState state;

  const PemeriksaanScreen({super.key, required this.state});

  @override
  State<PemeriksaanScreen> createState() => _PemeriksaanScreenState();
}

class _PemeriksaanScreenState extends State<PemeriksaanScreen> {
  final _diagnosisController = TextEditingController();
  final _tindakanController = TextEditingController();
  late Dokter _dokterDipilih;
  bool _perluResep = false;

  @override
  void initState() {
    super.initState();
    _dokterDipilih = HospitalData.dokterByPoli(widget.state.idPoli!).first;
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _tindakanController.dispose();
    super.dispose();
  }

  void _simpanPemeriksaan() {
    if (_diagnosisController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diagnosis wajib diisi')),
      );
      return;
    }

    final pemeriksaan = Pemeriksaan(
      idPeriksa: HospitalData.generateIdPeriksa(),
      noRkmMedis: widget.state.pasien!.noRkmMedis,
      idDokter: _dokterDipilih.idDokter,
      idPoli: widget.state.idPoli!,
      noAntrean: widget.state.noAntrean!,
      tglPeriksa: DateTime.now(),
      diagnosis: _diagnosisController.text.trim(),
      tindakan: _tindakanController.text.trim(),
      biayaPeriksa: HospitalData.biayaPeriksaDasar(widget.state.idPoli!),
      perluResep: _perluResep,
    );

    HospitalData.daftarPemeriksaan.add(pemeriksaan);
    widget.state.pemeriksaan = pemeriksaan;

    final nextScreen = _perluResep
        ? ResepScreen(state: widget.state)
        : KasirScreen(state: widget.state);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final poli = HospitalData.poliById(widget.state.idPoli!);
    final dokterPoli = HospitalData.dokterByPoli(widget.state.idPoli!);

    return Scaffold(
      appBar: AppBar(title: const Text('Pemeriksaan dokter')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ProgressSteps(
            langkahSaatIni: 4,
            totalLangkah: 9,
            label: 'Pemeriksaan dokter',
          ),
          const SizedBox(height: 16),
          Text('${poli.namaPoli} • Antrean ${widget.state.noAntrean}'),
          const SizedBox(height: 16),
          DropdownButtonFormField<Dokter>(
            value: _dokterDipilih,
            decoration: const InputDecoration(labelText: 'Dokter pemeriksa'),
            items: dokterPoli
                .map((d) => DropdownMenuItem(value: d, child: Text(d.namaDokter)))
                .toList(),
            onChanged: (v) => setState(() => _dokterDipilih = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _diagnosisController,
            decoration: const InputDecoration(labelText: 'Diagnosis'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tindakanController,
            decoration: const InputDecoration(labelText: 'Tindakan'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Perlu resep obat?'),
            value: _perluResep,
            onChanged: (v) => setState(() => _perluResep = v),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _simpanPemeriksaan,
            child: Text(_perluResep ? 'Lanjut ke resep & farmasi' : 'Lanjut ke kasir'),
          ),
        ],
      ),
    );
  }
}
