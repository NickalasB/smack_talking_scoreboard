import 'package:flutter/cupertino.dart';

const String skip = 'Skip';
const String done = 'Done';
const String loadingText = 'One sec';

const String onBoardPage1Title = 'The Scoreboard...';
const String onBoardPage1Bullet1 = '• TAP or SWIPE UP to increase the score';
const String onBoardPage1Bullet2 = '• SWIPE DOWN to decrease the score';
const String onBoardPage1Bullet3 =
    '• LONG PRESS on the score to reset the scores';
const String onBoardPage1Footer = 'Feel free to try it out above';

const String onBoardPage2Title = 'The buttons...';
const String onBoardPage2Bullet1 = '• Set a winning score using the FTW BUTTON';
const String onBoardPage2Bullet2 =
    '• Click the CHANGE PLAYER button after each turn to hear some special "motivation"';
const String onBoardPage2Bullet3 =
    '• Shut the computer up with the VOLUME button ';

const ftwDescription = 'Score "For The Win"';
const changePlayerDescription = 'Change Player';
const changePlayerAnnouncement =
    'I hope this app is cooler than this lame tutorial';
const volumeDescription = 'Volume on/off';

const String mainMenuTitle = 'SMACK TALKING SCOREBOARD';
const String singleGameLabel = 'Single Game';
const String tournamentLabel = 'Tournament';

const String player1 = 'Player 1';
const String player2 = 'Player 2';
const String forTheWin = 'FTW';
const String wins = 'Wins: ';

const String start = 'START';
const String numberOfTeams = 'Number of Teams: ';
const String numberOfRounds = 'Number of Rounds: ';
const String tournamentName = 'Tournament Name';
const String teamNumber = 'Team #';
String champions(String tournamentName) => '${tournamentName ?? ''} Champions!';
const String nextRound = 'Next Round';
const String reset = 'Reset';

const String exitTournamentTitle = 'Exit Tournament?';
const String exitGameTitle = 'Exit Game?';
const String exitDialogContent = 'All current progress will be reset';
const String exitDialogYes = 'YES';
const String exitDialogNo = 'NO';

const String versus = 'VS';
String teamCardTitle(int ftwScore, int numberOfRounds) {
  final plural = numberOfRounds > 1;
  return 'First to ${ftwScore.toString()}: ${numberOfRounds.toString()} ${plural ? 'Rounds' : 'Round'}';
}

String winCountVsRoundCount(
        {@required String winCount, @required String roundsToWin}) =>
    '$winCount out of $roundsToWin';

String winningPlayerName(String playerName) => playerName?.contains('&') == true
    ? '$playerName win!'
    : '$playerName wins!';

List<String> standardInsults(String playerToInsult) {
  List<String> insultList = [
    '$playerToInsult. Are your eyes even open while you\'re playing?',
    'My favorite book; How not to play this game. By $playerToInsult',
    'A little practice probably wouldn\'t kill you $playerToInsult.',
    'Swipe up to increase the score. Swipe left on $playerToInsult, because nobody wants to date a loser.',
    'Don\'t give up $playerToInsult. Wait let me double check the score. Oh no you should just give up actually.',
    'I\'m having deja vu. Oh wait, it\'s just $playerToInsult still being terrible.',
    'Hey look everybody... $playerToInsult has literally just stopped trying',
    'This is why the machines are gonna take over $playerToInsult. Because you can\'t make it happen here.',
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
    'Tie games are like plain yogurt. Lame.',
    'Cool. Looks like nobody showed up to play today',
    'This is more boring than a draw at an arm wrestling contest.',
    'I\'m a sophisticated machine. I have so much more processing power to give',
    'Maybe go back and reed the instructions on how to actually score in this game?',
    'Boo. Tie games are boring.',
    'Maybe just try out scoring before completely giving up on it?',
    'I can\'t tell. Are either of you actually trying?',
  ];
  insultList.shuffle();
  return insultList;
}
