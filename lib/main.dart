import 'dart:convert';

import 'package:dynamic_form/DateTimePicker_Demo.dart';
import 'package:dynamic_form/helper/DateTimePicker.dart';
import 'package:flutter/material.dart';
//import 'package:dynamic_form/helper/json_schema.dart';
import 'package:dynamic_form/helper/json_to_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  dynamic response;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DynamicForm',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Dynamic Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);


  String form_send_email = json.encode([
    {'type': 'Input', 'title': 'Subject', 'placeholder': "Subject"},
    {'type': 'TareaText', 'title': 'Message', 'placeholder': "Content"},
    {'type': 'Input', 'title': 'Hi Group', 'placeholder': "Hi Group flutter"},
    {
      'type': 'Password',
      'title': 'Password',
    },
    {'type': 'Email', 'title': 'Email test', 'placeholder': "hola a todos"},
    {
      'type': 'TareaText',
      'title': 'TareaText test',
      'placeholder': "hola a todos"
    },
    {'type': 'InputNumeric', 'title': 'Numeric only', 'placeholder': "Num",'validator':'digitsOnly'},
    {
      'type': 'RadioButton',
      'title': 'Radio Button tests',
      'value': 2,
      'list': [
        {
          'title': "product 1",
          'value': 1,
        },
        {
          'title': "product 2",
          'value': 2,
        },
        {
          'title': "product 3",
          'value': 3,
        }
      ],
    },
    {
      'type': 'Switch',
      'title': 'Switch test',
      'switchValue': false,
    },
    {
      'type': 'Checkbox',
      'title': 'Checkbox test 2',
      'list': [
        {
          'title': "product 1",
          'value': true,
        },
        {
          'title': "product 2",
          'value': true,
        },
        {
          'title': "product 3",
          'value': false,
        }
      ]
    },
    {
      'type': 'DropDownButton',
      'title': 'DropDownButton tests',
      'value': "2",
      'list': [
        {
          'titleitem': "product 1",
          'valueitem': 1,
        },
        {
          'titleitem': "product 2",
          'valueitem': 2,
        },
        {
          'titleitem': "product 3",
          'valueitem': 3,
        }
      ]
    },
    {
      'type': "DateTime",
      'title': "Date Time",
      'fromDate': DateTime.now().toIso8601String(),
      'fromTime': DateTime.now().toIso8601String(),     
    },
     {
      'type': "Date",
      'title': "Date",
      'fromDate': DateTime.now().toIso8601String(),
    },
  ]);

  dynamic response;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SafeArea(
        child: new SingleChildScrollView(
          child: new Column(children: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DateAndTimePickerDemo())),
              child: Text('Date Time Picker Demo'),
              color: Colors.lightGreen,
            ),

            new DateTimePicker(
              labelText: 'Tanggal',
              selectedDate: _fromDate,
              selectedTime: _fromTime,
              selectDate: (DateTime date) {
                setState(() {
                  _fromDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _fromTime = time;
                });
              },
            ),

            new CoreForm(
              form: form_send_email,
              onChanged: (dynamic response) {
                this.response = response;
              },
            ),
             
new RaisedButton(
                child: new Text('Init'),
                onPressed: () {
                  print(this.form_send_email.toString());
                }),
            new RaisedButton(
                child: new Text('Send'),
                onPressed: () {
                  print(this.response.toString());
                })
          ]),
        ),
      ),
    );
  }
}
