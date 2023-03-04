import 'package:flutter/material.dart';

class ActionsGame extends StatefulWidget {
  const ActionsGame({super.key, required this.money, required this.isStart, required this.randomIndex});
  final int money;
  final bool isStart;
  final int randomIndex;

  static TextEditingController betController = TextEditingController(text: '0');

  static int controllerParser() {
    return int.parse(betController.text);
  }

  @override
  State<ActionsGame> createState() => _ActionsGameState();
}

class _ActionsGameState extends State<ActionsGame> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        valueButton(
          icon: Icons.arrow_drop_up_rounded,
          onPressed: () => setState(() {
            if (ActionsGame.controllerParser() < widget.money) {
              ActionsGame.betController.text = (ActionsGame.controllerParser() + 1).toString();
            }
          }),
        ),
        SizedBox(
          width: 50,
          child: TextField(
            textAlign: TextAlign.center,
            controller: ActionsGame.betController,
            style: const TextStyle(fontSize: 30, color: Colors.brown),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        valueButton(
          icon: Icons.arrow_drop_down_rounded,
          onPressed: () => setState(() {
            if (ActionsGame.controllerParser() > 0) {
              ActionsGame.betController.text = (ActionsGame.controllerParser() - 1).toString();
            }
          }),
        ),
      ],
    );
  }

  Widget valueButton(
      {required IconData icon, required void Function()? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(shape: const CircleBorder()),
      child: Icon(
        icon,
        size: 34,
      ),
    );
  }
}
