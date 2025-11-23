import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_bets/providers/follow_provider.dart';
import '../providers/auth_provider.dart';

class FollowButton extends ConsumerStatefulWidget {
  final String teamId;
  final String teamName;

  const FollowButton({super.key, required this.teamId, required this.teamName});

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _isLoading = false;

  Future<void> _toggleFollow(bool isCurrentlyFollowing) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final followService = ref.read(followServiceProvider);
      await followService.toggleFollowTeam(widget.teamId, isCurrentlyFollowing);

      // Refresh user data to get updated follow status
      ref.invalidate(userProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCurrentlyFollowing
                ? 'Unfollowed ${widget.teamName}'
                : 'Following ${widget.teamName}',
          ),
          backgroundColor: isCurrentlyFollowing ? Colors.grey : Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return _buildLoginPrompt();
        }

        final isFollowing = user.isFollowing(widget.teamId);

        return _isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : ElevatedButton(
                onPressed: () => _toggleFollow(isFollowing),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isFollowing ? Icons.check : Icons.add, size: 16),
                    const SizedBox(width: 4),
                    Text(isFollowing ? 'Following' : 'Follow'),
                  ],
                ),
              );
      },
      loading: () => const CircularProgressIndicator(strokeWidth: 2),
      error: (error, stack) => const Icon(Icons.error, color: Colors.red),
    );
  }

  Widget _buildLoginPrompt() {
    return OutlinedButton(
      onPressed: () {
        // Navigate to login screen if needed
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.login, size: 16),
          SizedBox(width: 4),
          Text('Login to Follow'),
        ],
      ),
    );
  }
}
