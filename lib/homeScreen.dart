import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adaptive UI Example'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Large screen layout
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(child: Block(color: Colors.red, text: 'Block 1')),
                      Expanded(child: Block(color: Colors.green, text: 'Block 2')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Block(color: Colors.blue, text: 'Block 3'),
                ),
              ],
            );
          } else {
            // Small screen layout
            return Column(
              children: [
                Expanded(child: Block(color: Colors.red, text: 'Block 1')),
                Expanded(child: Block(color: Colors.green, text: 'Block 2')),
                Expanded(child: Block(color: Colors.blue, text: 'Block 3')),
              ],
            );
          }
        },
      ),
    );
  }
}

class Block extends StatelessWidget {
  final Color color;
  final String text;

  Block({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}