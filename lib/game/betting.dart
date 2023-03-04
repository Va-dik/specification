import 'dart:math';
import 'package:flutter/material.dart';
import 'package:specification/game/actions.dart';

class Betting extends StatefulWidget {
  const Betting({super.key});

  @override
  State<Betting> createState() => _BettingState();
}

class _BettingState extends State<Betting> {
  int _money = 100;
  int _randomIndex = 3;
  bool _isStart = false;

  void _startButton() {
    if (!_isStart && ActionsGame.controllerParser() > 0) {
      setState(() {
        _money -= ActionsGame.controllerParser();
        _isStart = true;
      });
    }
  }

  void chooseContainer(int index) {
    if (_isStart) {
      setState(() {
        _randomIndex = Random().nextInt(3);
        if (index == _randomIndex) {
          _money += ActionsGame.controllerParser() * 2;
        }
        _isStart = false;
        Future.delayed(
          const Duration(seconds: 3),
          () => setState(() => _randomIndex = -1),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: null,
              icon: Image.asset(
                'assets/icons/coin.png',
                scale: 12,
              ),
              label: Text(
                _money.toString(),
                style: const TextStyle(fontSize: 30, color: Colors.brown),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 21.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => chooseContainer(index),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(83, 149, 215, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: index != _randomIndex
                        ? Image.asset(
                            'assets/icons/chip.png',
                          )
                        : Image.asset(
                            'assets/icons/coin.png',
                          ),
                  ),
                ),
              ),
            ),
          ),
          ActionsGame(
            money: _money,
            isStart: _isStart,
            randomIndex: _randomIndex,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _startButton,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }
}
