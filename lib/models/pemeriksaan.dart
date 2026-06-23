class Pemeriksaan {
  final String idPeriksa;
  final String noRkmMedis;
  final String idDokter;
  final String idPoli;
  final int noAntrean;
  final DateTime tglPeriksa;
  final String diagnosis;
  final String tindakan;
  final int biayaPeriksa;
  final bool perluResep;

  const Pemeriksaan({
    required this.idPeriksa,
    required this.noRkmMedis,
    required this.idDokter,
    required this.idPoli,
    required this.noAntrean,
    required this.tglPeriksa,
    required this.diagnosis,
    required this.tindakan,
    required this.biayaPeriksa,
    required this.perluResep,
  });
}
