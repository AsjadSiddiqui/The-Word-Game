import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:the_word_game/utils/game/constants.dart';
import 'package:the_word_game/utils/game/game_layout.dart';
import 'package:the_word_game/utils/game/widgets/rotated_text.dart';
import 'package:the_word_game/utils/game/widgets/word_grid.dart';
import 'package:the_word_game/utils/game/widgets/word_panel.dart';
import 'package:word_search/word_search.dart';

class Level1 extends StatefulWidget {
  final List<String> words;
  final int chosenLevel;
  Level1(this.words, this.chosenLevel);
  @override
  _Level1State createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  final WSSettings ws = WSSettings(
      preferOverlap: false,
      fillBlanks: true,
      width: sizeGrid,
      height: sizeGrid,
      orientations: List.from([
        WSOrientation.diagonalBack,
        WSOrientation.diagonalUpBack,
        WSOrientation.horizontalBack,
        WSOrientation.verticalUp,
        WSOrientation.vertical,
      ]));

  // Create new instance of the WordSearch class
  final WordSearch wordSearch = WordSearch();
  WSNewPuzzle newPuzzle = WSNewPuzzle();
  List<String> wordsgrid = [];
  List<String> essantialWords = [""];
  List<String> additionalWords = [""];
  Offset mapTextPosition;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  bool _isEssantialWord = false;
  bool _isAdditionalWord = false;
  bool _isAlreadyWord = false;
  Color _color;
  String _textToshow;
  int _score = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          GameBackground(
              assetPath: "assets/images/game_background.png",
              child: Center(
                child: GameLayout(
                  chosenLevel: widget.chosenLevel,
                  win: widget.words.length == 0,
                  wordsNotFound: widget.words,
                  score: _score,
                  wordsFound: essantialWords + additionalWords,
                  wordGrid: WordGrid(
                    wordsgrid: wordsgrid,
                    onPanEnd:
                        (List<int> selectedItemsIndex, Offset endDetails) {
                      _wordFound(context, selectedItemsIndex, endDetails);
                    },
                    onPanStart: (details) {
                      setState(() {});
                      _isEssantialWord = false;
                      _isAdditionalWord = false;
                      _isAlreadyWord = false;
                    },
                  ),
                ),
              )),
          _isEssantialWord || _isAdditionalWord || _isAlreadyWord
              ? RotatedText(
                  Alignment(mapTextPosition.dx, mapTextPosition.dy),
                  text: _textToshow,
                  color: _color,
                )
              : Container(),
          WordPanel(essantialWords, additionalWords),
        ],
      ),
    );
  }

  void _wordFound(
      BuildContext context, List<int> selectedItemsIndex, Offset endDetails) {
    final wordFound = indexesToWord(selectedItemsIndex);
    final Size size = MediaQuery.of(context).size;

    if ((essantialWords.contains(wordFound.word) ||
            additionalWords.contains(wordFound.word)) &&
        endDetails != null) {
      AssetsAudioPlayer.playAndForget(
        Audio("assets/sounds/wrong.mp3"),
      );
      mapTextPosition = Offset((endDetails.dx * 2 / size.width) - 1,
          (endDetails.dy * 2 / size.height) - 1);
      setState(() {
        _isAlreadyWord = true;
        _textToshow = "ALREADY\nFOUND";
        _color = Colors.amber.shade400;
      });
    } else if (widget.words.contains(wordFound.word)) {
      mapTextPosition = Offset((endDetails.dx * 2 / size.width) - 1,
          (endDetails.dy * 2 / size.height) - 1);
      setState(() {
        AssetsAudioPlayer.playAndForget(
          Audio("assets/sounds/correct.mp3"),
        );
        essantialWords.add(wordFound.word);
        _score += wordFound.score;
        _isEssantialWord = true;
        _textToshow = "WORD\nREVEALED";
        _color = Colors.blue.shade400;
        widget.words.removeAt(widget.words.indexOf(wordFound.word));
      });
    } else if (all.contains(wordFound.word)) {
      AssetsAudioPlayer.playAndForget(
        Audio("assets/sounds/correct.mp3"),
      );
      mapTextPosition = Offset((endDetails.dx * 2 / size.width) - 1,
          (endDetails.dy * 2 / size.height) - 1);
      setState(() {
        additionalWords.add(wordFound.word);
        _score += wordFound.score;
        _isAdditionalWord = true;
        _textToshow = "ADDITIONAL\nWORD";
        _color = Colors.red.shade400;
      });
    } else {
      AssetsAudioPlayer.playAndForget(
        Audio("assets/sounds/wrong.mp3"),
      );
    }
  }

  void initializeBoard() {
    mapTextPosition = Offset(0, 0);
    // Create a new puzzle
    newPuzzle = wordSearch.newPuzzle(widget.words, ws);

    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors.isEmpty) {
      // The puzzle output
      print('Puzzle 2D List');
      print(newPuzzle.toString());
      print(newPuzzle.puzzle);
      // Solve puzzle for given word list
      final WSSolved solved =
          wordSearch.solvePuzzle(newPuzzle.puzzle, widget.words);
      // All found words by solving the puzzle
      print('Found Words!');
      solved.found.forEach((element) {
        print('word: ${element.word}, orientation: ${element.orientation}');
        print('x:${element.x}, y:${element.y}');

        for (int i = 0; i < sizeGrid; i++) {
          wordsgrid += newPuzzle.puzzle[i];
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScoreAndWordModel indexesToWord(List<int> indexes) {
    String generatedWord = "";
    int wordScore = 0;

    for (int i = 0; i < indexes.length; i++) {
      generatedWord += wordsgrid[indexes[i]];
      wordScore += letterScore[wordsgrid[indexes[i]]];
    }
    print("score is :");
    print(wordScore);
    return ScoreAndWordModel(wordScore, generatedWord);
  }
}

class ScoreAndWordModel {
  final int score;
  final String word;

  ScoreAndWordModel(this.score, this.word);
}
