class Section {
  final String id;
  final String title;
  final List playlists;

  Section({
    this.id,
    this.title,
    this.playlists,
  });

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      title: map['snippet']['title'],
      playlists: map['contentDetails']['playlists']
    );
  }
}