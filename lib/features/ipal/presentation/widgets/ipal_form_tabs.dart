import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum IpalFormTab { checklist, process }

class IpalFormTabs extends StatelessWidget {
  const IpalFormTabs({required this.selected, super.key});

  final IpalFormTab selected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<IpalFormTab>(
      segments: const [
        ButtonSegment(
          value: IpalFormTab.checklist,
          icon: Icon(Icons.checklist_outlined),
          label: Text('Checklist Harian'),
        ),
        ButtonSegment(
          value: IpalFormTab.process,
          icon: Icon(Icons.fact_check_outlined),
          label: Text('Catatan Proses'),
        ),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (values) {
        final target = values.first;
        if (target == selected) return;

        context.go(
          target == IpalFormTab.checklist
              ? '/form/ipal/checklist'
              : '/form/ipal/proses',
        );
      },
    );
  }
}
