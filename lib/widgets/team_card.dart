import 'package:flutter/material.dart';
import '../models/team.dart';
import 'follow_button.dart'; // Add this import

class TeamCard extends StatelessWidget {
  final Team team;
  final bool showDetails;
  final bool showFollowButton; // New parameter

  const TeamCard({
    super.key,
    required this.team,
    this.showDetails = false,
    this.showFollowButton = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircleAvatar(
              radius: showDetails ? 40 : 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: team.imageUrl.isNotEmpty
                  ? NetworkImage(team.imageUrl)
                  : null,
              child: team.imageUrl.isEmpty
                  ? Icon(
                      Icons.groups,
                      color: Colors.grey,
                      size: showDetails ? 30 : 20,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              team.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showDetails) ...[
              const SizedBox(height: 8),
              Text(
                team.sport,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat('Wins', team.winCount.toString()),
                  const SizedBox(width: 8),
                  _buildStat('Losses', team.lossCount.toString()),
                ],
              ),
              if (team.isTrending)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TRENDING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Add Follow Button
              if (showFollowButton) ...[
                const SizedBox(height: 12),
                FollowButton(teamId: team.id, teamName: team.name),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
