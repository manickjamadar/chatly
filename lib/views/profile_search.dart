import 'package:flutter/material.dart';

List<TextSpan> getQueryTextSpans(String text, String query) {
  final TextStyle matchedStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  final TextSpan matchedTextSpan = TextSpan(text: query, style: matchedStyle);
  if (query.isEmpty) return [TextSpan(text: text)];
  final splittedTexts = text.split(query);
  print(splittedTexts);
  if (splittedTexts[0].compareTo(text) == 0) return [TextSpan(text: text)];
  if (splittedTexts.length == 2) {
    return [
      TextSpan(text: splittedTexts[0]),
      matchedTextSpan,
      TextSpan(text: splittedTexts[1]),
    ];
  } else {
    final nonMatchedText = splittedTexts[0];
    if (text.startsWith(query)) {
      return [matchedTextSpan, TextSpan(text: nonMatchedText)];
    } else {
      return [TextSpan(text: nonMatchedText), matchedTextSpan];
    }
  }
}

final List<String> names = [
  "Manick",
  "nasrin",
  "nasim",
  "wasim",
  "rajid",
  "israil",
  "adil",
  "shuvadip"
];

class ProfileSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(title: TextStyle(color: Colors.white)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? names
        : names.where((name) => RegExp(query).hasMatch(name)).toList();
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
            leading: Icon(Icons.person),
            title: RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  children: getQueryTextSpans(suggestionList[index], query)),
            ));
      },
      itemCount: suggestionList.length,
    );
  }
}
