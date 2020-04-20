import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smack_talking_scoreboard/main_menu_screen.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/ui_components/ftw_button.dart';
import 'package:smack_talking_scoreboard/ui_components/player.dart';
import 'package:smack_talking_scoreboard/ui_components/speak_button.dart';
import 'package:smack_talking_scoreboard/ui_components/volume_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

class OnBoardingScreen extends StatefulWidget {
  static const String id = 'on_boarding';

  const OnBoardingScreen(this.prefs);

  final SharedPreferences prefs;

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  int playerOneScore = 0;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() async {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.subtitle;
    return IntroductionScreen(
      globalBackgroundColor: Colors.grey[200],
      pages: listPagesViewModel(),
      onDone: () async {
        setHasSeenOnBoardingScreen(widget.prefs)
            .then((_) => navigateToMainMenu(context));
      },
      showSkipButton: true,
      onSkip: () async {
        setHasSeenOnBoardingScreen(widget.prefs)
            .then((_) => navigateToMainMenu(context));
      },
      skip: Text(
        strings.skip,
        style: subtitleStyle,
      ),
      done: Text(
        strings.done,
        style: subtitleStyle,
      ),
    );
  }

  Future setHasSeenOnBoardingScreen(SharedPreferences prefs) async {
    await prefs.setBool('has_seen_onBoarding', true);
  }

  Future<Object> navigateToMainMenu(BuildContext context) =>
      Navigator.of(context).pushReplacementNamed(MainMenuScreen.id);

  List<PageViewModel> listPagesViewModel() {
    final bodyTextStyle = TextStyle(fontSize: 18);
    final emphasizedTextStyle = Theme.of(context).textTheme.headline;
    return [
      PageViewModel(
        titleWidget: (Text(
          strings.onBoardPage1Title,
          style: emphasizedTextStyle,
        )),
        bodyWidget: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.onBoardPage1Bullet1,
                  style: bodyTextStyle,
                ),
                SizedBox(height: 16),
                Text(
                  strings.onBoardPage1Bullet2,
                  style: bodyTextStyle,
                ),
                SizedBox(height: 16),
                Text(
                  strings.onBoardPage1Bullet3,
                  style: bodyTextStyle,
                ),
                SizedBox(height: 24),
              ],
            ),
            Text(
              strings.onBoardPage1Footer,
              style: emphasizedTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        image: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Player(
              scoreDragFunction: adjustPlayerOneScore,
              longPressFunction: () {
                setState(() {
                  playerOneScore = 0;
                });
              },
              singleTapFunction: () {
                playerOneScore++;
                setState(() {});
              },
              score: playerOneScore,
              color: Colors.red,
              cursorColor: Colors.black,
              hint: strings.player1,
              opacity: 1,
              animation: CurvedAnimation(
                  parent: animationController, curve: Curves.easeIn),
              winCount: 2,
              roundsToWin: 3,
              isSingleGame: false,
            ),
          ),
        ),
      ),
      PageViewModel(
        image: OnBoardingScreenButtons(),
        titleWidget: Text(
          strings.onBoardPage2Title,
          style: Theme.of(context).textTheme.headline,
        ),
        bodyWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(strings.onBoardPage2Bullet1, style: bodyTextStyle),
            SizedBox(height: 16),
            Text(strings.onBoardPage2Bullet2, style: bodyTextStyle),
            SizedBox(height: 16),
            Text(strings.onBoardPage2Bullet3, style: bodyTextStyle),
            SizedBox(height: 24),
          ],
        ),
      )
    ];
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
}

class OnBoardingScreenButtons extends StatefulWidget {
  @override
  _OnBoardingScreenButtonsState createState() =>
      _OnBoardingScreenButtonsState();
}

class _OnBoardingScreenButtonsState extends State<OnBoardingScreenButtons> {
  bool volumeIsOn = true;

  @override
  Widget build(BuildContext context) {
    final tts = TextToSpeech.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OnBoardingButtonColumn(
            text: strings.ftwDescription, button: FtwButton()),
        OnBoardingButtonColumn(
          text: strings.changePlayerDescription,
          button: SpeakButton(
            onPressed: () {
              setState(() {
                if (volumeIsOn) tts.speak(strings.changePlayerAnnouncement);
              });
            },
          ),
          reverse: true,
        ),
        OnBoardingButtonColumn(
          text: strings.volumeDescription,
          button: VolumeButton(
            volumeOn: volumeIsOn,
            onPressed: () {
              volumeIsOn = !volumeIsOn;
              setState(() {
                if (!volumeIsOn) tts.stop();
              });
            },
          ),
        ),
      ],
    );
  }
}

class OnBoardingButtonColumn extends StatelessWidget {
  const OnBoardingButtonColumn(
      {@required this.text, @required this.button, this.reverse = false});

  final String text;
  final Widget button;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      button,
      Text(
        text,
        style: Theme.of(context).textTheme.subtitle,
      )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: reverse ? children.reversed.toList() : children,
    );
  }
}
