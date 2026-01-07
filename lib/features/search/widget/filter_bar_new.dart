// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';

// class YachtFilterBar extends StatefulWidget {
//   final List<String> models;
//   final List<String> classes;
//   final Function(String?) onModelChanged;
//   final Function(String?) onClassChanged;
//   final Function(String) onYearChanged;
//   final Function(String) onPriceChanged;

//   const YachtFilterBar({
//     super.key,
//     required this.models,
//     required this.classes,
//     required this.onModelChanged,
//     required this.onClassChanged,
//     required this.onYearChanged,
//     required this.onPriceChanged,
//   });

//   @override
//   State<YachtFilterBar> createState() => _YachtFilterBarState();
// }

// class _YachtFilterBarState extends State<YachtFilterBar> {
//   late TextEditingController yearController;
//   late TextEditingController priceController;
//   String? selectedModel;
//   String? selectedClass;

//   @override
//   void initState() {
//     super.initState();
//     yearController = TextEditingController();
//     priceController = TextEditingController();
//   }

//   @override
//   void didUpdateWidget(YachtFilterBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.models != widget.models ||
//         oldWidget.classes != widget.classes) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     yearController.dispose();
//     priceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(
//       'FilterBar build: models=${widget.models.length}, classes=${widget.classes.length}',
//     );
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             spreadRadius: 1,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // Model Dropdown
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Model",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: DropdownButton<String>(
//                         isExpanded: true,
//                         underline: const SizedBox.shrink(),
//                         value: selectedModel,
//                         hint: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text(
//                             "Select Model",
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         onChanged: widget.models.isEmpty
//                             ? null
//                             : (String? newValue) {
//                                 print('Model changed: $newValue');
//                                 setState(() => selectedModel = newValue);
//                                 widget.onModelChanged(newValue);
//                               },
//                         items: widget.models.map<DropdownMenuItem<String>>((
//                           String value,
//                         ) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text(
//                                 value,
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 10),
//               // Boat Type Dropdown
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Boat Type",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: DropdownButton<String>(
//                         isExpanded: true,
//                         underline: const SizedBox.shrink(),
//                         value: selectedClass,
//                         hint: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text(
//                             "Select Type",
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         onChanged: widget.classes.isEmpty
//                             ? null
//                             : (String? newValue) {
//                                 print('Class changed: $newValue');
//                                 setState(() => selectedClass = newValue);
//                                 widget.onClassChanged(newValue);
//                               },
//                         items: widget.classes.map<DropdownMenuItem<String>>((
//                           String value,
//                         ) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text(
//                                 value,
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Year",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextField(
//                       controller: yearController,
//                       keyboardType: TextInputType.number,
//                       onChanged: widget.onYearChanged,
//                       decoration: InputDecoration(
//                         hintText: "e.g., 2008",
//                         hintStyle: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Max Price",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextField(
//                       controller: priceController,
//                       keyboardType: TextInputType.number,
//                       onChanged: widget.onPriceChanged,
//                       decoration: InputDecoration(
//                         hintText: "e.g., 500000",
//                         hintStyle: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
