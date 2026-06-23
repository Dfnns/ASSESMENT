class Pasien {
  final String noRkmMedis;
  final String namaPasien;
  final String noKtp;
  final String? noBpjs;
  final DateTime tglLahir;
  final String jenisKelamin;
  final String alamat;
  final String noTelepon;

  const Pasien({
    required this.noRkmMedis,
    required this.namaPasien,
    required this.noKtp,
    this.noBpjs,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.noTelepon,
  });
}
