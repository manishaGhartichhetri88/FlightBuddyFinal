import 'package:flutter/material.dart';

class FlightRowTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const FlightRowTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
