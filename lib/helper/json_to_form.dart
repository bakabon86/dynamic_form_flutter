// library json_to_form;

import 'dart:convert';
import 'package:dynamic_form/helper/DatePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:dynamic_form/helper/DateTimePicker.dart';

class CoreForm extends StatefulWidget {
  final String form;
  final dynamic formMap;
  final EdgeInsets padding;
  final String labelText;
  final ValueChanged<dynamic> onChanged;
  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder errorBorder;
  final OutlineInputBorder disabledBorder;
  final OutlineInputBorder focusedErrorBorder;
  final OutlineInputBorder focusedBorder;

  const CoreForm({
    @required this.form,
    @required this.onChanged,
    this.labelText,
    this.padding,
    this.formMap,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.focusedBorder,
    this.disabledBorder,
  });

  @override
  _CoreFormState createState() =>
      new _CoreFormState(formMap ?? json.decode(form));
}

class _CoreFormState extends State<CoreForm> {
  final dynamic formItems;

  int radioValue;

  List<Widget> jsonToForm() {
    List<Widget> listWidget = new List<Widget>();

    for (var item in formItems) {
      if (item['type'] == "Input" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TareaText") {
        listWidget.add(new Container(
            padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(
              item['title'],
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )));
        listWidget.add(new TextField(
          controller: null,
          inputFormatters: item['validator'] != null && item['validator'] != ''
              ? [
                  item['validator'] == 'digitsOnly'
                      ? WhitelistingTextInputFormatter(RegExp('[0-9]'))
                      : null,
                  item['validator'] == 'textOnly'
                      ? WhitelistingTextInputFormatter(RegExp('[a-zA-Z]'))
                      : null,
                ]
              : null,
          decoration: new InputDecoration(
            labelText: widget.labelText,
            enabledBorder: widget.enabledBorder ?? null,
            errorBorder: widget.errorBorder ?? null,
            focusedErrorBorder: widget.focusedErrorBorder ?? null,
            focusedBorder: widget.focusedBorder ?? null,
            disabledBorder: widget.disabledBorder ?? null,
            hintText: item['placeholder'] ?? "",
          ),
          maxLines: item['type'] == "TareaText" ? 10 : 1,
          onChanged: (String value) {
            item['response'] = value;
            _handleChanged();
          },
          obscureText: item['type'] == "Password" ? true : false,
        ));
      }

      if (item['type'] == "InputNumeric") {
        listWidget.add(new Container(
            padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(
              item['title'],
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )));
        listWidget.add(new TextField(
          controller: null,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          decoration: new InputDecoration(
            labelText: widget.labelText,
            enabledBorder: widget.enabledBorder ?? null,
            errorBorder: widget.errorBorder ?? null,
            focusedErrorBorder: widget.focusedErrorBorder ?? null,
            focusedBorder: widget.focusedBorder ?? null,
            disabledBorder: widget.disabledBorder ?? null,
            hintText: item['placeholder'] ?? "",
          ),
           onChanged: (String value) {
            item['response'] = value;
            _handleChanged();
          },
        ));
      }

      if (item['type'] == "RadioButton") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        radioValue = item['value'];
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['list'][i]['title'])),
                new Radio<int>(
                    value: item['list'][i]['value'],
                    groupValue: radioValue,
                    onChanged: (int value) {
                      this.setState(() {
                        radioValue = value;
                        item['value'] = value;
                        _handleChanged();
                      });
                    })
              ],
            ),
          );
        }
      }

      if (item['type'] == "Switch") {
        listWidget.add(
          new Row(children: <Widget>[
            new Expanded(child: new Text(item['title'])),
            new Switch(
                value: item['switchValue'],
                onChanged: (bool value) {
                  this.setState(() {
                    item['switchValue'] = value;
                    _handleChanged();
                  });
                })
          ]),
        );
      }

      if (item['type'] == "Checkbox") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['list'][i]['title'])),
                new Checkbox(
                    value: item['list'][i]['value'],
                    onChanged: (bool value) {
                      this.setState(() {
                        item['list'][i]['value'] = value;
                        _handleChanged();
                      });
                    })
              ],
            ),
          );
        }
      }

      //Rudi,20200309 DropDown

      if (item['type'] == "DropDownButton") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        listWidget.add(
          new Row(
            children: <Widget>[
              new DropdownButton<String>(
                  items: item['list']
                      .map<DropdownMenuItem<String>>((dropdownItem) {
                    return DropdownMenuItem<String>(
                      value: dropdownItem['valueitem'].toString(),
                      child: Text(dropdownItem['titleitem']),
                    );
                  }).toList(),
                  value: item['value'],
                  onChanged: (String newValue) {
                    this.setState(() {
                      item['value'] = newValue;
                      _handleChanged();
                    });
                  })
            ],
          ),
        );
      }
    //end Rudi,20200309
    //Date Time Picker, Rudi 20200311
      if (item['type'] == "DateTime") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));

        listWidget.add(
          new Row(children: <Widget>[
            new Expanded(
              child: new DateTimePicker(
                labelText: item['title'],
                selectedDate: DateTime.parse(item['fromDate']),
                selectedTime:
                    TimeOfDay.fromDateTime(DateTime.parse(item['fromTime'])),
                selectDate: (DateTime date) {
                  setState(() {
                    item['fromDate'] = date.toIso8601String();
                    _handleChanged();
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    //item['fromTime'] = time.toString();
                    // item['fromTime'] = DateTime(dateNow.year, dateNow.month,
                    //         dateNow.day, time.hour, time.minute)
                    //     .toIso8601String();
                      item['fromTime'] = DateTime(DateTime.parse(item['fromDate']).year, DateTime.parse(item['fromDate']).month,
                            DateTime.parse(item['fromDate']).day, time.hour, time.minute)
                        .toIso8601String();
                    _handleChanged();
                  });
                },
              ),
            ),
          ]),
        );
      }
    //end Date Time Picker, RUdi 20200311
    //Date Picker, Rudi 20200312
      if (item['type'] == "Date") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));

        listWidget.add(
          new Row(children: <Widget>[
            new Expanded(
              child: new DatePicker(
                labelText: item['title'],
                selectedDate: DateTime.parse(item['fromDate']),              
                selectDate: (DateTime date) {
                  setState(() {
                    item['fromDate'] = date.toIso8601String();
                    _handleChanged();
                  });
                },               
              ),
            ),
          ]),
        );
      }
    //end Date Picker, Rudi 20200312

      
    }
    return listWidget;
  }

  _CoreFormState(this.formItems);

  void _handleChanged() {
    widget.onChanged(formItems);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: widget.padding ?? EdgeInsets.all(8),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: jsonToForm(),
      ),
    );
  }
}
