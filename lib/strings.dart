const String mainMenuTitle = 'SMACK TALKING SCOREBOARD';
const String singleGameLabel = 'Single Game';
const String tournamentLabel = 'Tournament';

const String player1 = 'Player 1';
const String player2 = 'Player 2';

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
