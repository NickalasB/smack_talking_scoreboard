import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;

class ScoreboardHome extends StatefulWidget {
  static const String id = 'scoreboard';

  @override
  _ScoreboardHomeState createState() => _ScoreboardHomeState();
}

enum TtsState { PLAYING, STOPPED }

class _ScoreboardHomeState extends State<ScoreboardHome> {
  FlutterTts flutterTts;
  dynamic languages;
  double volume = 0.5;

  String _playerOne;

  String _playerTwo;

  int playerOneScore = 0;

  int playerTwoScore = 0;

  TtsState ttsState = TtsState.STOPPED;

  get isPlaying => ttsState == TtsState.PLAYING;

  get isStopped => ttsState == TtsState.STOPPED;

  bool volumeOn = true;

  double playerOneOpacity = 1.0;
  double playerTwoOpacity = 0.5;

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.PLAYING;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.STOPPED;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.STOPPED;
      });
    });
  }

  Future _speak({int playerOneScore, int playerTwoScore}) async {
    await flutterTts.setVolume(volume);
    print('Volume = $volume');

    String playerToInsult = '';
    List<String> insultList = [];
    if (playerOneScore < playerTwoScore) {
      if (_playerOne != '' && _playerOne != null) {
        playerToInsult = _playerOne;
      } else {
        playerToInsult = (strings.player1);
      }
      insultList = strings.standardInsults(playerToInsult);
    } else if (playerOneScore > playerTwoScore) {
      if (_playerTwo != '' && _playerTwo != null) {
        playerToInsult = _playerTwo;
      } else {
        playerToInsult = (strings.player2);
      }
      insultList = strings.standardInsults(playerToInsult);
    } else if (playerOneScore == playerTwoScore) {
      insultList = strings.tieGameInsults();
    }
    if (ttsState != TtsState.PLAYING) {
      var result = await flutterTts.speak(insultList.first);
      if (result == 1) setState(() => ttsState = TtsState.PLAYING);
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.STOPPED);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  void _onChangePlayerOne(String text) {
    setState(() {
      _playerOne = text;
    });
  }

  void _onChangePlayerTwo(String text) {
    setState(() {
      _playerTwo = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
            child: Player(
              scoreDragFunction: adjustPlayerOneScore,
              longPressFunction: resetScores,
              singleTapFunction: () {
                playerOneScore++;
                setState(() {});
              },
              nameFunction: _onChangePlayerOne,
              score: playerOneScore,
              color: Colors.red,
              hint: (strings.player1),
              opacity: playerOneOpacity,
            ),
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.check_circle),
                  iconSize: 64,
                  color: Colors.green,
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    adjustPlayerOpacity();
                    if (volumeOn) {
                      _speak(
                          playerOneScore: playerOneScore,
                          playerTwoScore: playerTwoScore);
                    }
                    setState(() {});
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon:
                      volumeOn ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
                  iconSize: 64,
                  color: Colors.grey,
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    changeVolume();
                    setState(() {});
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: Player(
              scoreDragFunction: adjustPlayerTwoScore,
              longPressFunction: resetScores,
              singleTapFunction: () {
                playerTwoScore++;
                setState(() {});
              },
              nameFunction: _onChangePlayerTwo,
              score: playerTwoScore,
              color: Colors.blue,
              hint: (strings.player2),
              opacity: playerTwoOpacity,
            ),
          ),
        ]),
      ),
    );
  }

  void adjustPlayerOpacity() {
    if (playerOneOpacity == 0.5) {
      playerOneOpacity = 1.0;
      playerTwoOpacity = 0.5;
    } else if (playerTwoOpacity == 0.5) {
      playerTwoOpacity = 1.0;
      playerOneOpacity = 0.5;
    }
  }

  void changeVolume() {
    if (volumeOn) {
      volume = 0.0;
      volumeOn = false;
      _stop();
    } else {
      volume = 0.5;
      volumeOn = true;
    }
  }

  void adjustPlayerOneScore(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity != 0) {
        //drag up
        if (details.primaryVelocity < 0) {
          playerOneScore++;
        } else {
          //drag down
          if (playerOneScore > 0) {
            playerOneScore--;
          }
        }
      }
    });
  }

  void adjustPlayerTwoScore(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity != 0) {
        //drag up
        if (details.primaryVelocity < 0) {
          playerTwoScore++;
        } else {
          //drag down
          if (playerTwoScore > 0) {
            playerTwoScore--;
          }
        }
      }
    });
  }

  void resetScores() {
    setState(() {
      playerTwoScore = 0;
      playerOneScore = 0;
    });
  }
}

class Player extends StatefulWidget {
  const Player({
    @required this.scoreDragFunction,
    @required this.longPressFunction,
    @required this.singleTapFunction,
    @required this.nameFunction,
    @required this.score,
    @required this.color,
    @required this.hint,
    @required this.opacity,
  });

  final Function scoreDragFunction;
  final Function longPressFunction;
  final Function singleTapFunction;
  final Function nameFunction;
  final int score;
  final Color color;
  final String hint;
  final double opacity;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    final enabled = widget.opacity == 1.0;
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        Container(
          alignment: Alignment.topCenter,
          color: widget.color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              showCursor: true,
              textCapitalization: TextCapitalization.words,
              onChanged: widget.nameFunction,
              decoration: InputDecoration(hintText: widget.hint),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: widget.opacity,
            child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (enabled) widget.scoreDragFunction(details);
                },
                onLongPress: widget.longPressFunction,
                onTap: enabled ? widget.singleTapFunction : null,
                child: Container(
                  color: widget.color,
                  child: Center(
                    child: Text(
                      widget.score.toString(),
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 220,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
