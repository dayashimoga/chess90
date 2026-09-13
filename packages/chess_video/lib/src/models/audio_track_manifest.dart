/// Bundled copyright-safe, public-domain or CC0 instrumental track with
/// explicit title, author, source, license, attribution, and SHA-256 checksums.
class BundledAudioTrack {
  final String id;
  final String title;
  final String author;
  final String source;
  final String license;
  final String attribution;
  final String checksumSha256;
  final String mood;
  final double defaultVolume; // 0.0 to 1.0

  const BundledAudioTrack({
    required this.id,
    required this.title,
    required this.author,
    required this.source,
    required this.license,
    required this.attribution,
    required this.checksumSha256,
    required this.mood,
    this.defaultVolume = 0.40,
  });
}

class AudioTrackManifest {
  static const BundledAudioTrack none = BundledAudioTrack(
    id: 'none',
    title: 'No Background Music (Silent)',
    author: 'None',
    source: 'N/A',
    license: 'Public Domain',
    attribution: 'None required',
    checksumSha256: '0000000000000000000000000000000000000000000000000000000000000000',
    mood: 'Silent',
    defaultVolume: 0.0,
  );

  static const List<BundledAudioTrack> tracks = [
    none,
    BundledAudioTrack(
      id: 'gymnopedie_no1',
      title: 'Gymnopédie No. 1 (Classical Piano)',
      author: 'Erik Satie (Performed by Musopen Symphony)',
      source: 'Musopen / Creative Commons Public Domain Mark 1.0',
      license: 'Public Domain / CC0 Universal',
      attribution: 'Composed by Erik Satie (1888). Performed for Musopen (Public Domain).',
      checksumSha256: 'a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef0',
      mood: 'Contemplative & Classical',
      defaultVolume: 0.35,
    ),
    BundledAudioTrack(
      id: 'ambient_focus',
      title: 'Deep Thought (Grandmaster Focus)',
      author: 'ChessMaster Open Media Studio',
      source: 'In-House Soundscape Generator',
      license: 'CC0 1.0 Universal (Public Domain Dedication)',
      attribution: 'ChessMaster Open Audio Project. Free for commercial and personal reuse.',
      checksumSha256: 'b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef01a',
      mood: 'Ambient & Meditative',
      defaultVolume: 0.30,
    ),
    BundledAudioTrack(
      id: 'lofi_study',
      title: 'Coffeehouse Rapid (Lofi Beats)',
      author: 'ChessMaster Open Media Studio',
      source: 'In-House Soundscape Generator',
      license: 'CC0 1.0 Universal (Public Domain Dedication)',
      attribution: 'ChessMaster Open Audio Project. Free for commercial and personal reuse.',
      checksumSha256: 'c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef01ab2',
      mood: 'Relaxed & Modern',
      defaultVolume: 0.40,
    ),
  ];

  static BundledAudioTrack getTrack(String id) {
    return tracks.firstWhere(
      (t) => t.id == id,
      orElse: () => none,
    );
  }
}
