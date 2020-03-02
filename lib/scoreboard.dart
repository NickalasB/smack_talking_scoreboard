import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/team_card.dart';
import 'package:smack_talking_scoreboard/top_level_functions.dart';

class Scoreboard extends StatefulWidget {
  static const String id = 'scoreboard';

  const Scoreboard();

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

enum TtsState { PLAYING, STOPPED }

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin {
  FlutterTts flutterTts;
  dynamic languages;

  List<List<TeamCard>> arguments;

  List<TeamCard> teamsFromArgs;

  double volume = 1.0;

  String playerOneName;

  String playerTwoName;

  int scoreToWin;

  int playerOneScore = 0;

  int playerTwoScore = 0;

  TtsState ttsState = TtsState.STOPPED;

  get isPlaying => ttsState == TtsState.PLAYING;

  get isStopped => ttsState == TtsState.STOPPED;

  bool volumeOn = true;

  double playerOneOpacity = 1.0;

  double playerTwoOpacity = 1.0;

  AnimationController animationController;
  AnimationController animationController2;
  Animation animation;
  Animation animation2;
  TextEditingController player1TextEditingController;
  TextEditingController player2TextEditingController;
  TextEditingController ftwTextEditingController;

  int playerOneWinCount = 0;
  int playerTwoWinCount = 0;
  bool playerTurnButtonEnabled = true;

  @override
  initState() {
    initTts();

    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationController2 =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation2 =
        CurvedAnimation(parent: animationController2, curve: Curves.easeIn);

    player1TextEditingController = TextEditingController();
    player2TextEditingController = TextEditingController();
    ftwTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  didChangeDependencies() {
    arguments = ModalRoute.of(context).settings.arguments;

    if (arguments != null) {
      teamsFromArgs = arguments?.expand((i) => i)?.toList();

      final team1 = teamsFromArgs.first;
      final team2 = teamsFromArgs[1];

      final teamOneFirstName = team1.controller1.text;
      final teamOneSecondName = team1.controller2.text;

      final teamTwoFirstName = team2.controller1.text;
      final teamTwoSecondName = team2.controller2.text;

      if (teamOneFirstName?.isNotEmpty == true &&
          teamOneSecondName?.isNotEmpty == true) {
        playerOneName = '$teamOneFirstName & $teamOneSecondName';
      } else if (teamOneSecondName?.isEmpty == true &&
          teamOneFirstName?.isEmpty != true) {
        playerOneName = teamOneFirstName;
      } else if (teamTwoFirstName?.isEmpty == true &&
          teamOneSecondName?.isEmpty != true) {
        playerOneName = teamOneSecondName;
      } else {
        playerOneName = strings.player1;
      }

      if (teamTwoFirstName?.isNotEmpty == true &&
          teamTwoSecondName?.isNotEmpty == true) {
        playerTwoName = '$teamTwoFirstName & $teamTwoSecondName';
      } else if (teamTwoSecondName?.isEmpty == true &&
          teamTwoFirstName?.isEmpty != true) {
        playerTwoName = teamOneFirstName;
      } else if (teamOneFirstName?.isEmpty == true &&
          teamTwoSecondName?.isEmpty != true) {
        playerTwoName = teamTwoSecondName;
      } else {
        playerTwoName = strings.player2;
      }
    }

    super.didChangeDependencies();
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
      playerToInsult = playerOneName ?? strings.player1;
      insultList = strings.standardInsults(playerToInsult);
    } else if (playerOneScore > playerTwoScore) {
      playerToInsult = playerTwoName ?? strings.player2;
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
    flutterTts.stop();
    animationController.dispose();
    player1TextEditingController.dispose();
    player2TextEditingController.dispose();
    ftwTextEditingController.dispose();
    super.dispose();
  }

  void _onChangePlayerOne(String text) {
    playerOneName = text;
  }

  void _onChangePlayerTwo(String text) {
    playerTwoName = text;
  }

  void updateScoreToWin(String text) {
    setState(() {
      scoreToWin = int.parse(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool playerOneWins = false;
    bool playerTwoWins = false;
    if (scoreToWin != null) {
      playerOneWins = playerOneScore > 0 && playerOneScore >= scoreToWin;
      playerTwoWins = playerTwoScore > 0 && playerTwoScore >= scoreToWin;
    }

    return SafeArea(
      child: Scaffold(
        body: OrientationBuilder(
          builder: (context, _) {
            return MediaQuery.of(context).orientation == Orientation.landscape
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      Expanded(
                        child: buildPlayer1(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildFtwField(),
                          buildPlayerTurnButton(playerOneWins, playerTwoWins),
                          buildVolumeButton(),
                        ],
                      ),
                      Expanded(
                        child: buildPlayer2(),
                      ),
                    ]),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 24),
                        Expanded(
                          child: buildPlayer1(),
                        ),
                        SizedBox(height: 24),
                        Expanded(
                          child: buildPlayer2(),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildFtwField(),
                            buildPlayerTurnButton(playerOneWins, playerTwoWins),
                            buildVolumeButton(),
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget buildPlayer1() {
    Color teamFromArgsColor;
    Color teamFromArgsCursorColor;
    if (teamsFromArgs != null) {
      teamFromArgsColor =
          generateProperTeamColor(teamsFromArgs.first.teamNumber);
      teamFromArgsCursorColor =
          generateProperHintColor(teamsFromArgs.first.teamNumber);
    }

    return Player(
      scoreDragFunction: adjustPlayerOneScore,
      longPressFunction: resetScores,
      singleTapFunction: () {
        playerOneScore++;
        setState(() {});
      },
      nameFunction: _onChangePlayerOne,
      score: playerOneScore,
      color: teamFromArgsColor == null ? Colors.red : teamFromArgsColor,
      cursorColor: teamFromArgsColor == null
          ? Colors.grey[400]
          : teamFromArgsCursorColor,
      hint: (strings.player1),
      opacity: playerOneOpacity,
      animation: animation,
      textEditingController: player1TextEditingController,
      winCount: playerOneWinCount,
      playerName: playerOneName,
    );
  }

  Widget buildPlayer2() {
    Color teamFromArgsColor;
    Color teamFromArgsCursorColor;

    if (teamsFromArgs != null) {
      teamFromArgsColor = generateProperTeamColor(teamsFromArgs[1].teamNumber);
      teamFromArgsCursorColor =
          generateProperHintColor(teamsFromArgs[1].teamNumber);
    }
    return Player(
      scoreDragFunction: adjustPlayerTwoScore,
      longPressFunction: resetScores,
      singleTapFunction: () {
        playerTwoScore++;
        setState(() {});
      },
      nameFunction: _onChangePlayerTwo,
      score: playerTwoScore,
      color: teamFromArgsColor == null ? Colors.blue : teamFromArgsColor,
      cursorColor:
          teamFromArgsColor == null ? Colors.black45 : teamFromArgsCursorColor,
      hint: (strings.player2),
      opacity: playerTwoOpacity,
      animation: animation2,
      textEditingController: player2TextEditingController,
      winCount: playerTwoWinCount,
      playerName: playerTwoName,
    );
  }

  Widget buildVolumeButton() {
    return IconButton(
      icon: volumeOn ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
      iconSize: 64,
      color: Colors.grey,
      splashColor: Colors.greenAccent,
      onPressed: () {
        changeVolume();
        setState(() {});
      },
    );
  }

  Widget buildPlayerTurnButton(bool playerOneWins, bool playerTwoWins) {
    return IconButton(
      icon: Icon(Icons.check_circle),
      iconSize: 64,
      color: Colors.green,
      splashColor: Colors.greenAccent,
      onPressed: () {
        if (playerTurnButtonEnabled) {
          if (playerOneWins) {
            adjustPlayerOpacity();
            animationController.forward(from: 0);
            playerOneWinCount++;
            playerTurnButtonEnabled = false;
          } else if (playerTwoWins) {
            adjustPlayerOpacity();
            animationController2.forward(from: 0);
            playerTwoWinCount++;
            playerTurnButtonEnabled = false;
          }
          if (volumeOn) {
            _speak(
                playerOneScore: playerOneScore, playerTwoScore: playerTwoScore);
          }
          setState(() {});
        }
      },
    );
  }

  Widget buildFtwField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 64,
        height: 64,
        decoration: new BoxDecoration(
          color: Colors.yellow[500],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: TextField(
            showCursor: true,
            onChanged: updateScoreToWin,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: ftwTextEditingController,
            decoration: InputDecoration.collapsed(hintText: strings.forTheWin),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  void adjustPlayerOpacity() {
    playerOneOpacity = 0.5;
    playerTwoOpacity = 0.5;
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
      playerOneOpacity = 1.0;
      playerOneScore = 0;
      playerTwoOpacity = 1.0;
      playerTurnButtonEnabled = true;
    });
  }
}

class Player extends StatefulWidget {
  const Player(
      {@required this.scoreDragFunction,
      @required this.longPressFunction,
      @required this.singleTapFunction,
      @required this.nameFunction,
      @required this.score,
      @required this.color,
      @required this.cursorColor,
      @required this.hint,
      @required this.opacity,
      @required this.animation,
      @required this.textEditingController,
      @required this.winCount,
      this.playerName});

  final Function scoreDragFunction;
  final Function longPressFunction;
  final Function singleTapFunction;
  final Function nameFunction;
  final int score;
  final Color color;
  final Color cursorColor;
  final String hint;
  final double opacity;
  final Animation animation;
  final TextEditingController textEditingController;
  final int winCount;
  final String playerName;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    widget.textEditingController.text = widget.playerName;
    final enabled = widget.opacity == 1.0;
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              showCursor: true,
              textCapitalization: TextCapitalization.words,
              cursorColor: widget.cursorColor,
              onChanged: widget.nameFunction,
              decoration: InputDecoration(hintText: widget.hint),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
              controller: widget.textEditingController,
            ),
          ),
        ),
        SizedBox(height: 4),
        Expanded(
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: widget.opacity,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (enabled) widget.scoreDragFunction(details);
                  },
                  onLongPress: widget.longPressFunction,
                  onTap: enabled ? widget.singleTapFunction : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: RotationTransition(
                      turns: widget.animation,
                      child: FittedBox(
                        child: Text(
                          widget.score.toString(),
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 220,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        strings.wins,
                        style: TextStyle(color: Colors.grey[200], fontSize: 24),
                      ),
                      RotationTransition(
                        turns: widget.animation,
                        child: Text(
                          widget.winCount.toString(),
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
