import 'package:flutter/material.dart';
import '../models/mission_models.dart';

class BottomBar extends StatelessWidget {
  final GamePhase phase;
  final Function(Judgment) onJudgment;
  final Function(bool) onShare;

  const BottomBar({super.key, required this.phase, required this.onJudgment, required this.onShare});

  @override
  Widget build(BuildContext context) {
    final judgmentButtons = [
      ElevatedButton(onPressed: () => onJudgment(Judgment.real), child: const Text('진짜')),
      ElevatedButton(onPressed: () => onJudgment(Judgment.fake), child: const Text('가짜')),
      ElevatedButton(onPressed: () => onJudgment(Judgment.unsure), child: const Text('판단 유보')),
    ];

    final shareButtons = [
      ElevatedButton(onPressed: () => onShare(true), child: const Text('공유하기')),
      ElevatedButton(onPressed: () => onShare(false), child: const Text('확산 중지')),
    ];

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: phase == GamePhase.judging ? judgmentButtons : shareButtons,
      ),
    );
  }
}
