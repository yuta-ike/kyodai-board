import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ClubReportDialog<T> extends HookWidget{
  const ClubReportDialog(this.reportContents, this.getLabel, this.send);
  final List<T> reportContents;
  final String Function(T) getLabel;
  final Future<void> Function(T, String) send;
  
  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<T>(null);
    final controller = useTextEditingController();
    final isValid = useState(false);

    controller.addListener(() {
      isValid.value = selectedItem.value != null && controller.value.text.isNotEmpty;
    });

    useEffect((){
      isValid.value = selectedItem.value != null && controller.value.text.isNotEmpty;
    }, [selectedItem.value]);

    return AlertDialog(
      title: const Text('通報'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('1. 問題を選択してください'),
            ...reportContents.map((reportContent) =>
              RadioListTile<T>(
                title: Text(getLabel(reportContent)),
                value: reportContent,
                groupValue: selectedItem.value,
                onChanged: (value) => selectedItem.value = value,
              )
            ),
            const SizedBox(height: 8),
            const Text('2. 問題の内容を記入してください'),
            TextField(
              controller: controller,
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: const Text('通報'),
          onPressed: isValid.value ? () async {
            await send(selectedItem.value, controller.value.text);
            Navigator.pop(context, true);
          }
          : null
        ),
      ],
    );
  }
}