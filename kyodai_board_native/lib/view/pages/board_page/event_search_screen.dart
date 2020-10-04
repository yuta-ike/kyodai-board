import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/enums/place.dart';
import 'package:kyodai_board/model/value_objects/query/event_query.dart';
import 'package:provider/provider.dart';

class EventSearchScreen extends HookWidget{
  const EventSearchScreen({ this.eventQuery });

  final EventQuery eventQuery;

  @override
  Widget build(BuildContext context) {
    // final isDetail = useState(false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          'イベント検索',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider.value(
            value: eventQuery,
            builder: (context, _) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context, 'イベント種別'),
                    _buildMultiChoiceChips<ClubType>(context, {
                      for (final e in ClubType.values.where((element) => element != ClubType.none)) e : e.format
                    }),

                    _buildHeader(context, '日程'),
                    _buildDataChoiceChips(context, {
                      for (final e in EventDateChoice.values) e : e.format
                    }),

                    _buildHeader(context, '集合場所'),
                    _buildMultiChoiceChips<Place>(context, {
                      for (final e in Place.values) e : e.format
                    }),

                    // if(isDetail.value)
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 16),
                    //     child: Column(
                    //       children: [
                    //         _buildHeader(context, '実施曜日'),
                    //         _buildMultiChoiceChips<DayOfWeek>(context, {
                    //           for (final e in DayOfWeek.values.sortInDayOrder(start: DayOfWeek.monday)) e : e.format
                    //         }),
                    //       ]
                    //     ),
                    //   ),

                    const SizedBox(height: 16),

                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      onPressed: (){
                        Navigator.of(context).pop(eventQuery);
                      },
                      child: const Text('検索'),
                    ),

                    // if(!isDetail.value)
                    //   OutlineButton(
                    //     onPressed: () => isDetail.value = !isDetail.value,
                    //     child: const Text('詳細検索'),
                    //   ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildDataChoiceChips(BuildContext context, Map<EventDateChoice, String> items) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.entries.map<Widget>((item) {
        final isSelected = context.select<EventQuery, bool>((value) => value.dateChoice == item.key);
        return ChoiceChip(
          selectedColor: Colors.cyan,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          label: Text(
            item.value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black
            ),
          ),
          selected: isSelected,
          onSelected: (_) => context.read<EventQuery>().dateChoice = item.key,
        );
      }
      ).toList(),
    );
  }

  Widget _buildMultiChoiceChips<T>(BuildContext context, Map<T, String> items) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.entries.map<Widget>((item) {
        final isSelected = context.watch<EventQuery>().isSelected(item.key);
        return FilterChip(
          avatar: isSelected ? null : Icon(
              Icons.check,
              size: 20,
              color: Colors.grey[400],
            ),
          selectedColor: Colors.cyan,
          checkmarkColor: Colors.white,
          label: Text(
            item.value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black
            ),
          ),
          selected: isSelected,
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