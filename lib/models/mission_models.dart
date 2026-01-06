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

  // 누락되었던 필드 추가
  final String? reporterInfo;
  final String? dateInfo;
  final String? computerInfo;
  final String? zoomInfo;


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
    // 생성자에도 추가
    this.reporterInfo,
    this.dateInfo,
    this.computerInfo,
    this.zoomInfo,
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
