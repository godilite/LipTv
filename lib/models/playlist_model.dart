class Playlist {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final int itemCount;

  Playlist({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.itemCount,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      title: map['snippet']['title'],
      thumbnailUrl: map['snippet']['thumbnails']['high']['url'],
      channelTitle: map['snippet']['channelTitle'],
      itemCount: map['contentDetails']['itemCount']
    );
  }
}