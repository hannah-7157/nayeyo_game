import 'package:flutter/material.dart';
import 'package:nayeyo/models/mission_models.dart';
import 'package:nayeyo/data/game_data.dart';
import 'package:nayeyo/ui/report_screen.dart';
import 'package:nayeyo/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF42475A),
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentMissionIndex = 0;
  final List<PlayerStat> _playerStats = [];

  int _totalXp = 0;
  int _totalCoin = 0;
  int _totalCredibility = 100;

  Mission get _currentMission => gameMissions[_currentMissionIndex];

  void _showInfoDialog(String title, String? content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content ?? "확인할 수 있는 정보가 없습니다.", style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인")),
        ],
      ),
    );
  }

  void _handleJudgment(Judgment judgment) {
    bool isCorrect = judgment == _currentMission.correctAnswer;
    int earnedXp = isCorrect ? 20 : 0;
    int earnedCoin = isCorrect ? 10 : 0;
    
    if (!isCorrect) {
      _totalCredibility = (_totalCredibility - 15).clamp(0, 100);
    }

    _playerStats.add(PlayerStat(
      missionIndex: _currentMissionIndex,
      mission: _currentMission,
      playerJudgment: judgment,
      wasCorrect: isCorrect,
      score: earnedXp,
      coin: earnedCoin,
    ));

    setState(() {
      _totalXp += earnedXp;
      _totalCoin += earnedCoin;
    });

    _showResultDialog(isCorrect, judgment);
  }

  void _showResultDialog(bool isCorrect, Judgment judgment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.error,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(isCorrect ? "정답입니다!" : "아쉬워요!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCorrect ? _currentMission.correctFeedback : _currentMission.wrongFeedback),
            const SizedBox(height: 16),
            Text(
              judgment == Judgment.unsure ? _currentMission.stopResult : _currentMission.shareResult,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _nextMission();
            },
            child: const Text("다음 미션으로"),
          ),
        ],
      ),
    );
  }

  void _nextMission() {
    if (_currentMissionIndex < gameMissions.length - 1) {
      setState(() {
        _currentMissionIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => ReportScreen(
                stats: _playerStats,
                finalXp: _totalXp,
                finalCoin: _totalCoin,
                finalCredibility: _totalCredibility)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 상태 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("미션 ${_currentMissionIndex + 1}/${gameMissions.length}",
                          style: const TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.greenAccent, size: 22),
                          const SizedBox(width: 6),
                          Text("$_totalCredibility%",
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildStatItem("XP", _totalXp.toString(), Colors.blueAccent),
                      const SizedBox(width: 24),
                      _buildStatItem("COIN", _totalCoin.toString(), Colors.orangeAccent),
                    ],
                  )
                ],
              ),
            ),

            // 2. 중앙 기사 카드
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("LEVEL 1 NEWS",
                              style: TextStyle(color: Color(0xFFA0A5BA), fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentMission.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D243E),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _currentMission.content,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF53586A),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: Color(0xFFE5E8F0), thickness: 1.5),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text("당신의 판단은?",
                              style: TextStyle(
                                color: Color(0xFFA0A5BA),
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              )),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildJudgmentButton("진실", Colors.green, () => _handleJudgment(Judgment.real)),
                            _buildJudgmentButton("거짓", Colors.red, () => _handleJudgment(Judgment.fake)),
                            _buildJudgmentButton("유보", Colors.orange, () => _handleJudgment(Judgment.unsure)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. 하단 도구 버튼들
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30.0, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolButton(Icons.description, "파일", const Color(0xFF67AFE9),
                      () => _showInfoDialog("기자 정보", _currentMission.reporterInfo)),
                  _buildToolButton(Icons.calendar_today, "달력", const Color(0xFFEB7D7D),
                      () => _showInfoDialog("날짜 정보", _currentMission.dateInfo)),
                  _buildToolButton(Icons.search, "컴퓨터", const Color(0xFF75D094),
                      () => _showInfoDialog("검색 결과", _currentMission.computerInfo)),
                  _buildToolButton(Icons.zoom_in, "돋보기", const Color(0xFFC18DDA),
                      () => _showInfoDialog("상세 보기", _currentMission.zoomInfo)),
                  _buildToolButton(Icons.smart_toy, "AI로봇", const Color(0xFF86D3F3),
                      () => _showInfoDialog("AI 힌트", _currentMission.aiHint)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJudgmentButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildToolButton(IconData icon, String label, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
