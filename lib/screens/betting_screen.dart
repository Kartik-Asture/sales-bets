import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../models/event.dart';
import '../services/bet_service.dart';
import '../providers/auth_provider.dart';

class BettingScreen extends ConsumerStatefulWidget {
  final Event event;

  const BettingScreen({super.key, required this.event});

  @override
  ConsumerState<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends ConsumerState<BettingScreen> {
  final BetService _betService = BetService();
  String? _selectedTeamId;
  int _stakeAmount = 10;
  bool _isPlacingBet = false;
  final ConfettiController _confettiController = ConfettiController();

  final List<int> _stakeOptions = [10, 25, 50, 100];

  @override
  void initState() {
    super.initState();
    _confettiController.addListener(() {
      if (_confettiController.state == ConfettiControllerState.playing) {
        Future.delayed(const Duration(seconds: 3), () {
          _confettiController.stop();
        });
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _placeBet() async {
    if (_selectedTeamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a team to bet on')),
      );
      return;
    }

    setState(() {
      _isPlacingBet = true;
    });

    try {
      final userState = ref.read(userProvider);
      final user = userState.value;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to place bets')),
        );
        return;
      }

      await _betService.placeBet(
        userId: user.id,
        eventId: widget.event.id,
        selectedTeamId: _selectedTeamId!,
        stakedAmount: _stakeAmount,
      );

      // Show success animation
      _confettiController.play();

      // Show success dialog that auto-closes
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Success!'),
          content: Text(
            'Bet placed successfully!\nPotential winnings: ${(_stakeAmount * 1.5).round()} credits',
          ),
        ),
      );

      // Auto-close dialog and navigate back after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context); 
          Navigator.pop(context); 
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place bet: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingBet = false;
        });
      }
    }
  }

  int get _potentialWinnings {
    return (_stakeAmount * 1.5).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Place Your Bet')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.event.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(widget.event.startTime),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Team Selection
                const Text(
                  'Select Team to Bet On',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _TeamSelectionCard(
                        teamId: widget.event.teamAId,
                        teamName: 'Team A',
                        isSelected: _selectedTeamId == widget.event.teamAId,
                        onTap: () {
                          setState(() {
                            _selectedTeamId = widget.event.teamAId;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TeamSelectionCard(
                        teamId: widget.event.teamBId,
                        teamName: 'Team B',
                        isSelected: _selectedTeamId == widget.event.teamBId,
                        onTap: () {
                          setState(() {
                            _selectedTeamId = widget.event.teamBId;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stake Amount
                const Text(
                  'Select Stake Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _stakeOptions.map((amount) {
                    return ChoiceChip(
                      label: Text('$amount Credits'),
                      selected: _stakeAmount == amount,
                      onSelected: (selected) {
                        setState(() {
                          _stakeAmount = amount;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Custom Stake Input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Custom Amount',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = int.tryParse(value);
                    if (amount != null && amount > 0) {
                      setState(() {
                        _stakeAmount = amount;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Bet Summary
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Bet Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          'Stake Amount',
                          '$_stakeAmount Credits',
                        ),
                        _buildSummaryRow(
                          'Potential Winnings',
                          '$_potentialWinnings Credits',
                        ),
                        _buildSummaryRow('Return Rate', '+50%'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.security,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'No-loss guarantee: You risk nothing!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Place Bet Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isPlacingBet ? null : _placeBet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isPlacingBet
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Place Bet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _TeamSelectionCard extends StatelessWidget {
  final String teamId;
  final String teamName;
  final bool isSelected;
  final VoidCallback onTap;

  const _TeamSelectionCard({
    required this.teamId,
    required this.teamName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue.shade50 : null,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: isSelected
                    ? Colors.blue
                    : Colors.grey.shade300,
                child: Icon(
                  Icons.groups,
                  color: isSelected ? Colors.white : Colors.grey,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                teamName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
