class LearningSite {
  final String name;
  final String description;
  final String imageUrl;
  final String link;

  LearningSite({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.link,
  });
}

final List<LearningSite> learningSites = [
  LearningSite(
    name: 'Dart Dev',
    description: 'Platform resmi untuk mendalami bahasa pemrograman Dart, mencakup konsep dasar, null safety, dan fitur lanjutan.',
    imageUrl: 'https://image.thum.io/get/width/800/https://dart.dev',
    link: 'https://dart.dev',
  ),
  LearningSite(
    name: 'Code With Andrea',
    description: 'Blog dan video tutorial dari Andrea Bizzotto yang membahas Flutter dari level dasar hingga expert.',
    imageUrl: 'https://image.thum.io/get/width/800/https://codewithandrea.com',
    link: 'https://codewithandrea.com',
  ),
  LearningSite(
    name: 'Reso Coder',
    description: 'Tutorial mendalam tentang Flutter dengan pendekatan arsitektur yang solid seperti Clean Architecture dan Bloc.',
    imageUrl: 'https://image.thum.io/get/width/800/https://resocoder.com',
    link: 'https://resocoder.com',
  ),
  LearningSite(
    name: 'FlutterFlow',
    description: 'Platform no-code yang memungkinkan kamu membangun aplikasi Flutter dengan desain visual interaktif.',
    imageUrl: 'https://image.thum.io/get/width/800/https://flutterflow.io',
    link: 'https://flutterflow.io',
  ),
  LearningSite(
    name: 'Flutter Dev',
    description: 'Sumber resmi untuk mempelajari Flutter—terdapat dokumentasi lengkap, panduan UI, serta panduan interaktif.',
    imageUrl: 'https://image.thum.io/get/width/800/https://flutter.dev',
    link: 'https://flutter.dev',
  ),
  LearningSite(
    name: 'Flutter YouTube',
    description: 'Channel YouTube resmi Flutter yang berisi video tutorial, pengumuman fitur baru, dan event developer.',
    imageUrl: 'https://image.thum.io/get/width/800/https://www.youtube.com/c/flutterdev',
    link: 'https://www.youtube.com/c/flutterdev',
  ),
];
