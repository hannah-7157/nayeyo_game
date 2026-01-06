import 'package:flutter/material.dart';
import '../models/mission_models.dart';

class ReportScreen extends StatelessWidget {
  final List<PlayerStat> stats;
  final int finalXp;
  final int finalCoin;
  final int finalCredibility;

  const ReportScreen({
    super.key,
    required this.stats,
    required this.finalXp,
    required this.finalCoin,
    required this.finalCredibility,
  });

  Map<String, dynamic> _analyzeMistakes() {
    final mistakes = stats.where((s) => !s.wasCorrect).toList();
    if (mistakes.isEmpty) {
      return {
        'pattern': '특별한 실수 패턴이 발견되지 않았습니다. 훌륭해요!',
        'recommendations': ['완벽해요! 지금처럼 신중하게 판단해주세요.']
      };
    }

    int stage1Mistakes = mistakes.where((s) => s.missionIndex >= 0 && s.missionIndex <= 4).length;
    int stage2Mistakes = mistakes.where((s) => s.missionIndex >= 5 && s.missionIndex <= 8).length;
    int stage3Mistakes = mistakes.where((s) => s.missionIndex >= 9).length;

    if (stage3Mistakes >= stage1Mistakes && stage3Mistakes >= stage2Mistakes) {
      return {
        'pattern': '데이터/통계(3단계) 미션에서 실수가 잦았습니다.',
        'recommendations': [
          '그래프의 축(y-axis) 범위를 항상 확인하세요.',
          '전체 기간 데이터와 비교하는 습관을 기르세요.',
          '통계의 기준(총량 vs 비율)을 명확히 구분하세요.'
        ]
      };
    } else if (stage2Mistakes >= stage1Mistakes) {
      return {
        'pattern': 'SNS 루머(2단계) 판별에 어려움을 겪었습니다.',
        'recommendations': [
          '캡처본보다 원본 출처를 찾아보세요.',
          '댓글 여론과 기사의 사실을 분리해서 생각하세요.',
          '사진이 다른 맥락에서 재사용되지 않았는지 역검색을 활용하세요.'
        ]
      };
    } else {
      return {
        'pattern': '뉴스의 겉모습(1단계)을 판단할 때 실수가 있었습니다.',
        'recommendations': [
          '자극적인 제목과 과장된 표현을 항상 의심하세요.',
          '오탈자나 어색한 문장은 위험 신호입니다.',
          '본문 내용이 제목과 일치하는지 꼭 확인하세요.'
        ]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final correctCount = stats.where((s) => s.wasCorrect).length;
    final totalCount = stats.length;
    final String correctRate = totalCount > 0 ? (correctCount / totalCount * 100).toStringAsFixed(1) : "0";
    final goodUboCount = stats.where((s) => s.wasCorrect && s.playerJudgment == Judgment.unsure).length;
    final analysis = _analyzeMistakes();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('종합 보고서'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('최종 결과', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(title: '총 XP', value: '$finalXp', icon: Icons.star, color: Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: '총 코인', value: '$finalCoin', icon: Icons.monetization_on, color: Colors.amber)),
            ],
          ),
          const SizedBox(height: 16),
          StatCard(title: '최종 신뢰도', value: '$finalCredibility', icon: Icons.shield, color: Colors.green),
          const Divider(height: 40),
          Text('나의 판별 기록', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          Card(child: ListTile(title: const Text('정답률'), trailing: Text('$correctRate%', style: Theme.of(context).textTheme.titleLarge))),
          Card(child: ListTile(title: const Text('"유보"를 잘한 횟수'), trailing: Text('$goodUboCount회', style: Theme.of(context).textTheme.titleLarge))),
          const Divider(height: 40),
          Text('실수 패턴 분석', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(analysis['pattern']!, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('추천 체크리스트', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...(analysis['recommendations']! as List<String>).map((rec) => ListTile(
                        leading: const Icon(Icons.check, size: 20),
                        title: Text(rec),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
