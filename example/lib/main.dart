import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(body: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10.0,
        children: [
          SizedBox(height: 10.0),
          Center(
            child: GroupDropdownButton(
              // borderType: TextFieldInputBorder.underLine,
              errorText: "<errorText comes here>",
              isRequired: true,
              // eachGroupIsExpansion: true,
              // enabledRadioForItems: true,
              // itemPrefix: Icon(Icons.arrow_forward),
              showCheckForSelected: true,
              items: [
                GroupedDropdownOption(
                  key: "one",
                  title: "One",
                  subItems: [
                    GroupedDropdownOption(key: "one-1", title: "One-1"),
                    GroupedDropdownOption(key: "one-2", title: "One-2"),
                    GroupedDropdownOption(key: "one-3", title: "One-3"),
                  ],
                ),
                GroupedDropdownOption(
                  key: "two",
                  title: "Two",
                  subItems: [
                    GroupedDropdownOption(key: "two-1", title: "Two-1"),
                    GroupedDropdownOption(key: "two-2", title: "Two-2"),
                    GroupedDropdownOption(key: "two-3", title: "Two-3"),
                  ],
                ),
              ],
              labelText: "<this is label>",
              hintText: "<this is hint>",
              onSelect: (value) {},
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState!.validate();
            },
            child: Text("Press"),
          ),
        ],
      ),
    );
  }
}
