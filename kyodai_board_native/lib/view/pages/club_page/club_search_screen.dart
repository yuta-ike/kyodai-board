import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kyodai_board/model/enums/campus.dart';
import 'package:kyodai_board/model/enums/club_type.dart';
import 'package:kyodai_board/model/util/day_of_week.dart';
import 'package:kyodai_board/model/value_objects/query/club_query.dart';
import 'package:kyodai_board/model/value_objects/query/event_query.dart';
import 'package:kyodai_board/view/components/atom/search_box.dart';
import 'package:provider/provider.dart';

class ClubSearchScreen extends HookWidget{
  const ClubSearchScreen({ this.query });

  final ClubQuery query;

  @override
  Widget build(BuildContext context) {
    final isDetail = useState(false);
    final _dummy = useState(0);
    void update() => _dummy.value += 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('団体検索'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TODO: implement logic
                    SearchBox(hintText: '団体を検索'),

                    const SizedBox(height: 16),

                    _buildHeader(context, '団体種別'),
                    _buildMultiChoiceChips<ClubType>(
                      context,
                      items: ClubType.values,
                      getLabel: (item) => item.format,
                      isSelected: query.clubTypes.contains,
                      onSelected: (selected, item){
                        if(selected){
                          query.clubTypes.add(item);
                        }else{
                          query.clubTypes = query.clubTypes.where((_item) => _item != item).toList();
                        }
                        update();
                      }
                    ),

                    const SizedBox(height: 16),

                    if(isDetail.value) ...[
                      _buildHeader(context, '活動日'),
                      _buildMultiChoiceChips<DayOfWeek>(
                        context,
                        items: DayOfWeek.values.sortInDayOrder(start: DayOfWeek.monday),
                        getLabel: (item) => item.format,
                        isSelected: query.daysOfWeek.contains,
                        onSelected: (selected, item){
                          if(selected){
                            query.daysOfWeek.add(item);
                          }else{
                            print(item);
                            print(query.daysOfWeek);
                            query.daysOfWeek = query.daysOfWeek.where((_item) => _item != item).toList();
                          }
                          update();
                        }
                      ),

                      const SizedBox(height: 16),

                      _buildHeader(context, '所属人数'),
                      const SizedBox(height: 8),
                      Text('${
                          query.memberCount.start == 0.0 ? '' :
                          query.memberCount.start == 1.0 ? '10人以上' :
                          query.memberCount.start == 2.0 ? '30人以上' :
                          query.memberCount.start == 3.0 ? '50人以上' :
                          query.memberCount.start == 4.0 ? '100人以上' : ''
                        } ${
                            query.memberCount.end == 0.0 ? '1人以下' :
                            query.memberCount.end == 1.0 ? '10人以下' :
                            query.memberCount.end == 2.0 ? '30人以下' :
                            query.memberCount.end == 3.0 ? '50人以下' :
                            query.memberCount.end == 4.0 ? '100人以下' : ''
                        }',
                        textAlign: TextAlign.center,
                      ),
                      RangeSlider(
                        labels: RangeLabels(
                          query.memberCount.start == 0.0 ? '下限なし' :
                          query.memberCount.start == 1.0 ? '10人以上' :
                          query.memberCount.start == 2.0 ? '30人以上' :
                          query.memberCount.start == 3.0 ? '50人以上' :
                          query.memberCount.start == 4.0 ? '100人以上' : '制限なし',
                          query.memberCount.end == 0.0 ? '1人以下' :
                          query.memberCount.end == 1.0 ? '10人以下' :
                          query.memberCount.end == 2.0 ? '30人以下' :
                          query.memberCount.end == 3.0 ? '50人以下' :
                          query.memberCount.end == 4.0 ? '100人以下' : '上限なし',
                        ),
                        values: query.memberCount,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (values) {
                          query.memberCount = values;
                          update();
                        },
                      ),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(child: Text('下限なし'), flex: 1),
                              Expanded(child: Text('10人'), flex: 1),
                              Expanded(child: Text('30人'), flex: 1),
                              Expanded(child: Text('50人'), flex: 1),
                              Expanded(child: Text('100人'), flex: 1),
                              Expanded(child: Text('上限なし'), flex: 1),
                            ]
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildHeader(context, '男女比'),
                      const SizedBox(height: 8),
                      Text(
                        query.genderRatio == null ? '指定なし' : query.genderRatio.format,
                        textAlign: TextAlign.center
                      ),
                      _buildOnlyChoiceChips<GenderRatioChoice>(context,
                        items: GenderRatioChoice.values,
                        getLabel: (item) => item.format,
                        selected: query.genderRatio,
                        onSelected: (selected, item){
                          query.genderRatio = selected ? item : null;
                          update();
                        }
                      ),

                      const SizedBox(height: 16),

                      _buildHeader(context, '活動キャンパス'),
                      const SizedBox(height: 8),
                      Text(
                        query.campus == null ? '指定なし' : query.campus.format,
                        textAlign: TextAlign.center
                      ),
                      _buildOnlyChoiceChips<CampusChoice>(context,
                        items: CampusChoice.values,
                        getLabel: (item) => item.format,
                        selected: query.campus,
                        onSelected: (selected, item){
                          query.campus = selected ? item : null;
                          update();
                        }
                      ),
                      
                      const SizedBox(height: 16),

                      _buildHeader(context, '公認サークルのみ'),
                      _buildBoolChoiceChips(context, query.isOfficial, (v) => query.isOfficial = v, onUpdate: update),
                      const SizedBox(height: 16),
                      _buildHeader(context, 'インカレサークルを含む'),
                      _buildBoolChoiceChips(context, query.isIntercollege, (v) => query.isIntercollege = v, onUpdate: update),
                      const SizedBox(height: 16),

                      _buildHeader(context, '活動頻度'),
                      const SizedBox(height: 8),
                      Text('${
                          query.freq.start == 0.0 ? '' :
                          query.freq.start == 1.0 ? '月2以上' :
                          query.freq.start == 2.0 ? '週1以上' :
                          query.freq.start == 3.0 ? '週2以上' :
                          query.freq.start == 4.0 ? '週3以上' :
                          query.freq.start == 5.0 ? '週4以上' :
                          query.freq.start == 6.0 ? '週5以上' : '週6以上'
                        } ${
                          query.freq.end == 0.0 ? '月1以下' :
                          query.freq.end == 1.0 ? '月2以下' :
                          query.freq.end == 2.0 ? '週1以下' :
                          query.freq.end == 3.0 ? '週2以下' :
                          query.freq.end == 4.0 ? '週3以下' :
                          query.freq.end == 5.0 ? '週4以下' :
                          query.freq.end == 6.0 ? '週5以下' : ''
                        }',
                        textAlign: TextAlign.center,
                      ),
                      RangeSlider(
                        labels: RangeLabels(
                          query.freq.start == 0.0 ? '下限なし' :
                          query.freq.start == 1.0 ? '月2以上' :
                          query.freq.start == 2.0 ? '週1以上' :
                          query.freq.start == 3.0 ? '週2以上' :
                          query.freq.start == 4.0 ? '週3以上' :
                          query.freq.start == 5.0 ? '週4以上' :
                          query.freq.start == 6.0 ? '週5以上' : '週6以上',
                          query.freq.end == 0.0 ? '月1以下' :
                          query.freq.end == 1.0 ? '月2以下' :
                          query.freq.end == 2.0 ? '週1以下' :
                          query.freq.end == 3.0 ? '週2以下' :
                          query.freq.end == 4.0 ? '週3以下' :
                          query.freq.end == 5.0 ? '週4以下' :
                          query.freq.end == 6.0 ? '週5以下' : '上限なし',
                        ),
                        values: query.freq,
                        min: 0,
                        max: 7,
                        divisions: 7,
                        onChanged: (values) {
                          query.freq = values;
                          update();
                        },
                      ),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(child: Text('月1以下'), flex: 1),
                              Expanded(child: Text('月2'), flex: 1),
                              Expanded(child: Text('週1'), flex: 1),
                              Expanded(child: Text('週2'), flex: 1),
                              Expanded(child: Text('週3'), flex: 1),
                              Expanded(child: Text('週4'), flex: 1),
                              Expanded(child: Text('週5'), flex: 1),
                              Expanded(child: Text('週6以上'), flex: 1),
                            ]
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // _buildHeader(context, 'イベント頻度'),
                      // const SizedBox(height: 8),
                      // Text('${
                      //     query.freq.start == 0.0 ? '' :
                      //     query.freq.start == 1.0 ? '年2以上' :
                      //     query.freq.start == 2.0 ? '年3以上' :
                      //     query.freq.start == 3.0 ? '年4以上' :
                      //     query.freq.start == 4.0 ? '2ヶ月に1回' :
                      //     query.freq.start == 5.0 ? '月1以上' : '月2以上'
                      //   } ${
                      //     query.freq.end == 0.0 ? '年1以下' :
                      //     query.freq.end == 1.0 ? '年2以下' :
                      //     query.freq.end == 2.0 ? '年3以下' :
                      //     query.freq.end == 3.0 ? '年4以下' :
                      //     query.freq.end == 4.0 ? '2ヶ月に1回以下' :
                      //     query.freq.end == 5.0 ? '月1以下' : ''
                      //   }',
                      //   textAlign: TextAlign.center,
                      // ),
                      // RangeSlider(
                      //   labels: RangeLabels(
                      //     query.freq.start == 0.0 ? '下限なし' :
                      //     query.freq.start == 1.0 ? '年2以上' :
                      //     query.freq.start == 2.0 ? '年3以上' :
                      //     query.freq.start == 3.0 ? '年4以上' :
                      //     query.freq.start == 4.0 ? '2ヶ月に1回' :
                      //     query.freq.start == 5.0 ? '月1以上' : '月2以上',
                      //     query.freq.end == 0.0 ? '年1以下' :
                      //     query.freq.end == 1.0 ? '年2以下' :
                      //     query.freq.end == 2.0 ? '年3以下' :
                      //     query.freq.end == 3.0 ? '年4以下' :
                      //     query.freq.end == 4.0 ? '2ヶ月に1回以下' :
                      //     query.freq.end == 5.0 ? '月1以下' : '上限なし',
                      //   ),
                      //   values: query.freq,
                      //   min: 0,
                      //   max: 6,
                      //   divisions: 6,
                      //   onChanged: (values) {
                      //     query.freq = values;
                      //     update();
                      //   },
                      // ),
                      // DefaultTextStyle(
                      //   style: Theme.of(context).textTheme.caption,
                      //   textAlign: TextAlign.center,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: const [
                      //         Expanded(child: Text('月1以下'), flex: 1),
                      //         Expanded(child: Text('月2'), flex: 1),
                      //         Expanded(child: Text('週1'), flex: 1),
                      //         Expanded(child: Text('週2'), flex: 1),
                      //         Expanded(child: Text('週3'), flex: 1),
                      //         Expanded(child: Text('週4'), flex: 1),
                      //         Expanded(child: Text('週5'), flex: 1),
                      //         Expanded(child: Text('週6以上'), flex: 1),
                      //       ]
                      //     ),
                      //   ),
                      // ),
                    ],


                    // TODO: 他の検索項目を追加

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
    );
  }

  Widget _buildOnlyChoiceChips<T>(BuildContext context, {
    List<T> items,
    String Function(T) getLabel,
    T selected,
    void Function(bool, T) onSelected
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.map<Widget>((item) {
        return FilterChip(
          avatar: selected == item ? null : Icon(
            Icons.check,
            size: 20,
            color: Colors.grey[400],
          ),
          selectedColor: Colors.cyan,
          checkmarkColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          label: Text(
            getLabel(item),
            style: TextStyle(
              color: selected == null ? Colors.black : selected == item ? Colors.white : Colors.black
            ),
          ),
          selected: selected == item,
          onSelected: (selected) => onSelected(selected, item),
        );
      }).toList()
    );
  }

  Widget _buildMultiChoiceChips<T>(
    BuildContext context, {
    List<T> items,
    String Function(T) getLabel,
    bool Function(T) isSelected,
    void Function(bool, T) onSelected,
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.map((item) {
        return FilterChip(
          avatar: isSelected(item) ? null : Icon(
            Icons.check,
            size: 20,
            color: Colors.grey[400],
          ),
          checkmarkColor: Colors.white,
          selectedColor: Colors.cyan,
          label: Text(
            getLabel(item),
            style: TextStyle(
              color: isSelected(item) ? Colors.white : Colors.black
            ),
          ),
          selected: isSelected(item),
          onSelected: (selected) => onSelected(selected, item),
        );
      }
      ).toList(),
    );
  }


  Widget _buildBoolChoiceChips(BuildContext context, bool isSelected, void Function(bool) onSelected, { void Function() onUpdate }) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        FilterChip(
          avatar: (isSelected ?? false) ? null : Icon(
            Icons.check,
            size: 20,
            color: Colors.grey[400],
          ),
          checkmarkColor: Colors.white,
          selectedColor: Colors.cyan,
          label: Text(
            'Yes',
            style: TextStyle(
              color: isSelected == null ? Colors.black : isSelected ? Colors.white : Colors.black
            ),
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          selected: isSelected ?? false,
          onSelected: (v){
            onSelected(v ? true : null);
            onUpdate();
          },
        ),
      ]
    );
  }

  Widget _buildHeader(BuildContext context, String header) {
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