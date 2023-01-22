import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const fake_data = [
  {
    "artist": "Adele",
    "name": "21",
    "album_cover":
        "https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300",
    "votes": 15,
    "is_playing": true,
    "is_locked_in": true,
  },
  {
    "artist": "Adele",
    "name": "21 Jump Street",
    "album_cover":
        "https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300",
    "votes": 13,
    "is_playing": false,
    "is_locked_in": true,
  },
  {
    "artist": "Adele",
    "name": "21 Forever",
    "album_cover":
        "https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300",
    "votes": 12,
    "is_playing": false,
    "is_locked_in": false,
  },
  {
    "artist": "Adele",
    "name": "22",
    "album_cover":
        "https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300",
    "votes": 3,
    "is_playing": false,
    "is_locked_in": false,
  },
];

const Color color1 = Color.fromARGB(255, 12, 12, 12);
const Color color2 = Color.fromARGB(255, 20, 79, 12);
const Color color3 = Color.fromARGB(255, 183, 183, 183);
const Color color4 = Color.fromARGB(255, 66, 255, 41);
const Color color5 = Color.fromARGB(255, 255, 41, 41);
const Color color6 = Color.fromARGB(255, 23, 23, 23);

const Color textColor1 = Color.fromARGB(255, 125, 125, 125);
const Color textColor2 = Color.fromARGB(255, 105, 105, 105);

class Song {
  late String artist;
  late String name;
  late String albumCover;
  late int votes;
  late bool isPlaying;
  late bool isLockedIn;

  Song(this.artist, this.name, this.albumCover, this.votes, this.isPlaying,
      this.isLockedIn);

  factory Song.fromJson(dynamic json) {
    return Song(
      json['artist'] as String,
      json['name'] as String,
      json['album_cover'] as String,
      json['votes'] as int,
      json['is_playing'] as bool,
      json['is_locked_in'] as bool,
    );
  }

  Widget getWidget(double size) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 1.0 * size,
          width: 1.0 * size,
          child: Image.network(albumCover),
        ),
        Container(
          width: 1.0 * size,
          padding: EdgeInsets.only(left: .15 * size),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(color: textColor1, fontSize: .36 * size)),
              Text(artist,
                  style: TextStyle(color: textColor2, fontSize: .20 * size))
            ],
          ),
        )
      ],
    ));
  }

  // String getHash
}

void main() {
  runApp(const MyApp());
}

class MainProvider extends ChangeNotifier {
  final url = "172.20.10.7";
  final port = 4550;

  late List<Song> songs;
  late Song mainSong;

  // late Socket socket;

  MainProvider() {
    List<Song> _songs =
        List<Song>.from(fake_data.map((song) => Song.fromJson(song)));

    mainSong = _songs[0];
    songs = _songs.sublist(1);

    // Socket.connect(url, port).then((Socket sock) {
    //   socket = sock;
    //   socket.listen(_dataHandler,
    //       onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    // });
  }

  // void _dataHandler(data) {
  //   print(String.fromCharCodes(data).trim());
  // }

  // void _errorHandler(error, StackTrace trace) {
  //   print(error);
  // }

  // void _doneHandler() {
  //   socket.destroy();
  // }

  // void sendData() {
  //   socket.write("hello there");
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage());
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color1,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 100),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "AUX",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 128, color: color4),
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        child: _buttonWidget("Create Lobby", color3, color6),
                        onTap: () =>
                            _authenticate().then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()),
                                ))),
                    GestureDetector(
                        child: _buttonWidget("Join Lobby", color2, color3),
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            ))
                  ]),
            ],
          ),
        ));
  }

  Widget _buttonWidget(String name, Color color, Color textColor) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 280,
        height: 50,
        child: Center(
          child: Text(name, style: TextStyle(color: textColor, fontSize: 20)),
        ));
  }

  Future<void> _authenticate() async {
    String CLIENT_ID = 'c287f4b6bc874c2ab63169028d5aedc1';
    String CLIENT_SECRET = '81f3641081dc4e50bc950346f1c2562a';
    String SPOTIPY_REDIRECT_URI = "http://172.20.10.7:5001/";
    String SCOPE =
        "user-modify-playback-state playlist-modify-public user-read-currently-playing";
    String CACHE = '.spotipyoauthcache';
    int PORT = 8080;

    String urlString =
        "https://accounts.spotify.com/authorize?response_type=code&client_id=${CLIENT_ID}&scope=${SCOPE}&redirect_uri=${SPOTIPY_REDIRECT_URI}&state=5";

    var url = Uri.parse(urlString);

    print(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider(
            create: (context) => MainProvider(),
            child: Consumer<MainProvider>(
                builder: (context, provider, child) => Scaffold(
                        body: Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      color: color1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.bottomCenter,
                                    height: 90,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchPage()),
                                      ),
                                      child: const Icon(
                                        Icons.search,
                                        size: 48,
                                        color: color3,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          MainSongWidget(song: provider.mainSong),
                          SongListWidget(songs: provider.songs)
                        ],
                      ),
                    )))));
  }
}

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Song> _songs = [];
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
      width: double.infinity,
      height: double.infinity,
      color: color1,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      onChanged: ((value) => _searchTerm = value),
                      style: const TextStyle(color: color3),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color2, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color3, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                        hintStyle: TextStyle(color: textColor1),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _search(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: color3,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: _songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SongWidget(
                      song: _songs[index],
                      isSearch: true,
                    );
                  }),
            ),
          ),
        ],
      ),
    )));
  }

  Future<void> _search() async {
    _songs = List<Song>.from(fake_data.map((song) => Song.fromJson(song)));
    setState(() {});
  }
}

class MainSongWidget extends StatelessWidget {
  late Song song;

  MainSongWidget({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
            color: color2, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: song.getWidget(120));
  }
}

class SongListWidget extends StatelessWidget {
  late List<Song> songs;

  SongListWidget({
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
              // color: color6,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return SongWidget(song: songs[index]);
              }),
        ),
      ),
    );
  }
}

class SongWidget extends StatefulWidget {
  late Song song;
  late bool isSearch;

  SongWidget({required this.song, this.isSearch = false});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  late int select;

  @override
  void initState() {
    select = 0;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
          decoration: BoxDecoration(
              color: color6,
              border: Border.all(
                  color: widget.song.isLockedIn && !widget.isSearch
                      ? color2
                      : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 100,
          width: double.infinity,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            widget.song.getWidget(60),
            Container(
                width: 100,
                child: Center(
                    child: widget.isSearch
                        ? Container()
                        : widget.song.isLockedIn
                            ? _lockedInWidget()
                            : _voteWidget(widget.song)))
          ])),
    );
  }

  Widget _lockedInWidget() {
    return Container(
      child: Text("Locked-In",
          style: const TextStyle(color: color2, fontSize: 16)),
    );
  }

  Widget _voteWidget(Song song) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (select == 1) {
                  select = 0;
                } else {
                  select = 1;
                }
              });
            },
            child: Icon(
              Icons.arrow_upward_outlined,
              color: (select == 1) ? color4 : color3,
              size: 36,
            ),
          ),
          Container(
            width: 28,
            child: Center(
              child: Text(song.votes.toString(),
                  style: TextStyle(
                      color: (select == 1)
                          ? color4
                          : ((select == -1) ? color5 : color3),
                      fontSize: 24)),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (select == -1) {
                  select = 0;
                } else {
                  select = -1;
                }
              });
            },
            child: Icon(
              Icons.arrow_downward_outlined,
              color: (select == -1) ? color5 : color3,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectWidget(Song song) {
    return Container(child: Center(child: Text("Select")));
  }
}
