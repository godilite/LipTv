import 'package:flutter/material.dart';
import 'package:lipstudio/models/playlist_model.dart';
import 'package:lipstudio/models/section_model.dart';
import 'package:lipstudio/models/video_model.dart';
import 'package:lipstudio/providers/theme.dart';
import 'package:lipstudio/screens/skeo_components/boxdecoration.dart';
import 'package:lipstudio/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <Playlist> _playlist;
   List <Playlist> _tvlist;
  List <Section> _sections;
  var _movieslist;
  List <Video> _movies;
  var _tv;
  List <Video> _tvseries;
  String videoId;
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
      print(sections);
      _movieslist = _sections[0].playlists.join(', ');
      _tv = _sections[1].playlists.join(', ');

      _initPlaylists();
    });
  }

  _loadPlayer(String id){
     _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        controlsVisibleAtStart: false,
        enableCaption: false,        
      ),
    );
  }

  _initPlaylists() async {
    List <Playlist> playlists = await APIService.instance
      .fetchPlaylistById(playlistIds: _movieslist);
    List <Playlist> tv = await APIService.instance
      .fetchPlaylistById(playlistIds: _tv);
      setState(() {
        _playlist = playlists;
        _tvlist = tv;
      });
      _fetchMovies();
      _fetchTv();
  }

  _fetchMovies() async{
    List <Video> movies = await APIService.instance
     .fetchVideosFromPlaylist(playlistId: _playlist[0].id);
     setState(() {
      _movies = movies;
    });
    _loadPlayer(_movies[0].id);
  }

  _fetchTv() async {
    List <Video> tvseries = await APIService.instance
     .fetchVideosFromPlaylist(playlistId: _tvlist[0].id);
     setState(() {
      _tvseries = tvseries;
     // print(_tvseries);
     });
  }

  YoutubePlayerController _controller;
  
   _buildVideo(Video video) {
     final theme = Provider.of<ThemeChanger>(context);
     Brightness mode = theme.getMode();
    return GestureDetector(
      onTap: () {
        setState(() {
          videoId = video.id;
        });
       _controller.load(video.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
              width: 140,
              decoration: NeoPho().neumorphicDecoration(backgroundScreenColor: Theme.of(context).primaryColor, distance: 10, blur: 15, borderRadius: BorderRadius.circular(20), mode: mode),
              child: Stack(
              children: <Widget>[
                Positioned.fill(child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(video.thumbnailUrl,fit: BoxFit.cover,
                      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: Image(image: AssetImage('images/videos.png'))
                          );
                          })
                        ),
                      ),
                  ),
                Positioned(
                  top: 70,
                  left: 5,
                  child: Container(
                    width: 130,
                    decoration: NeoPho().neumorphicDecoration(backgroundScreenColor: Colors.black38, borderRadius: BorderRadius.circular(8)),
                  child: Text(video.title, style: TextStyle(color: Colors.white), 
                    overflow: TextOverflow.ellipsis,),
                  ),
                )
            ],
            ),
          ),
      )
    );
   }

  @override
  Widget build(BuildContext context) {
     final theme = Provider.of<ThemeChanger>(context);
     Brightness mode = theme.getMode();
    return _movies != null ? ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 5, right: 5),
          padding: EdgeInsets.all(2),
          decoration: mode == Brightness.light ? 
            NeoPho().neumorphicDecoration(backgroundScreenColor: Color(0xfff8f8ff)) : NeoPho().neumorphicDecoration(backgroundScreenColor: Colors.transparent ),
          child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready.');
              },
            ),
        ),
         SizedBox(height: 10,),
         Container(
           margin: EdgeInsets.only(left: 20),
            child: Text('Movies', style: GoogleFonts.righteous(
             textStyle: TextStyle(fontSize: 15), color: Theme.of(context).accentColor, fontWeight: FontWeight.w700
            ),
           ),
         ),
         Container(
           height: 120,
           child: _movies != null ? ListView.builder(
             itemBuilder: (BuildContext context, int index){
                Video movies = _movies[index];
                return _buildVideo(movies); 
              },
              scrollDirection: Axis.horizontal,
              itemCount: _movies.length,
              padding: EdgeInsets.only(top: 2),
            ) : SpinKitWave(color: Colors.white, type: SpinKitWaveType.start),
         ),
        SizedBox(height: 1,),
        Container(
           margin: EdgeInsets.only(left: 20),
           child: Text('Tv Shows', style: GoogleFonts.righteous(
             textStyle: TextStyle(fontSize: 15), color: Theme.of(context).accentColor, fontWeight: FontWeight.w700
           ),
           ),
         ),
         Container(
           height: 120,
           child: _tvseries != null ? ListView.builder(itemBuilder: (BuildContext context, int index){
                      Video tvseries = _tvseries[index];
                      return _buildVideo(tvseries); 
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _tvseries.length,
                    padding: EdgeInsets.only(top: 2),
                  ) : SpinKitWave(color: Colors.white, type: SpinKitWaveType.start)
         )
      ],
    ) : Center(
        child: SpinKitWave(color: Colors.red, type: SpinKitWaveType.center)
      );
  }
    @override
    void dispose() {
      super.dispose();
    }
}
