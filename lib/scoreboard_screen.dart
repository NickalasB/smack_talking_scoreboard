import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smack_talking_scoreboard/firebase/base_cloudstore.dart';
import 'package:smack_talking_scoreboard/team_card.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/ui_components/ftw_button.dart';
import 'package:smack_talking_scoreboard/ui_components/player.dart';
import 'package:smack_talking_scoreboard/ui_components/speak_button.dart';
import 'package:smack_talking_scoreboard/ui_components/volume_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;
import 'package:smack_talking_scoreboard/utils/top_level_functions.dart';

import 'models/winners.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen();
  @override
  Widget build(BuildContext context) {
    return Scoreboard(Cloudstore.of(context));
  }
}

class Scoreboard extends StatefulWidget {
  static const String id = 'scoreboard';

  const Scoreboard(this.cloudstore);

  final Cloudstore cloudstore;

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin {
  dynamic languages;

  List<List<TeamCard>> arguments;

  TextToSpeech tts;

  List<TeamCard> teamsFromArgs;

  bool isSingleGame;

  String playerOneName;

  String playerTwoName;

  int scoreToWin;

  int roundsToWin;

  bool winnerVisible = false;

  bool canResetScores = true;

  int playerOneScore = 0;

  int playerTwoScore = 0;

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

  CollectionReference singleGameCollection;

  @override
  initState() {
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationController2 =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation2 =
        CurvedAnimation(parent: animationController2, curve: Curves.easeIn);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    tts = TextToSpeech.of(context);

    arguments = ModalRoute.of(context).settings.arguments;

    isSingleGame = arguments == null;

    if (!isSingleGame) {
      teamsFromArgs = arguments?.expand((i) => i)?.toList();

      final team1 = teamsFromArgs.first;
      final team2 = teamsFromArgs[1];

      roundsToWin = team1.numOfRounds;

      scoreToWin = team1.ftwScore;

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
      }
    }

    player1TextEditingController = TextEditingController(text: playerOneName);
    player2TextEditingController = TextEditingController(text: playerTwoName);
    ftwTextEditingController =
        TextEditingController(text: scoreToWin?.toString());
  }

  Future _speak({int playerOneScore, int playerTwoScore}) async {
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

    widget.cloudstore.updateCollectionData(
        singleGameCollection, 'game_doc', {'insult': insultList.first});

    setState(() {
      tts.speak(insultList.first);
    });
  }

  @override
  void dispose() {
    tts.stop();
    animationController.dispose();
    player1TextEditingController.dispose();
    player2TextEditingController.dispose();
    ftwTextEditingController.dispose();
    super.dispose();
  }

  void _onChangePlayerOne(String text) {
    setState(() {
      playerOneName = text;
    });
  }

  void _onChangePlayerTwo(String text) {
    setState(() {
      playerTwoName = text;
    });
  }

  void updateScoreToWin(String text) {
    setState(() {
      scoreToWin = int.parse(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.cloudstore.updateCollectionData(singleGameCollection, 'game_doc', {
      'player1Name': playerOneName,
      'player1Score': playerOneScore,
      'player1WinCount': playerOneWinCount,
      'player2Name': playerTwoName,
      'player2Score': playerTwoScore,
      'player2WinCount': playerTwoWinCount,
      'ftwScore': scoreToWin,
      'numberOfRounds': roundsToWin,
    });

    bool playerOneWins = false;
    bool playerTwoWins = false;
    bool gameOver = false;
    String winningPlayerName;
    TeamCard winningTeam;
    if (scoreToWin != null) {
      playerOneWins = playerOneScore > 0 && playerOneScore >= scoreToWin;
      playerTwoWins = playerTwoScore > 0 && playerTwoScore >= scoreToWin;
    }

    if (playerOneWinCount == roundsToWin) {
      winningPlayerName = playerOneName ?? strings.player1;
      gameOver = true;
      winningTeam = teamsFromArgs.first;
    } else if (playerTwoWinCount == roundsToWin) {
      winningPlayerName = playerTwoName ?? strings.player2;
      gameOver = true;
      winningTeam = teamsFromArgs[1];
    }

    if (gameOver) {
      winnerVisible = true;
      canResetScores = false;
      final winnersList = Provider.of<Winners>(context).winners;
      if (!winnersList.contains(winningTeam)) {
        winnersList.add(winningTeam);
      }
    }

    List<Widget> scoreboardButtons = [
      FtwButton(
        onChanged: updateScoreToWin,
        controller: ftwTextEditingController,
      ),
      SpeakButton(
        onPressed: () => onSpeakButtonPressed(
          playerOneWins,
          playerTwoWins,
        ),
      ),
      VolumeButton(
        onPressed: () {
          setState(() {
            changeVolume();
          });
        },
        volumeOn: volumeOn,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, _) {
            return Stack(
              children: <Widget>[
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: buildPlayer1(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: scoreboardButtons,
                            ),
                            Expanded(
                              child: buildPlayer2(),
                            ),
                          ],
                        ),
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
                              children: scoreboardButtons,
                            ),
                          ],
                        ),
                      ),
                Visibility(
                  visible: winnerVisible,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        strings.winningPlayerName(winningPlayerName),
                        style: TextStyle(
                            fontSize: 300, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
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
      roundsToWin: roundsToWin,
      playerName: playerOneName,
      isSingleGame: isSingleGame,
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
      roundsToWin: roundsToWin,
      playerName: playerTwoName,
      isSingleGame: isSingleGame,
    );
  }

  void onSpeakButtonPressed(bool playerOneWins, bool playerTwoWins) {
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
        _speak(playerOneScore: playerOneScore, playerTwoScore: playerTwoScore);
      }
      setState(() {});
    }
  }

  void adjustPlayerOpacity() {
    playerOneOpacity = 0.5;
    playerTwoOpacity = 0.5;
  }

  void changeVolume() {
    final tts = TextToSpeech.of(context);

    if (volumeOn) {
      tts.volume = 0.0;
      volumeOn = false;
      tts.stop();
    } else {
      tts.volume = 1.0;
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
    if (canResetScores) {
      setState(() {
        playerTwoScore = 0;
        playerOneOpacity = 1.0;
        playerOneScore = 0;
        playerTwoOpacity = 1.0;
        playerTurnButtonEnabled = true;
      });
    }
  }
}
