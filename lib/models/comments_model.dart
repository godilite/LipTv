class CommentThread {

  final String id;
  final String profilePictureUrl;
  final String commentAuthor;
  final String commentText;
  final String publishDate;

  CommentThread({
    this.id,
    this.profilePictureUrl,
    this.commentAuthor,
    this.commentText,
    this.publishDate,
  });

  factory CommentThread.fromMap(Map<String, dynamic> map) {
    return CommentThread(
      id: map['id'],
      profilePictureUrl: map['snippet']['topLevelComment']['snippet']['authorProfileImageUrl'],
      commentAuthor: map['snippet']['topLevelComment']['snippet']['authorDisplayName'],
      commentText: map['snippet']['topLevelComment']['snippet']['textDisplay'],
      publishDate: map['snippet']['topLevelComment']['snippet']['publishedAt'],
    );
  }

}