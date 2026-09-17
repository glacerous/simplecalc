class DateConverterHelper {
  // 1. Umur Detail
  static Map<String, int> hitungUmur(DateTime lahir, DateTime sekarang) {
    int tahun = sekarang.year - lahir.year;
    int bulan = sekarang.month - lahir.month;
    int hari = sekarang.day - lahir.day;
    int jam = sekarang.hour - lahir.hour;
    int menit = sekarang.minute - lahir.minute;
    int detik = sekarang.second - lahir.second;

    if (detik < 0) {
      menit--;
      detik += 60;
    }
    if (menit < 0) {
      jam--;
      menit += 60;
    }
    if (jam < 0) {
      hari--;
      jam += 24;
    }
    if (hari < 0) {
      bulan--;
      hari += DateTime(sekarang.year, sekarang.month, 0).day;
    }
    if (bulan < 0) {
      tahun--;
      bulan += 12;
    }

    return {
      'tahun': tahun < 0 ? 0 : tahun,
      'bulan': bulan < 0 ? 0 : bulan,
      'hari': hari < 0 ? 0 : hari,
      'jam': jam < 0 ? 0 : jam,
      'menit': menit < 0 ? 0 : menit,
      'detik': detik < 0 ? 0 : detik,
    };
  }

  // 2. Kalender Hijriah
  static String konversiHijriah(DateTime date) {
    int d = date.day;
    int m = date.month;
    int y = date.year;

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int jd = (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() + ((43 * l) / 15238).floor();
    l = l - ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() - ((15238 * j) / 43).floor() + 29;
    int hMonth = ((24 * l) / 709).floor();
    int hDay = l - ((709 * hMonth) / 24).floor();
    int hYear = 30 * n + j - 30;

    const bulanHijriah = [
      'Muharram', 'Safar', 'Rabiul Awwal', 'Rabiul Akhir',
      'Jumadil Awwal', 'Jumadil Akhir', 'Rajab', 'Syaban',
      'Ramadhan', 'Syawwal', 'Dzulqadah', 'Dzulhijjah'
    ];

    String namaBulan = (hMonth >= 1 && hMonth <= 12) ? bulanHijriah[hMonth - 1] : 'Bulan $hMonth';
    return '$hDay $namaBulan $hYear H';
  }

  // 3. Weton Jawa
  static Map<String, dynamic> konversiWeton(DateTime date) {
    const namaHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const neptuHari = {'Minggu': 5, 'Senin': 4, 'Selasa': 3, 'Rabu': 7, 'Kamis': 8, 'Jumat': 6, 'Sabtu': 9};
    const namaPasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
    const neptuPasaran = {'Legi': 5, 'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8};

    final hari = namaHari[date.weekday - 1];
    final diff = date.difference(DateTime.utc(1970, 1, 1)).inDays;
    int pIndex = (diff + 3) % 5;
    if (pIndex < 0) pIndex += 5;
    final pasaran = namaPasaran[pIndex];

    int nHari = neptuHari[hari] ?? 0;
    int nPasaran = neptuPasaran[pasaran] ?? 0;

    return {
      'weton': '$hari $pasaran',
      'neptu': nHari + nPasaran,
      'hari': hari,
      'pasaran': pasaran,
    };
  }

  // 4. Saka Bali
  static String konversiSakaBali(DateTime date) {
    int tahunSaka = date.year - 78;
    const sasih = [
      'Kasa', 'Karo', 'Katiga', 'Kapat', 'Kalima', 'Kanem',
      'Kapitu', 'Kawalu', 'Kasanga', 'Kadasa', 'Jyestha', 'Asadha'
    ];
    String namaSasih = sasih[(date.month + 5) % 12];
    return 'Tahun $tahunSaka Saka (Sasih $namaSasih)';
  }
}
