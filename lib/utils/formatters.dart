String formatRupiah(int value) {
  final str = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    final posFromRight = str.length - i;
    buffer.write(str[i]);
    if (posFromRight > 1 && posFromRight % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp $buffer';
}

String formatTanggal(DateTime date) {
  const bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  return '${date.day} ${bulan[date.month - 1]} ${date.year}';
}
