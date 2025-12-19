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
        scaffoldBackgroundColor: const Color(0xFF53586A), // 피그마 시안의 배경색
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const SplashScreen(), // 시작 화면을 SplashScreen으로 설정
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

  // 보상 시스템 변수들 (추후 UI와 연결)
  int _totalXp = 0;
  int _totalCoin = 0;
  int _totalCredibility = 100;

  Mission get _currentMission => gameMissions[_currentMissionIndex];

  // 피그마 시안의 팝업 다이얼로그를 보여주는 함수
  void _showHintDialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
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

  // TODO: 판단/공유 로직을 새 UI에 맞게 재구성해야 합니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              // 중앙 기사 화면
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      _currentMission.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              // 상단 도구 버튼
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToolButton(label: 'AI', isCircle: true, onTap: () => _showHintDialog('너무 긴 내용의 기사는 AI의 도움을 받으세요. 단, AI는 실수할 수 있습니다.')),
                    ToolButton(label: '달력', onTap: () => _showHintDialog('달력에 적혀 있는 날짜와 사건이 기사의 날짜와 사건과 일치하는지 확인하세요.')),
                  ],
                ),
              ),

              // 하단 도구 버튼
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ToolButton(label: '컴퓨터', width: 120, height: 80, onTap: () => _showHintDialog('컴퓨터를 통해 다른 사이트에서도 검색한 뒤, 기사 내용과 일치하는지 확인하세요.')),
                    ToolButton(label: '돋보기', isCircle: true, onTap: () => _showHintDialog('돋보기를 통해 기사 속 자료의 출처가 올바른지 확인하세요.')),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ToolButton(label: '파일', width: 120, height: 60, onTap: () => _showHintDialog('파일에는 기자들의 정보가 적혀있습니다. 정보가 일치하는지, 믿을 만한 기자인지 확인하세요.')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 피그마 시안의 버튼 스타일을 적용한 재사용 위젯
class ToolButton extends StatelessWidget {
  final String label;
  final bool isCircle;
  final double width;
  final double height;
  final VoidCallback onTap;

  const ToolButton({
    super.key,
    required this.label,
    this.isCircle = false,
    this.width = 100,
    this.height = 60,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCircle ? 80 : width,
        height: isCircle ? 80 : height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(isCircle ? 40 : 16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 4)],
        ),
        child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ),
    );
  }
}
