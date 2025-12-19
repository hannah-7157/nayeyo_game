import 'package:flutter/material.dart';
import '../models/mission_models.dart';

class NewsfeedPanel extends StatelessWidget {
  const NewsfeedPanel({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[200], child: const Center(child: Text('뉴스피드')));
  }
}

class ContentViewerPanel extends StatelessWidget {
  final Mission mission;
  const ContentViewerPanel({super.key, required this.mission});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(mission.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(mission.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18)),
        ]));
  }
}

class FactCheckPanel extends StatelessWidget {
  final VoidCallback onAiSearch;
  final List<String> discoveredClues;
  final VoidCallback onDiscoverClues;
  const FactCheckPanel({super.key, required this.onAiSearch, required this.discoveredClues, required this.onDiscoverClues});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('팩트체크 도구함', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(elevation: 1, child: ListTile(leading: const Icon(Icons.search), title: const Text('AI 검색'), onTap: onAiSearch)),
          Card(elevation: 1, child: ListTile(leading: const Icon(Icons.style), title: const Text('단서 카드'), onTap: onDiscoverClues)),
          const Divider(height: 32),
          Text('증거 보관함', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Expanded(
              child: discoveredClues.isEmpty
                  ? const Center(child: Text('획득한 단서가 없습니다.'))
                  : ListView.builder(
                      itemCount: discoveredClues.length,
                      itemBuilder: (context, index) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: Text(discoveredClues[index])))))]));
  }
}
