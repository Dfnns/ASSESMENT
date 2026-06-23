import '../models/pasien.dart';
import '../models/pemeriksaan.dart';
import '../models/resep.dart';

/// Menyimpan data satu kunjungan pasien selagi berjalan melalui alur:
/// pendaftaran -> antrean -> pemeriksaan -> resep (opsional) -> pembayaran.
/// Dialirkan ke setiap screen lewat constructor, tanpa package state
/// management tambahan, supaya project tetap ringan dan mudah dibaca.
class KunjunganState {
  Pasien? pasien;
  String? idPoli;
  int? noAntrean;
  Pemeriksaan? pemeriksaan;
  Resep? resep;

  int get biayaPeriksa => pemeriksaan?.biayaPeriksa ?? 0;
  int get biayaObat => resep?.totalBiayaObat ?? 0;
  int get totalBiaya => biayaPeriksa + biayaObat;
}
