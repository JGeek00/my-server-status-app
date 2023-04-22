import 'package:flutter/material.dart';

class CompactDataRow extends StatelessWidget {
  final String label;
  final String value;

  const CompactDataRow({
    Key? key,
    required this.label,
    required this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
              ),
            )
          ),
          const SizedBox(width: 16),
          Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14
            ),
          )
        ],
      ),
    );
  }
}