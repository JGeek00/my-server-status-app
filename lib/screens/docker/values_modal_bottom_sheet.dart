import 'package:flutter/material.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';

class ValuesModalBottomSheet extends StatelessWidget {
  final String label;
  final Map<String, String> values;

  const ValuesModalBottomSheet({
    Key? key,
    required this.values,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28)
            )
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24
                  ),
                ),
              ),
              ...values.keys.map((key) => CustomListTile(
                title: key,
                subtitle: values[key],
              ))
            ],
          ),
        ),
      ),
    );
  }
}