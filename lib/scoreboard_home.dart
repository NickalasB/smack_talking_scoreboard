import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ScoreboardHome extends StatefulWidget {
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

  @override
  initState() {
    super.initState();
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

    String playerToInsult = '';
    List<String> insultList = [];
    if (playerOneScore < playerTwoScore) {
      if (_playerOne != '' && _playerOne != null) {
        playerToInsult = _playerOne;
      } else {
        playerToInsult = ('Player 1');
      }
      insultList = standardInsults(playerToInsult);
    } else if (playerOneScore > playerTwoScore) {
      if (_playerTwo != '' && _playerTwo != null) {
        playerToInsult = _playerTwo;
      } else {
        playerToInsult = ('Player 2');
      }
      insultList = standardInsults(playerToInsult);
    } else if (playerOneScore == playerTwoScore) {
      insultList = tieGameInsults();
    }
    if (ttsState != TtsState.PLAYING) {
      var result = await flutterTts.speak(insultList.first);
      if (result == 1) setState(() => ttsState = TtsState.PLAYING);
    }
  }

  List<String> standardInsults(String playerToInsult) {
    List<String> insultList = [
      'News flash. $playerToInsult You suck',
      '$playerToInsult, you should quit your dayjob and dedicate your life to being less terrible',
      'Bad job $playerToInsult',
      'That was the saddest thing I have ever seen $playerToInsult',
      'Are you embarrassed $playerToInsult? You should be',
      'This game isn\'t for everyone. Cough, cough $playerToInsult',
      '$playerToInsult, congratulations on your nomination into the hall of losers',
      'Everyone in this room is now dumber after watching $playerToInsult',
      'We should rename this game to: $playerToInsult sucks at life',
      'Those who can. Do. Those who can\'t. Are named $playerToInsult',
      'Things to add to your bucket list $playerToInsult. Doing much much better at this game.',
      '$playerToInsult.How bad you are doing at this game is a crime in some countries',
      'Words escape me $playerToInsult. Oh wait. No they don\'t. You are garbage.',
      'It is physically painful to watch you play this game $playerToInsult',
      '$playerToInsult this reminds me of the time you invested your life savings into laserdisc stock'
    ];
    insultList.shuffle();
    return insultList;
  }

  List<String> tieGameInsults() {
    List<String> insultList = [
      'Oh wow- a tie! Cuz that\'s fun?',
      'At least you two won\'t be lonely in sucks-ville',
      'You are both very not good at this',
    ];
    insultList.shuffle();
    return insultList;
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.STOPPED);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(
          child: Player(
            scoreDragFunction: adjustPlayerOneScore,
            nameFunction: _onChangePlayerOne,
            score: playerOneScore.toString(),
            color: Colors.red,
            hint: ('Player 1'),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: Icon(Icons.check_circle),
            iconSize: 64,
            color: Colors.green,
            splashColor: Colors.greenAccent,
            onPressed: () {
              _speak(
                  playerOneScore: playerOneScore,
                  playerTwoScore: playerTwoScore);
            },
          ),
        ),
        Expanded(
          child: Player(
            scoreDragFunction: adjustPlayerTwoScore,
            nameFunction: _onChangePlayerTwo,
            score: playerTwoScore.toString(),
            color: Colors.blue,
            hint: ('Player 2'),
          ),
        ),
      ]),
    );
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
}

class Player extends StatefulWidget {
  const Player({
    @required this.scoreDragFunction,
    @required this.nameFunction,
    @required this.score,
    @required this.color,
    @required this.hint,
  });

  final Function scoreDragFunction;
  final Function nameFunction;
  final String score;
  final Color color;
  final String hint;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragEnd: (details) {
          widget.scoreDragFunction(details);
        },
        child: Container(
          color: widget.color,
          child: Column(
            children: <Widget>[
              Container(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      showCursor: true,
                      autofocus: true,
                      onChanged: widget.nameFunction,
                      decoration: InputDecoration(hintText: widget.hint),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    widget.score,
                    style: TextStyle(fontSize: 120),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
