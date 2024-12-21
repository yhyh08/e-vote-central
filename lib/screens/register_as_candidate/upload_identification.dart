// import 'package:flutter/material.dart';

// class IDVerificationScreen extends StatefulWidget {
//   const IDVerificationScreen({super.key});

//   @override
//   State<IDVerificationScreen> createState() => _IDVerificationScreenState();
// }

// class _IDVerificationScreenState extends State<IDVerificationScreen> {
//   String? frontImagePath;
//   String? backImagePath;

//   void pickFrontImage() {
//     // Simulate picking the front image
//     setState(() {
//       frontImagePath = 'Front ID selected';
//     });
//   }

//   void pickBackImage() {
//     // Simulate picking the back image
//     setState(() {
//       backImagePath = 'Back ID selected';
//     });
//   }

//   void uploadFiles() {
//     if (frontImagePath != null && backImagePath != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Files uploaded successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload both images')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.purple, // Match the theme color
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Title
//             const Text(
//               'ID Verification',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             // Subtitle
//             const Text(
//               'Upload your ID card for verification',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),

//             // Drop area for front image
//             GestureDetector(
//               onTap: pickFrontImage,
//               child: Container(
//                 height: 150,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey, dashPattern: [6, 3]),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.credit_card, size: 40, color: Colors.grey),
//                     const SizedBox(height: 8),
//                     Text(
//                       frontImagePath ?? 'Drop front here',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Drop area for back image
//             GestureDetector(
//               onTap: pickBackImage,
//               child: Container(
//                 height: 150,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey, dashPattern: [6, 3]),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.credit_card_outlined, size: 40, color: Colors.grey),
//                     const SizedBox(height: 8),
//                     Text(
//                       backImagePath ?? 'Drop back here',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Supported format text
//             const Text(
//               'Supported format: PNG, JPG',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const Spacer(),

//             // Upload button
//             ElevatedButton(
//               onPressed: uploadFiles,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Upload',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:image_picker/image_picker.dart';

// void pickFrontImage() async {
//   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     setState(() {
//       frontImagePath = pickedFile.path;
//     });
//   }
// }
