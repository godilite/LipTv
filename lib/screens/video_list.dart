import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipstudio/models/video_model.dart';
import 'package:lipstudio/screens/skeo_components/boxdecoration.dart';
import 'package:lipstudio/screens/video_screen.dart';
import 'package:lipstudio/services/api_service.dart';

class VideoLists extends StatefulWidget {
  final String id;
  final int items;

  VideoLists({this.id, this.items});
  @override
  _VideoListsState createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
    bool _isLoading = false;
    List <Video> _videos = [];
    initState(){
      super.initState();
      _initVideos();
    }
      _initVideos() async {
    List <Video> videos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.id);
    setState(() {
      _videos = videos;
    });
  }
    _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 120.0,
        decoration: NeoPho().neumorphicDecoration( backgroundScreenColor: Theme.of(context).primaryColor,
         borderRadius: BorderRadius.circular(20), distance: 10, blur: 15),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: CachedNetworkImageProvider(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: GoogleFonts.righteous(
                 textStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18.0,
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.id);
    List<Video> allVideos = _videos..addAll(moreVideos);
    setState(() {
      _videos = allVideos;
    });
    _isLoading = false;
  }
  @override
  Widget build(BuildContext context) {
    return _videos != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _videos.length != widget.items &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: SafeArea(
                child: Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                         Row(
                          children: <Widget>[
                            Container(
                              height: 35,
                              width: 35,
                              margin: EdgeInsets.only(left: 5),
                              decoration: NeoPho().neumorphicDecoration(distance: 4, blur: 10, backgroundScreenColor: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: IconButton(iconSize: 10, icon: 
                                Icon(Icons.arrow_back_ios, color: Colors.white,), 
                                onPressed: (){
                                  Navigator.pop(context);
                                }),
                              ),
                              ), 
                          ],
                        ),
                        Container(
                        padding: EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height -79,
                        child: _videos.isNotEmpty ? ListView.builder(
                        itemCount: _videos.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (index == 0) {
                          //   return _buildProfileInfo();
                          // }
                          Video video =  _videos[index];
                          return _buildVideo(video);
                        },
                      ) : Text('loading...')
                        )
                      ],
                    )
                    ),
                  ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            );
        }
}