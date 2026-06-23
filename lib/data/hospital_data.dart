import '../models/dokter.dart';
import '../models/obat.dart';
import '../models/pasien.dart';
import '../models/pembayaran.dart';
import '../models/pemeriksaan.dart';
import '../models/poli.dart';
import '../models/resep.dart';

/// "Database" sederhana yang disimpan di memori (sesuai prototipe).
/// Untuk produksi, ganti dengan REST API / SQLite / Firebase, dst -
/// struktur model & ERD-nya tetap sama.
class HospitalData {
  HospitalData._();

  // ----- Data master (seed) -----
  static final List<Poli> daftarPoli = [
    const Poli(idPoli: 'POL01', namaPoli: 'Poli umum', lokasi: 'Lantai 1'),
    const Poli(idPoli: 'POL02', namaPoli: 'Poli gigi', lokasi: 'Lantai 1'),
    const Poli(idPoli: 'POL03', namaPoli: 'Poli anak', lokasi: 'Lantai 2'),
    const Poli(
      idPoli: 'POL04',
      namaPoli: 'Poli penyakit dalam',
      lokasi: 'Lantai 2',
    ),
  ];

  static final List<Dokter> daftarDokter = [
    const Dokter(
      idDokter: 'DOK01',
      idPoli: 'POL01',
      namaDokter: 'dr. Amelia Putri',
      spesialisasi: 'Dokter umum',
    ),
    const Dokter(
      idDokter: 'DOK02',
      idPoli: 'POL02',
      namaDokter: 'drg. Bima Saputra',
      spesialisasi: 'Dokter gigi',
    ),
    const Dokter(
      idDokter: 'DOK03',
      idPoli: 'POL03',
      namaDokter: 'dr. Citra Lestari, Sp.A',
      spesialisasi: 'Spesialis anak',
    ),
    const Dokter(
      idDokter: 'DOK04',
      idPoli: 'POL04',
      namaDokter: 'dr. Dimas Pratama, Sp.PD',
      spesialisasi: 'Spesialis penyakit dalam',
    ),
  ];

  static final List<Obat> daftarObat = [
    const Obat(
      idObat: 'OBT01',
      namaObat: 'Paracetamol 500mg',
      satuan: 'tablet',
      hargaSatuan: 1000,
      stok: 200,
    ),
    const Obat(
      idObat: 'OBT02',
      namaObat: 'Amoxicillin 500mg',
      satuan: 'tablet',
      hargaSatuan: 2500,
      stok: 150,
    ),
    const Obat(
      idObat: 'OBT03',
      namaObat: 'Vitamin C',
      satuan: 'tablet',
      hargaSatuan: 1500,
      stok: 300,
    ),
    const Obat(
      idObat: 'OBT04',
      namaObat: 'Obat batuk sirup',
      satuan: 'botol',
      hargaSatuan: 18000,
      stok: 80,
    ),
    const Obat(
      idObat: 'OBT05',
      namaObat: 'Antasida',
      satuan: 'tablet',
      hargaSatuan: 1200,
      stok: 120,
    ),
  ];

  /// Biaya periksa dasar per poli (contoh tarif).
  static int biayaPeriksaDasar(String idPoli) {
    switch (idPoli) {
      case 'POL02':
        return 75000;
      case 'POL03':
      case 'POL04':
        return 100000;
      default:
        return 50000;
    }
  }

  // ----- Data transaksi (in-memory, bertambah selama aplikasi berjalan) -----
  static final List<Pasien> daftarPasien = [];
  static final List<Pemeriksaan> daftarPemeriksaan = [];
  static final List<Resep> daftarResep = [];
  static final List<Pembayaran> daftarPembayaran = [];

  static final Map<String, int> _antreanTerakhirPerPoli = {};

  // ----- Generator nomor / id -----
  static String generateNoRkmMedis() {
    final nomor = daftarPasien.length + 1;
    return 'RM${nomor.toString().padLeft(6, '0')}';
  }

  static int generateNoAntrean(String idPoli) {
    final terakhir = _antreanTerakhirPerPoli[idPoli] ?? 0;
    final berikutnya = terakhir + 1;
    _antreanTerakhirPerPoli[idPoli] = berikutnya;
    return berikutnya;
  }

  static String generateIdPeriksa() {
    final nomor = daftarPemeriksaan.length + 1;
    return 'PRX${nomor.toString().padLeft(6, '0')}';
  }

  static String generateIdResep() {
    final nomor = daftarResep.length + 1;
    return 'RSP${nomor.toString().padLeft(6, '0')}';
  }

  static String generateIdPembayaran() {
    final nomor = daftarPembayaran.length + 1;
    return 'BYR${nomor.toString().padLeft(6, '0')}';
  }

  static String generateNoKwitansi() {
    final nomor = daftarPembayaran.length + 1;
    final tahun = DateTime.now().year;
    return 'KW$tahun${nomor.toString().padLeft(5, '0')}';
  }

  // ----- Helper pencarian -----
  static Pasien? cariPasienByNoRM(String noRM) {
    for (final p in daftarPasien) {
      if (p.noRkmMedis.toLowerCase() == noRM.toLowerCase()) return p;
    }
    return null;
  }

  static Poli poliById(String idPoli) =>
      daftarPoli.firstWhere((p) => p.idPoli == idPoli);

  static Dokter dokterById(String idDokter) =>
      daftarDokter.firstWhere((d) => d.idDokter == idDokter);

  static List<Dokter> dokterByPoli(String idPoli) =>
      daftarDokter.where((d) => d.idPoli == idPoli).toList();
}
