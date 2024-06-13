import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapinnotech_application/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> config = {};
  String selectedRateOfInterest = '1';
  String selectedTimesCompound = '1';
  String selectedYears = '1';
  TextEditingController principalController = TextEditingController();
  String configJson = '''{
    "rate_of_interest": {
      "text_color": "0xFF000000",
      "text_size": 16,
      "label_text": "Rate of Interest",
      "values": {
        "1": "1%",
        "2": "2%",
        "3": "3%",
        "4": "4%",
        "5": "5%",
        "6": "6%",
        "7": "7%",
        "8": "8%",
        "9": "9%",
        "10": "10%",
        "11": "11%",
        "12": "12%",
        "13": "13%",
        "14": "14%",
        "15": "15%"
      }
    },
    "principal_amount": {
      "hint_text": "Enter Principal Amount",
      "text_color": "0xFF000000",
      "text_size": 16,
      "min_amount": {
        "1": 10000,
        "2": 10000,
        "3": 10000,
        "4": 50000,
        "5": 50000,
        "6": 50000,
        "7": 50000,
        "8": 75000,
        "9": 75000,
        "10": 75000,
        "11": 75000,
        "12": 100000,
        "13": 100000,
        "14": 100000,
        "15": 100000
      },
      "max_amount": 10000000,
      "error_message": {
        "min": "Principal amount should be at least ",
        "max": "Principal amount should not exceed 1 crore"
      }
    },
    "times_compound_per_year": {
      "label_text": "Times Compounded Per Year",
      "text_color": "0xFF000000",
      "text_size": 16,
      "values": {
        "1": "Annually",
        "2": "Semi-Annually",
        "4": "Quarterly"
      },
      "conditions": {
        "1": {
          "rate_of_interest": [12]
        },
        "2": {
          "rate_of_interest": [6]
        },
        "4": {
          "rate_of_interest": [3]
        }
      }
    },
    "years": {
      "label_text": "Number of Years",
      "text_color": "0xFF000000",
      "text_size": 16,
      "conditions": {
        "1": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "2": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
        "4": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
      }
    },
    "output": {
      "text_color": "0xFF000000",
      "label_text": "Calculated Amount",
      "text_size": 18,
      "display_mode": "pop-up"
    }
  }''';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          buildDropdownField('rate_of_interest'),
          const SizedBox(height: 16.0),
          buildPrincipalField(),
          const SizedBox(height: 16.0),
          buildDropdownField('times_compound_per_year'),
          const SizedBox(height: 16.0),
          buildDropdownField('years'),
          const SizedBox(height: 16.0),
          UtilsWidget.buildRoundBtn('Calculate', () {
            _calculateAndShowResult();
          })
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _calculateAndShowResult,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  loadData() async {
    // var data = await rootBundle.loadString("assets/json/api.json");
    // setState(() {
    //   config = json.decode(data);
    // });
    config = jsonDecode(configJson) as Map<String, dynamic>;
    principalController.addListener(_validatePrincipalAmount);
  }

  void _validatePrincipalAmount() {
    final rate = int.parse(selectedRateOfInterest);
    final principal = int.tryParse(principalController.text) ?? 0;
    final minAmount = config['principal_amount']['min_amount'][rate.toString()];
    final maxAmount = config['principal_amount']['max_amount'];

    if (principal < minAmount || principal > maxAmount) {
      String errorMessage = principal < minAmount
          ? config['principal_amount']['error_message']['min'] +
              minAmount.toString()
          : config['principal_amount']['error_message']['max'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _calculateAndShowResult() {
    final principal = double.parse(principalController.text);
    final rate = double.parse(selectedRateOfInterest) / 100;
    final times = int.parse(selectedTimesCompound);
    final years = int.parse(selectedYears);

    final amount = principal * pow((1 + rate / times), (times * years));
    final displayMode = config['output']['display_mode'];

    String resultMessage =
        'The calculated amount is \₹${amount.toStringAsFixed(2)}';

    if (displayMode == 'snack-bar') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resultMessage)));
    } else if (displayMode == 'pop-up') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(resultMessage),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        ),
      );
    } else {
      setState(() {});
    }
  }

  buildDropdownField(String key) {
    Map<String, dynamic> fieldConfig = config[key];
    Map<String, dynamic> values = {};
    List tempvalue = [];
    if (key == 'years') {
      tempvalue = fieldConfig['conditions'][selectedTimesCompound];
    } else {
      values = fieldConfig['values'];
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          label: Text(
            "${fieldConfig['label_text']}",
            style: TextStyle(
                color: Color(int.parse(fieldConfig['text_color'])),
                fontSize: fieldConfig['text_size'].toDouble()),
          )),
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      value: key == 'rate_of_interest'
          ? selectedRateOfInterest
          : key == 'times_compound_per_year'
              ? selectedTimesCompound
              : selectedYears,
      items: key == 'years'
          ? tempvalue.map((element) {
              return DropdownMenuItem<String>(
                value: element.toString(),
                child: Text(element.toString()),
              );
            }).toList()
          : values.entries
              .map((entry) => DropdownMenuItem<String>(
                    value: entry.key.toString(),
                    child: Text(entry.value.toString()),
                  ))
              .toList(),
      onChanged: (newValue) {
        setState(() {
          if (key == 'rate_of_interest') {
            selectedRateOfInterest = newValue!;
          } else if (key == 'times_compound_per_year') {
            selectedTimesCompound = newValue!;
          } else {
            selectedYears = newValue!;
          }
        });
      },
    );
  }

  buildPrincipalField() {
    Map<String, dynamic> fieldConfig = config['principal_amount'];

    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
          color: Color(int.parse(fieldConfig['text_color'])),
          fontWeight: FontWeight.w400,
          fontSize: fieldConfig['text_size'].toDouble(),
          letterSpacing: 1),
      controller: principalController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.black, width: 0.0),
        ),
        // contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintText: fieldConfig['hint_text'].toString(),
      ),
    );
  }
}
