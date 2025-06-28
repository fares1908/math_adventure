// import 'package:flutter/material.dart';
//
// class AbacusScreen extends StatefulWidget {
//   const AbacusScreen({super.key});
//
//   @override
//   _AbacusScreenState createState() => _AbacusScreenState();
// }
//
// class _AbacusScreenState extends State<AbacusScreen> {
//   String input = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Spacer(),
//             Text(
//               input.isEmpty ? "0" : input,
//               style: const TextStyle(color: Colors.white, fontSize: 48),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: input
//                   .padLeft(5, '0')
//                   .split('')
//                   .map((digit) => AbacusColumn(activeCount: int.parse(digit)))
//                   .toList(),
//             ),
//             const Spacer(),
//             SizedBox(
//               height: 300,
//               child: AbacusKeypad(
//                 onValueChanged: (val) {
//                   setState(() => input = val);
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Bead visual unit
// class AbacusBead extends StatelessWidget {
//   final bool isActive;
//
//   const AbacusBead({super.key, required this.isActive});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         color: isActive ? Colors.orange : Colors.grey[300],
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
//
// /// Single column in abacus with beads
// class AbacusColumn extends StatelessWidget {
//   final int activeCount;
//   final int maxBeads;
//
//   const AbacusColumn({super.key, required this.activeCount, this.maxBeads = 5});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(maxBeads, (index) {
//         return AbacusBead(isActive: index < activeCount);
//       }),
//     );
//   }
// }
//
// /// Keypad widget
// class AbacusKeypad extends StatefulWidget {
//   final double fontSize;
//   final Color backgroundColor;
//   final void Function(String) onValueChanged;
//
//   const AbacusKeypad({
//     super.key,
//     this.fontSize = 35.0,
//     this.backgroundColor = Colors.black87,
//     required this.onValueChanged,
//   });
//
//   @override
//   State<AbacusKeypad> createState() => _AbacusKeypadState();
// }
//
// class _AbacusKeypadState extends State<AbacusKeypad> {
//   String recordNumber = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: widget.backgroundColor,
//       child: Column(
//         children: [
//           buildRow(["1", "2", "3"]),
//           buildRow(["4", "5", "6"]),
//           buildRow(["7", "8", "9"]),
//           buildRow(["Clear", "0", "back"]),
//         ],
//       ),
//     );
//   }
//
//   Widget buildRow(List<String> items) {
//     return Expanded(
//       child: Row(
//         children: items
//             .map((item) => Expanded(child: getNumberButton(item)))
//             .toList(),
//       ),
//     );
//   }
//
//   MaterialButton getNumberButton(String title) {
//     return MaterialButton(
//       onPressed: () {
//         setState(() {
//           switch (title) {
//             case "Clear":
//               recordNumber = "";
//               break;
//             case "back":
//               if (recordNumber.isNotEmpty) {
//                 recordNumber =
//                     recordNumber.substring(0, recordNumber.length - 1);
//               }
//               break;
//             default:
//               if (recordNumber.length < 5) {
//                 recordNumber += title;
//               }
//           }
//           widget.onValueChanged(recordNumber);
//         });
//       },
//       child: title == "back"
//           ? const Icon(Icons.backspace, color: Colors.white)
//           : Text(title,
//               style: TextStyle(color: Colors.white, fontSize: widget.fontSize)),
//     );
//   }
// }
