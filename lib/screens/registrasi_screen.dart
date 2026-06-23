import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/pasien.dart';
import '../state/kunjungan_state.dart';
import '../utils/formatters.dart';
import '../widgets/progress_steps.dart';
import 'antrean_screen.dart';

class RegistrasiScreen extends StatefulWidget {
  final KunjunganState state;

  const RegistrasiScreen({super.key, required this.state});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _ktpController = TextEditingController();
  final _bpjsController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';
  DateTime? _tglLahir;

  @override
  void dispose() {
    _namaController.dispose();
    _ktpController.dispose();
    _bpjsController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggalLahir() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (hasil != null) {
      setState(() => _tglLahir = hasil);
    }
  }

  void _simpanRegistrasi() {
    if (!_formKey.currentState!.validate()) return;
    if (_tglLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir wajib diisi')),
      );
      return;
    }

    final pasienBaru = Pasien(
      noRkmMedis: HospitalData.generateNoRkmMedis(),
      namaPasien: _namaController.text.trim(),
      noKtp: _ktpController.text.trim(),
      noBpjs: _bpjsController.text.trim().isEmpty ? null : _bpjsController.text.trim(),
      tglLahir: _tglLahir!,
      jenisKelamin: _jenisKelamin,
      alamat: _alamatController.text.trim(),
      noTelepon: _teleponController.text.trim(),
    );

    HospitalData.daftarPasien.add(pasienBaru);
    widget.state.pasien = pasienBaru;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrasi berhasil'),
        content: Text(
          'Nomor rekam medis Anda: ${pasienBaru.noRkmMedis}\n\n'
          'Mohon dicatat untuk kunjungan berikutnya.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => AntreanScreen(state: widget.state)),
              );
            },
            child: const Text('Lanjut ambil antrean'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi pasien baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ProgressSteps(
              langkahSaatIni: 2,
              totalLangkah: 9,
              label: 'Registrasi pasien baru',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ktpController,
              decoration: const InputDecoration(labelText: 'No. KTP'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bpjsController,
              decoration: const InputDecoration(labelText: 'No. BPJS (opsional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pilihTanggalLahir,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Tanggal lahir'),
                child: Text(_tglLahir == null ? 'Pilih tanggal' : formatTanggal(_tglLahir!)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              decoration: const InputDecoration(labelText: 'Jenis kelamin'),
              items: const [
                DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (v) => setState(() => _jenisKelamin = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              maxLines: 2,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _teleponController,
              decoration: const InputDecoration(labelText: 'No. telepon'),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _simpanRegistrasi,
              child: const Text('Simpan & buat nomor rekam medis'),
            ),
          ],
        ),
      ),
    );
  }
}
