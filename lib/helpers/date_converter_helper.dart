class DateConverterHelper {
  // 1. Hitung Umur Detail (Tahun, Bulan, Hari, Jam, Menit, Detik)
  static Map<String, int> hitungUmur(DateTime lahir, DateTime sekarang) {
    if (lahir.isAfter(sekarang)) {
      return {'tahun': 0, 'bulan': 0, 'hari': 0, 'jam': 0, 'menit': 0, 'detik': 0};
    }

    int tahun = sekarang.year - lahir.year;
    int bulan = sekarang.month - lahir.month;
    int hari = sekarang.day - lahir.day;
    int jam = sekarang.hour - lahir.hour;
    int menit = sekarang.minute - lahir.minute;
    int detik = sekarang.second - lahir.second;

    if (detik < 0) { menit--; detik += 60; }
    if (menit < 0) { jam--; menit += 60; }
    if (jam < 0) { hari--; jam += 24; }
    if (hari < 0) { bulan--; hari += DateTime(sekarang.year, sekarang.month, 0).day; }
    if (bulan < 0) { tahun--; bulan += 12; }

    return {
      'tahun': tahun < 0 ? 0 : tahun,
      'bulan': bulan < 0 ? 0 : bulan,
      'hari': hari < 0 ? 0 : hari,
      'jam': jam < 0 ? 0 : jam,
      'menit': menit < 0 ? 0 : menit,
      'detik': detik < 0 ? 0 : detik,
    };
  }

  // 2. Kalender Hijriah (Tabular/Sipil 30-tahun siklus)
  static const List<int> _kabisatHijri = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];

  static int _gregorianKeJulianDay(int y, int m, int d) {
    if (m < 3) { y -= 1; m += 12; }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524;
  }

  static String konversiHijriah(DateTime date) {
    final jd = _gregorianKeJulianDay(date.year, date.month, date.day);
    int daysSince = jd - 1948440; // Epok Hijriah (1 Muharram 1 H = 16 Juli 622 M)

    if (daysSince < 0) {
      return 'Sebelum Era Hijriah (1 H dimulai 16 Juli 622 M)';
    }

    final cycle = daysSince ~/ 10631;
    int r = daysSince - cycle * 10631;

    int yy = 1;
    while (true) {
      final panjang = _kabisatHijri.contains(yy) ? 355 : 354;
      if (r < panjang) break;
      r -= panjang;
      yy++;
    }
    final hYear = cycle * 30 + yy;
    final leap = _kabisatHijri.contains(yy);

    int month = 1;
    int sisaHari = r;
    while (true) {
      final panjangBulan = (month % 2 == 1) ? 30 : (month == 12 && leap ? 30 : 29);
      if (sisaHari < panjangBulan) break;
      sisaHari -= panjangBulan;
      month++;
    }

    const bulanHijriah = [
      'Muharram', 'Safar', 'Rabiul Awwal', 'Rabiul Akhir',
      'Jumadil Awwal', 'Jumadil Akhir', 'Rajab', 'Syaban',
      'Ramadhan', 'Syawwal', 'Dzulqadah', 'Dzulhijjah',
    ];
    return '${sisaHari + 1} ${bulanHijriah[month - 1]} $hYear H';
  }

  // 3. Weton Jawa (Hari + Pasaran + Neptu) via Julian Day (Akurat bebas batasan tahun)
  static Map<String, dynamic> konversiWeton(DateTime date) {
    const namaHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const neptuHari = {'Minggu': 5, 'Senin': 4, 'Selasa': 3, 'Rabu': 7, 'Kamis': 8, 'Jumat': 6, 'Sabtu': 9};
    const namaPasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
    const neptuPasaran = {'Legi': 5, 'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8};

    final hari = namaHari[date.weekday - 1];
    final jd = _gregorianKeJulianDay(date.year, date.month, date.day);
    int pIndex = jd % 5;
    if (pIndex < 0) pIndex += 5;
    final pasaran = namaPasaran[pIndex];

    return {
      'weton': '$hari $pasaran',
      'neptu': (neptuHari[hari] ?? 0) + (neptuPasaran[pasaran] ?? 0),
      'hari': hari,
      'pasaran': pasaran,
    };
  }

  // 4. Saka Bali (Tahun Saka = Masehi - 78, Nyepi acuan tahun baru)
  static const Map<int, ({int day, int month})> _tanggalNyepi = {
    2021: (day: 14, month: 3), 2022: (day: 3, month: 3), 2023: (day: 22, month: 3),
    2024: (day: 11, month: 3), 2025: (day: 29, month: 3), 2026: (day: 19, month: 3),
    2027: (day: 9, month: 3), 2028: (day: 26, month: 3),
  };

  static const List<String> _sasih = [
    'Kadasa', 'Jyestha', 'Sadha', 'Kasa', 'Karo', 'Katiga',
    'Kapat', 'Kalima', 'Kanem', 'Kapitu', 'Kawolu', 'Kasanga',
  ];

  static String konversiSakaBali(DateTime date) {
    if (date.year < 79) {
      return 'Sebelum Era Saka Bali (1 Saka dimulai 78 M)';
    }

    final nyepiTahunIni = _tanggalNyepi[date.year] != null
        ? DateTime(date.year, _tanggalNyepi[date.year]!.month, _tanggalNyepi[date.year]!.day)
        : DateTime(date.year, 3, 21);

    DateTime nyepiAcuan;
    int tahunSaka;
    if (!date.isBefore(nyepiTahunIni)) {
      nyepiAcuan = nyepiTahunIni;
      tahunSaka = date.year - 78;
    } else {
      final nyepiLalu = _tanggalNyepi[date.year - 1] != null
          ? DateTime(date.year - 1, _tanggalNyepi[date.year - 1]!.month, _tanggalNyepi[date.year - 1]!.day)
          : DateTime(date.year - 1, 3, 21);
      nyepiAcuan = nyepiLalu;
      tahunSaka = date.year - 1 - 78;
    }

    final hariSejakNyepi = date.difference(nyepiAcuan).inDays;
    int index = (hariSejakNyepi / 29.5).floor() % 12;
    if (index < 0) index += 12;

    return 'Tahun $tahunSaka Saka (Sasih ${_sasih[index]})';
  }
}
