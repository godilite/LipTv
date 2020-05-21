import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipstudio/models/playlist_model.dart';
import 'package:lipstudio/models/section_model.dart';
import 'package:lipstudio/screens/skeo_components/boxdecoration.dart';
import 'package:lipstudio/screens/video_list.dart';
import 'package:lipstudio/services/api_service.dart';


class MoviePage extends StatefulWidget {

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List <Playlist> _playlist;
  List <Section> _sections;
  var _list;
   @override
    void initState() {
      super.initState();
      _initSections();
    }
    _initSections() async {
    List <Section> sections = await APIService.instance
        .fetchSection(channelId: 'UCu3D4nD7n1T3L6aCV_rdlyQ');
    setState(() {
      _sections = sections;
      _list = _sections[0].playlists.join(', ');
      _initPlaylists();
    });
  }

  _initPlaylists() async {
    List <Playlist> playlists = await APIService.instance
      .fetchPlaylistById(playlistIds: _list);
      setState(() {
        _playlist = playlists;
      });
  }

  _buildPlaylist(Playlist playlist) {
    return GestureDetector(
        onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoLists(id: playlist.id, items: playlist.itemCount),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: NeoPho().neumorphicDecoration( backgroundScreenColor: Theme.of(context).primaryColor,
         borderRadius: BorderRadius.circular(20), distance: 10, blur: 15),
        child: Stack(
          children: <Widget>[
            Row(
            children: <Widget>[
               Image(
                width: 150.0,
                image: CachedNetworkImageProvider(playlist.thumbnailUrl),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  playlist.title,
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
          Positioned(
            right: 0,
            child: CircleAvatar(
            backgroundColor: Color(0xFFab0202),
            radius: 10,
            child: Text(playlist.itemCount.toString(), style: TextStyle(fontSize: 10, color: Colors.white),),
            ),
            ),
          ]
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _playlist != null ? ListView.builder(
      itemCount: _playlist.length,
                itemBuilder: (BuildContext context, int index) {
                  Playlist playlist = _playlist[index];
                  return _buildPlaylist(playlist);
                  // Video video = _channel.videos[index - 1];
                  // return _buildVideo(video);
                },
    ) 
    :  Center(
        child: SpinKitWave(color: Colors.red, type: SpinKitWaveType.center)
      ); 
  }

   @override
    void dispose() {
      super.dispose();
    }
}