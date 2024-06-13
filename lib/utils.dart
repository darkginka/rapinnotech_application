import 'package:flutter/material.dart';

class UtilsWidget {
  static buildRoundBtn(String? btnsend, Function()? onPressed) {
    return SizedBox(
      height: 50,
      width: 190,
      child: ElevatedButton(
          child: Text(
            "$btnsend",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.purple),
            ),
          ),
          onPressed: onPressed),
    );
  }

//   static buildDropdownField(String key) {
//     Map<String, dynamic> fieldConfig = config[key];
//     Map<String, dynamic> values = fieldConfig['values'];

//     return DropdownButtonFormField(
//       decoration: InputDecoration(
//           isDense: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           label: Text(
//             "${fieldConfig['label_text']}",
//             style: TextStyle(
//                 color: Color(int.parse(fieldConfig['text_color'])),
//                 fontSize: fieldConfig['text_size'].toDouble()),
//           )),
//       isExpanded: true,
//       icon: const Icon(
//         Icons.arrow_drop_down,
//         color: Colors.black45,
//       ),
//       iconSize: 30,
//       value: key == 'rate_of_interest'
//           ? selectedRateOfInterest
//           : key == 'times_compound_per_year'
//               ? selectedTimesCompound
//               : selectedYears,
//       items: values.entries
//           .map((entry) => DropdownMenuItem<String>(
//                 value: entry.key.toString(),
//                 child: Text(entry.value.toString()),
//               ))
//           .toList(),
//       onChanged: (newValue) {
//         setState(() {
//           if (key == 'rate_of_interest') {
//             selectedRateOfInterest = newValue!;
//           } else if (key == 'times_compound_per_year') {
//             selectedTimesCompound = newValue!;
//           } else {
//             selectedYears = newValue!;
//           }
//         });
//       },
//     );
//   }

//   static buildPrincipalField() {
//     Map<String, dynamic> fieldConfig = config['principal_amount'];

//     return TextFormField(
//       style: TextStyle(
//           color: Color(int.parse(fieldConfig['text_color'])),
//           fontWeight: FontWeight.w400,
//           fontSize: fieldConfig['text_size'].toDouble(),
//           letterSpacing: 1),
//       controller: principalController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: BorderSide(color: Colors.black, width: 0.0),
//         ),
//         // contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//         ),
//         hintText: fieldConfig['hint_text'].toString(),
//       ),
//     );
//   }
}
