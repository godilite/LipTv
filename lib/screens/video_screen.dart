import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lipstudio/models/comments_model.dart';
import 'package:lipstudio/providers/theme.dart';
import 'package:lipstudio/screens/skeo_components/boxdecoration.dart';
import 'package:lipstudio/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {

  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Future<SharedPreferences> _user = SharedPreferences.getInstance();
  Future <String> _name;
  Future <String> _token; 
  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes:<String> [
        'email',
        'https://www.googleapis.com/auth/youtube.force-ssl'
      ]
    );
  GoogleSignInAccount _currentUser;
  
  List <CommentThread> _comments;
  
  YoutubePlayerController _controller;
  String _errorText;
    @override
  void initState() {
    super.initState();
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
        SharedPreferences user = await _user;
          setState(() {
            _currentUser  = account;
            setPrefs()async{
             _name = user.setString('displayName', account.displayName).then((bool success) {
              return account.displayName;
            });
            user.setString('email', account.email);
            user.setString('photo', account.photoUrl);
           _token = user.setString('token', await account.authToken).then((bool success) {
              return account.authToken;
            });
           }
          });

        });
        _loadComment();
        _controller = YoutubePlayerController(
          initialVideoId: widget.id,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
          ),
        );
        _googleSignIn.signInSilently();
      }
     _signOutDialog(){
       _exitApp(context);
     } 
    Future <void> _loadComment() async {
         List <CommentThread> comments = await APIService.instance
            .fetchVideoComment(videoId: widget.id);
        setState(() {
          _comments = comments;
        });
    }
    Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      setState(() {

      });
    } catch (error) {
      print(error);
    }
  }
Future <bool>_exitApp(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Do you want logout?'),
            content: Text("You won't be able to comment"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                 Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  _handleSignOut();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

      final commentController = TextEditingController();

      Future<void> postComment() async {
      Map data = {
              "snippet": {
                "topLevelComment": {
                  "snippet": {
                    "textOriginal": commentController.text,
                    "videoId": widget.id
                  }
                }
              }
            };
      final http.Response response = await http.post(
        'https://www.googleapis.com/youtube/v3/commentThreads?part=id,snippet',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${await _token}"
        },
        body: json.encode(data) 
      );
      if (response.statusCode != 200) {
        print('Youtube Api ${response.statusCode} response: ${response.body}');
        return;
    }
    setState(() {
      _loadComment();
    });
  }

  Future<void> subscribe() async {
    print(await _name);
      Map data = {
              "snippet": {
                "resourceId": "UCu3D4nD7n1T3L6aCV_rdlyQ"
              }
            };
      final http.Response response = await http.post(
        'https://www.googleapis.com/youtube/v3/subscriptions?part=id,snippet',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${await _token}"
        },
        body: json.encode(data) 
      );
      if (response.statusCode != 200) {
        print('subscribe Api ${response.statusCode} response: ${response.body}');
        return;
    }
    setState(() {
      
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

    Widget _buildAuthArea() {
    if (_currentUser != null) {
      return GestureDetector(
              onTap: (){
                _signOutDialog();
              },
              child: Chip(
               avatar: GoogleUserCircleAvatar(
                identity: _currentUser,
              ), 
              label: Text( _name ?? ''),
            ),
      );      
    } else {
      return GestureDetector(
              onTap: (){
                _handleSignIn();
              },
              child: Chip(
              backgroundColor: Color(0xfff1f1f1),
              shadowColor: Colors.black38,
              label: Text('Sign In with Google'),
            ),
      );
       }
    }

    Widget _subscribeArea() {
    if (_currentUser != null) {
      return GestureDetector(
              onTap: (){
                _handleSignIn().then((value) => subscribe());
              },
              child: Chip(
                backgroundColor: Colors.red,
                avatar: Icon(Icons.notifications_active),
              label: Text('Subscribe'),
            ),
      );      
    } else {
      return GestureDetector(
              onTap: (){
                subscribe();
              },
              child: Chip(
                backgroundColor: Colors.red,
                avatar: Icon(Icons.notifications_active),
              label: Text('Subscribe'),
            ),
      );
       }
    }

  _buildComment(CommentThread comment){
      return Container(
         margin: EdgeInsets.only(bottom: 5),
      decoration: NeoPho().neumorphicDecoration(distance: 2, borderRadius: BorderRadius.circular(20), blur: 2, backgroundScreenColor: Color(0xfff8f8ff), mode: Brightness.light),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: CachedNetworkImage(imageUrl: comment.profilePictureUrl,)),
                  label: Text(comment.commentAuthor),
              ),
              Container(
                padding: EdgeInsets.only(left: 29, right: 10, bottom: 10),
                child: Text(comment.commentText)
              ),   
        ],),
      );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
     Brightness mode = theme.getMode();
    return SafeArea(
          child: Scaffold(
           resizeToAvoidBottomInset: false,
          body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Container(
                        width: 100,
                        child: _subscribeArea(),
                      ),
                      Container(
                        width: 150,
                        child: _buildAuthArea()
                      )
                  ],
                ),
               _currentUser != null ? TextField(
                 controller: commentController,
                 onSubmitted: (String text) {
                      setState(() {
                        if (commentController.text.isEmpty) {
                          _errorText = 'Cannot submit an empty comment';
                        } else {
                          _errorText = null;
                          postComment();
                          commentController.text = '';
                        }
                      });

                      setState(() {
                        
                      });
                    },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  fillColor: Colors.purpleAccent,
                  hintText: "Start typing...",
                   errorText: _getErrorText(),
                  focusColor: Colors.red,
                  border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid, width: 1), 
                borderRadius: BorderRadius.circular(10))),
                ) : Text('Sign In to comment', style: TextStyle(color: Colors.grey.shade500),),
                SizedBox(height: 10,),
               _comments != null ? Flexible(
                                child: RefreshIndicator(
                            onRefresh: _loadComment,
                           child: ListView.builder(
                          shrinkWrap: true,
                        itemCount: _comments.length,
                                  itemBuilder: (BuildContext context, int index) {
                                CommentThread comment = _comments[index];
                                return _buildComment(comment);
                                // Video video = _channel.videos[index - 1];
                                // return _buildVideo(video);
                              },
                        ),
                 ),
               ) : Center(child: 
                    Text('Be the first to comment'),)
                  ]   
              ),
            ),
         ),
    );
  }
  _getErrorText() {
    return _errorText;
  }
}

