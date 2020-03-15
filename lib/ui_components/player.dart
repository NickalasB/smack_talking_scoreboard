import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

class Player extends StatelessWidget {
  const Player(
      {@required this.scoreDragFunction,
      @required this.longPressFunction,
      @required this.singleTapFunction,
      this.nameFunction,
      @required this.score,
      @required this.color,
      @required this.cursorColor,
      @required this.hint,
      @required this.opacity,
      this.animation,
      this.textEditingController,
      @required this.winCount,
      @required this.roundsToWin,
      this.playerName,
      @required this.isSingleGame});

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
  final int roundsToWin;
  final String playerName;
  final bool isSingleGame;

  @override
  Widget build(BuildContext context) {
    final enabled = opacity == 1.0;
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              enabled: isSingleGame,
              showCursor: true,
              textCapitalization: TextCapitalization.words,
              cursorColor: cursorColor,
              onChanged: nameFunction,
              decoration: InputDecoration(hintText: hint),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.grey[200],
              ),
              controller: textEditingController,
            ),
          ),
        ),
        SizedBox(height: 4),
        Expanded(
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (enabled) scoreDragFunction(details);
                  },
                  onLongPress: longPressFunction,
                  onTap: enabled ? singleTapFunction : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: RotationTransition(
                      turns: animation,
                      child: FittedBox(
                        child: Text(
                          score.toString(),
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
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      RotationTransition(
                        turns: animation,
                        child: Text(
                          roundsToWin != null
                              ? strings.winCountVsRoundCount(
                                  winCount: winCount.toString(),
                                  roundsToWin: roundsToWin.toString(),
                                )
                              : winCount.toString(),
                          style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
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
