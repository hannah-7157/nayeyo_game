enum Judgment { real, fake, unsure }

enum GamePhase { judging, sharing }

class Mission {
  final String title;
  final String content;
  final List<String> clues;
  final String aiHint;
  final Judgment correctAnswer;
  final String correctFeedback;
  final String wrongFeedback;
  final String shareResult;
  final String stopResult;

  Mission({
    required this.title,
    required this.content,
    required this.clues,
    required this.aiHint,
    required this.correctAnswer,
    required this.correctFeedback,
    required this.wrongFeedback,
    required this.shareResult,
    required this.stopResult,
  });
}

class PlayerStat {
  final int missionIndex;
  final Mission mission;
  final Judgment playerJudgment;
  final bool wasCorrect;
  final int score;
  final int coin;

  PlayerStat({
    required this.missionIndex,
    required this.mission,
    required this.playerJudgment,
    required this.wasCorrect,
    required this.score,
    required this.coin,
  });
}
