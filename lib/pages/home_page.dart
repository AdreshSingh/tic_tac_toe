import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // varibales for holding tic tac toe
  String tictactoe = "";
  int turnCount = 0;
  bool user = false;
  bool play = true;

  // variables to hold turn symbols
  final String firstUser = "0";
  final String secondUser = "x";
  String winner = "";

  List<List<String>> gameSteps = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: Column(
          children: [
            // player details
            PlayerInfo(user: user),
            // tictactoe box
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, position) {
                      // getting row count
                      int row = (position >= 6) ? 2 : (position >= 3 ? 1 : 0);
                      // debugPrint(gameSteps[row][position % 3]);
                      return GestureDetector(
                        onTap: () {
                          _tapped(row, position);
                        },
                        // tictactoe single tile
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey[700]!,
                          )),
                          child: Text(
                            gameSteps[row][position % 3],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _clean();
              turnCount = 0;
              winner = "";
            });
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  // for handlling taps
  void _tapped(int row, int index) {
    if (user && turnCount <= 9) {
      setState(() {
        if (gameSteps[row][index % 3] == "") {
          gameSteps[row][index % 3] = "0";
          user = !user;
          turnCount += 1;
          _winner();
        }
      });
    } else {
      setState(() {
        if (gameSteps[row][index % 3] == "") {
          gameSteps[row][index % 3] = "x";
          user = !user;
          turnCount += 1;
          _winner();
        }
      });
    }

    debugPrint("$turnCount");
    if (turnCount == 9 && winner == "" && play) {
      setState(() {
        _showDialog(context, false);
        play = false;
      });
    }
  }

  // checking winner by patterns
  void _winner() {
    // possible win patterns
    void patterns(String turn) {
      // straight rows
      if (gameSteps[0][0] == turn &&
          gameSteps[0][1] == turn &&
          gameSteps[0][2] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      } else if (gameSteps[1][0] == turn &&
          gameSteps[1][1] == turn &&
          gameSteps[1][2] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      } else if (gameSteps[2][0] == turn &&
          gameSteps[2][1] == turn &&
          gameSteps[2][2] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // cross rows
      // 1 -> 0,0
      else if (gameSteps[0][0] == turn &&
          gameSteps[1][1] == turn &&
          gameSteps[2][2] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // 2 -> 0,1
      else if (gameSteps[0][1] == turn &&
          gameSteps[1][1] == turn &&
          gameSteps[2][1] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // 3 -> 0,2
      else if (gameSteps[0][2] == turn &&
          gameSteps[1][1] == turn &&
          gameSteps[2][0] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // vertical plates
      else if (gameSteps[0][0] == turn &&
          gameSteps[1][0] == turn &&
          gameSteps[2][0] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // 1 -> 1,1
      else if (gameSteps[0][1] == turn &&
          gameSteps[1][1] == turn &&
          gameSteps[2][1] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      // 3 -> 0,2
      else if (gameSteps[0][2] == turn &&
          gameSteps[1][2] == turn &&
          gameSteps[2][2] == turn) {
        debugPrint("user wins: $turn");
        _showDialog(context);
      }
      winner = turn;
    }

    // matching patterns based on turn of player
    patterns(firstUser);
    patterns(secondUser);
  }

  void _clean() {
    for (List<String> plate in gameSteps) {
      plate[0] = "";
      plate[1] = "";
      plate[2] = "";
    }
    play = true;
  }

  Future<void> _showDialog(BuildContext context, [bool draw = false]) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(!draw ? "Congratulations" : "Draw"),
          content: Text(
              !draw ? "🌟Winner of the Match🌟 ✨$winner" : "Match is draw"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _clean();
                  turnCount = 0;
                  Navigator.of(context).pop();
                  winner = "";
                });
              },
              child: const Text("play again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("done"),
            ),
          ],
        );
      },
    );
  }
}

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({
    super.key,
    required this.user,
  });

  final bool user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: user ? Colors.green[300] : Colors.red[300],
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        (user) ? "X" : "Y",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
