import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lipstudio/models/channel_model.dart';
import 'package:lipstudio/models/comments_model.dart';
import 'package:lipstudio/models/playlist_model.dart';
import 'package:lipstudio/models/search_model.dart';
import 'package:lipstudio/models/section_model.dart';
import 'package:lipstudio/models/video_model.dart';
import 'package:lipstudio/utilities/keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Playlist>>fetchPlaylist({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'channelId': channelId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get List
    var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> playlistJson = data['items'];

      // Fetch first 8 playlist
      List<Playlist> playlists = [];
      playlistJson.forEach(
        (data) => playlists.add(
          Playlist.fromMap(data),
        ),
      );
      return playlists;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Playlist>>fetchPlaylistById({String playlistIds}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'id': playlistIds,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get List
    var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> playlistJson = data['items'];

      // Fetch first 8 playlist
      List<Playlist> playlists = [];
      playlistJson.forEach(
        (data) => playlists.add(
          Playlist.fromMap(data),
        ),
      );
      return playlists;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
  Future<List<Section>>fetchSection({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'channelId': channelId,
      'maxResults': '3',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channelSections',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get List
    var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> sectionJson = data['items'];

      // Fetch first 8 playlist
      List<Section> sections = [];
      for(var i = 0; i< sectionJson.length; i++) {
            if (i == 0) {
              continue;
            }
            sections.add(
              Section.fromMap(sectionJson[i]),
            );
        }
      // sectionJson.forEach(
      //   (data) => sections.add(
      //     Section.fromMap(data),
      //   ),
      // );
      return sections;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<CommentThread>> fetchVideoComment({String videoId}) async {
    Map<String, String> parameters = {
      'part': 'id, snippet',
      'videoId': videoId,
      'textFormat': 'plainText',
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/commentThreads',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> commentJson = data['items'];

      // Fetch first 8 playlist
      List<CommentThread> comments = [];
        commentJson.forEach(
        (data) => comments.add(
          CommentThread.fromMap(data),
        ),
      );
      // Fetch first batch of videos from uploads playlist
      // channel.videos = await fetchVideosFromPlaylist(
      //   playlistId: channel.uploadPlaylistId,
      // );
      return comments;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
  
  Future<List <SearchData>> searchVideos({String query, String channelId}) async{
       Map<String, String> parameters = {
      'part': 'snippet',
      'channelId': channelId,
      'q': query,
      'type': 'video',
      'maxResults': '10',
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> searchJson = data['items'];

      // Fetch first 8 playlist
      List<SearchData> results = [];
      for(var i = 0; i<  searchJson.length; i++) {
            results.add(
              SearchData.fromMap( searchJson[i]),
            );
        }
      
       return results;
    }else{
      throw json.decode(response.body)['error']['message'];        
    }
  }

}
