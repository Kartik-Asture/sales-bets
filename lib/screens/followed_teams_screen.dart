import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/follow_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/team_card.dart';

class FollowedTeamsScreen extends ConsumerWidget {
  const FollowedTeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followedTeamsAsync = ref.watch(followedTeamsProvider);
    final allTeamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Followed Teams')),
      body: followedTeamsAsync.when(
        data: (followedTeamIds) {
          if (followedTeamIds.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Teams Followed',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Follow teams to see their updates here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return allTeamsAsync.when(
            data: (allTeams) {
              final followedTeams = allTeams
                  .where((team) => followedTeamIds.contains(team.id))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: followedTeams.length,
                itemBuilder: (context, index) {
                  final team = followedTeams[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TeamCard(
                      team: team,
                      showDetails: true,
                      showFollowButton: true,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
