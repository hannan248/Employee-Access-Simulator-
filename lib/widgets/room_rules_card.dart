import 'package:flutter/material.dart';
import '../models/room_rule.dart';
import '../services/data_service.dart';
import '../utils/time_utils.dart';

class RoomRulesCard extends StatelessWidget {
  const RoomRulesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.indigo[600]),
                const SizedBox(width: 8),
                const Text(
                  'Room Access Rules',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...DataService.roomRules.entries.map((entry) =>
                _buildRoomRuleRow(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomRuleRow(String roomName, RoomRule rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRoomIcon(roomName),
                size: 20,
                color: Colors.indigo[400],
              ),
              const SizedBox(width: 8),
              Text(
                roomName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildRuleDetail(
                  icon: Icons.verified_user,
                  label: 'Min Level',
                  value: rule.minAccessLevel.toString(),
                  color: _getAccessLevelColor(rule.minAccessLevel),
                ),
              ),
              Expanded(
                child: _buildRuleDetail(
                  icon: Icons.schedule,
                  label: 'Hours',
                  value: '${TimeUtils.formatTimeDisplay(rule.openTime)} - ${TimeUtils.formatTimeDisplay(rule.closeTime)}',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildRuleDetail(
            icon: Icons.timer,
            label: 'Cooldown',
            value: '${rule.cooldownMinutes} minutes',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleDetail({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRoomIcon(String roomName) {
    switch (roomName) {
      case 'ServerRoom':
        return Icons.computer;
      case 'Vault':
        return Icons.account_balance;
      case 'R&D Lab':
        return Icons.science;
      default:
        return Icons.room;
    }
  }

  Color _getAccessLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}