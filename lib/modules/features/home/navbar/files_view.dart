// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:textomize/core/exports.dart';

// class FilesView extends StatefulWidget {
//   const FilesView({super.key});

//   @override
//   State<FilesView> createState() => _FilesViewState();
// }

// class _FilesViewState extends State<FilesView> {
//   final List<String> files = [
//     'File 1.txt',
//     'File 2.pdf',
//     'File 3.docx',
//     'File 4.jpg',
//   ];

//   bool isLoading = true; 

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
     
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
      
//             Expanded(
//               child: isLoading
//                   ? ListView.builder(
//                       itemCount: 6, 
//                       itemBuilder: (context, index) {
//                         return const ShimmerPlaceholder();
//                       },
//                     )
//                   : files.isEmpty
//                       ? const Center(
//                           child: Text(
//                             'No files found.',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: files.length,
//                           itemBuilder: (context, index) {
//                             return FileCard(
//                               fileName: files[index],
//                               fileType: _getFileType(files[index]),
//                               onTap: () {
//                                 // Navigate to file details or open file
//                               },
//                               onMoreTap: () {
//                                 // Add file-specific actions here
//                               },
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _getFileType(String fileName) {
//     if (fileName.endsWith('.pdf')) {
//       return 'PDF Document';
//     } else if (fileName.endsWith('.docx') || fileName.endsWith('.txt')) {
//       return 'Text Document';
//     } else if (fileName.endsWith('.jpg') || fileName.endsWith('.png')) {
//       return 'Image File';
//     } else {
//       return 'Unknown File';
//     }
//   }
// }



// // File Card Widget with Appealing Design
// class FileCard extends StatelessWidget {
//   final String fileName;
//   final String fileType;
//   final VoidCallback onTap;
//   final VoidCallback onMoreTap;

//   const FileCard({
//     super.key,
//     required this.fileName,
//     required this.fileType,
//     required this.onTap,
//     required this.onMoreTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.blueAccent.withOpacity(0.2),
//           child: Icon(
//             _getFileIcon(fileName),
//             color: Colors.blueAccent,
//           ),
//         ),
//         title: Text(
//           fileName,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           fileType,
//           style: const TextStyle(color: Colors.grey),
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.more_vert),
//           onPressed: onMoreTap,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }

//   IconData _getFileIcon(String fileName) {
//     if (fileName.endsWith('.pdf')) {
//       return Icons.picture_as_pdf;
//     } else if (fileName.endsWith('.docx') || fileName.endsWith('.txt')) {
//       return Icons.description;
//     } else if (fileName.endsWith('.jpg') || fileName.endsWith('.png')) {
//       return Icons.image;
//     } else {
//       return Icons.insert_drive_file;
//     }
//   }
// }

// // Shimmer Placeholder for Loading
// class ShimmerPlaceholder extends StatelessWidget {
//   const ShimmerPlaceholder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 16,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: 100,
//                     height: 12,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
