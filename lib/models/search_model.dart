class SearchData {
  String id;
  String title;
  String thumbnailUrl;
  String publishedAt;
  String description;

  SearchData({this.id, this.title, this.thumbnailUrl, this.publishedAt, this.description});

  factory SearchData.fromMap(Map <String, dynamic> map){
    return SearchData(
        id: map['id']['videoId'],
      title: map['snippet']['title'],
      thumbnailUrl: map['snippet']['thumbnails']['default']['url'],
      publishedAt: map['snippet']['publishedAt'],
       description: map['snippet']['description'],
    );
  } 
}