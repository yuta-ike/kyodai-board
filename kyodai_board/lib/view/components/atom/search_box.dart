import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class SuggestionType{
  const SuggestionType(this.displayName, this.itemKey);
  final String displayName, itemKey;
}

const List<SuggestionType> suggestions = [
  SuggestionType('野球', '野球'),
  SuggestionType('やきゅう', '野球'),
  SuggestionType('baseball', '野球'),
  SuggestionType('バスケットボール', 'バスケットボール'),
  SuggestionType('basketball', 'バスケットボール'),
  SuggestionType('apple', 'バスケットボール'),
  SuggestionType('apple2', 'バスケットボール'),
];

class SearchBox extends StatelessWidget{
  SearchBox({
    @required this.hintText,
    this.autofocus = false,
  });

  final String hintText;
  final bool autofocus;

  final GlobalKey<AutoCompleteTextFieldState<SuggestionType>> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AutoCompleteTextField<SuggestionType>(
      key: _key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => Padding(
          child: ListTile(
            title: Text(suggestion.displayName),
            // trailing: new Text("Stars: ${suggestion.stars}")
          ),
          padding: const EdgeInsets.all(8)),
      itemSorter: (a, b) => 1,//a.displayName == b.displayName ? 0 : a.displayName > b.displayName ? -1 : 1,
      itemFilter: (suggestion, input) =>
          suggestion.displayName.toLowerCase().startsWith(input.toLowerCase()),
      itemSubmitted: (_) => print('SUBMITE'),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: InputBorder.none,
        fillColor: Colors.blueGrey[50],
        filled: true,
        hintText: hintText,
      ),
    );
  }
  
}