import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/util/day_of_week.dart';
import 'package:kyodai_board/model/value_objects/event_query/event_query.dart';
import 'package:provider/provider.dart';

class EventSearchScreen extends HookWidget{
  const EventSearchScreen({ this.query });

  final EventQuery query;

  @override
  Widget build(BuildContext context) {
    final isDetail = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント検索'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider.value(
            value: query,
            builder: (context, _) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SearchBox(
                    //   hintText: '例: バスケットボール 体育会',
                    //   autofocus: true,
                    // ),

                    _buildHeader(context, '日付'),
                    _buildChips<EventDateChoice>(context, {
                      for (final e in EventDateChoice.values) e : e.format
                    }),
                    // OutlineButton(
                    //   onPressed: () => showDateRangePicker(
                    //     context: context,
                    //     firstDate: DateTime.now(),
                    //     lastDate: DateTime.now().add(const Duration(days: 365))
                    //   ),
                    //   child: const Text('期間を選択'),
                    // ),
                    _buildHeader(context, 'イベント種別'),
                    _buildChips<ClubType>(context, {
                      for (final e in ClubType.values) e : e.format
                    }),

                    const SizedBox(height: 16),

                    if(isDetail.value)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            _buildHeader(context, '実施曜日'),
                            _buildChips<DayOfWeek>(context, {
                              for (final e in DayOfWeek.values) e : e.format
                            }),
                            _buildHeader(context, '時間帯'),
                            _buildChips<EventTime>(context, {
                              for (final e in EventTime.values) e : e.format
                            }),
                          ]
                        ),
                      ),
                    
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      onPressed: (){
                        Navigator.of(context).pop(query);
                      },
                      child: const Text('検索'),
                    ),

                    if(!isDetail.value)
                      OutlineButton(
                        onPressed: () => isDetail.value = !isDetail.value,
                        child: const Text('詳細検索'),
                      ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChips<T>(BuildContext context, Map<T, String> items) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.entries.map<Widget>((item) {
        return ChoiceChip(
          label: Text(item.value),
          selected: context.watch<EventQuery>().isSelected(item.key),
          onSelected: (_) => context.read<EventQuery>().toggle(item.key),
        );
      }
      ).toList(),
    );
  }

  FractionallySizedBox _buildHeader(BuildContext context, String header) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        child: Text(
          header,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Colors.black87,
          ),
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
          ))
        ),
      ),
    );
  }
}