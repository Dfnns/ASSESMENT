import 'package:flutter/material.dart';
import '../data/hospital_data.dart';
import '../models/detail_resep.dart';
import '../models/resep.dart';
import '../state/kunjungan_state.dart';
import '../utils/formatters.dart';
import '../widgets/progress_steps.dart';
import 'kasir_screen.dart';

class ResepScreen extends StatefulWidget {
  final KunjunganState state;

  const ResepScreen({super.key, required this.state});

  @override
  State<ResepScreen> createState() => _ResepScreenState();
}

class _ResepScreenState extends State<ResepScreen> {
  final Map<String, int> _jumlahDipilih = {};

  int get _totalSementara {
    var total = 0;
    for (final obat in HospitalData.daftarObat) {
      total += (_jumlahDipilih[obat.idObat] ?? 0) * obat.hargaSatuan;
    }
    return total;
  }

  void _simpanResep() {
    final dipilih = _jumlahDipilih.entries.where((e) => e.value > 0).toList();
    if (dipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu obat')),
      );
      return;
    }

    final idResep = HospitalData.generateIdResep();
    final detail = dipilih.map((entry) {
      final obat = HospitalData.daftarObat.firstWhere((o) => o.idObat == entry.key);
      return DetailResep(
        idDetailResep: 'DTL${idResep.substring(3)}_${obat.idObat}',
        idResep: idResep,
        idObat: obat.idObat,
        namaObat: obat.namaObat,
        hargaSatuan: obat.hargaSatuan,
        jumlah: entry.value,
      );
    }).toList();

    final resep = Resep(
      idResep: idResep,
      idPeriksa: widget.state.pemeriksaan!.idPeriksa,
      tglResep: DateTime.now(),
      statusResep: 'Selesai disiapkan',
      detail: detail,
    );

    HospitalData.daftarResep.add(resep);
    widget.state.resep = resep;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => KasirScreen(state: widget.state)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resep & farmasi')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ProgressSteps(
              langkahSaatIni: 5,
              totalLangkah: 9,
              label: 'Resep dikirim ke farmasi',
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              itemCount: HospitalData.daftarObat.length,
              itemBuilder: (context, index) {
                final obat = HospitalData.daftarObat[index];
                final jumlah = _jumlahDipilih[obat.idObat] ?? 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(obat.namaObat),
                    subtitle: Text('${formatRupiah(obat.hargaSatuan)} / ${obat.satuan}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: jumlah == 0
                              ? null
                              : () => setState(() => _jumlahDipilih[obat.idObat] = jumlah - 1),
                        ),
                        Text('$jumlah'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () =>
                              setState(() => _jumlahDipilih[obat.idObat] = jumlah + 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimasi biaya obat'),
                    Text(formatRupiah(_totalSementara), style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _simpanResep,
                  child: const Text('Simpan resep & lanjut ke kasir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
