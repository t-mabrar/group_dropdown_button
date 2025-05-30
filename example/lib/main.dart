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
  String selectedContent = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: [
            Text(
              "Group Dropdown Button",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 20.0),
            // if (selectedContent.isNotEmpty) ...[
            //   Text(selectedContent),
            //   SizedBox(height: 10.0),
            // ],
            GroupDropdownButton(
              textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              initialValue: DropdownButtonItem(
                key: "one-1-1",
                title: "One-1-1",
              ),
              // borderType: TextFieldInputBorder.underLine,
              // eachGroupIsExpansion: true,
              // enabledRadioForItems: true,
              // showDividerBtwGroups: true,
              // itemPrefix: Icon(Icons.adb_sharp),
              // errorText: "<errorText comes here>",
              isRequired: true,
              showCheckForSelected: true,
              // checkWidgetForSelectedItem: Icon(Icons.abc),
              items: [
                DropdownButtonItem(
                  key: "one",
                  title: "One",
                  subItems: [
                    DropdownButtonItem(
                      key: "one-1",
                      title: "One-1",
                      subItems: [
                        DropdownButtonItem(key: "one-1-1", title: "One-1-1"),
                        DropdownButtonItem(key: "one-1-2", title: "One-1-2"),
                        DropdownButtonItem(key: "one-1-3", title: "One-1-3"),
                      ],
                    ),
                    DropdownButtonItem(
                      key: "one-2",
                      title: "One-2",
                      subItems: [
                        DropdownButtonItem(key: "one-2-1", title: "One-2-1"),
                        DropdownButtonItem(key: "one-2-2", title: "One-2-2"),
                        DropdownButtonItem(key: "one-2-3", title: "One-2-3"),
                      ],
                    ),
                    DropdownButtonItem(
                      key: "one-3",
                      title: "One-3",
                      subItems: [
                        DropdownButtonItem(key: "one-3-1", title: "One-3-1"),
                        DropdownButtonItem(key: "one-3-2", title: "One-3-2"),
                        DropdownButtonItem(key: "one-3-3", title: "One-3-3"),
                      ],
                    ),
                  ],
                ),
                DropdownButtonItem(
                  key: "two",
                  title: "Two",
                  subItems: [
                    DropdownButtonItem(key: "two-1", title: "Two-1"),
                    DropdownButtonItem(key: "two-2", title: "Two-2"),
                    DropdownButtonItem(key: "two-3", title: "Two-3"),
                  ],
                ),
                DropdownButtonItem(key: "three", title: "Three"),
                DropdownButtonItem(key: "four", title: "Four"),
              ],
              labelText: "<this is label>",
              hintText: "<this is hint>",
              onSelect: (value) {
                if (value != null) {
                  selectedContent = value.toJson().toString();
                } else {
                  selectedContent = "";
                }
                setState(() {});
              },
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: Text("Press"),
            ),
          ],
        ),
      ),
    );
  }
}
