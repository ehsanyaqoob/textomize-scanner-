// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:textomize/core/exports.dart';
// import 'package:textomize/modules/features/home/navbar/doc.dart';
//
// class MyDocView extends StatelessWidget {
//   MyDocView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverAppBar(
//               expandedHeight: 120.h,
//               flexibleSpace: FlexibleSpaceBar(
//                 titlePadding:  EdgeInsets.only(left: 16, bottom: 16),
//                 title: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "My Documents",
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     Text(
//                       "Recently accessed files",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pinned: true,
//               elevation: 0,
//               backgroundColor: Colors.transparent,
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: DocumentDisplaySection(
//                   title: 'Recent PDFs',
//                   fileExtensions: const ['pdf'],
//                   filenamePrefix: 'scan_',
//                   headerColor: AppColors.primaryColor,
//                   onDocumentTap: (file) => _openPDF(context, file.path),
//                   emptyMessage: 'No PDF documents found\nScan or upload documents to get started',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add document scanning/uploading logic
//         },
//         backgroundColor: AppColors.primaryColor,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   void _openPDF(BuildContext context, String path) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.8,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryColor,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           path.split('/').last,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.white),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.picture_as_pdf,
//                           size: 64,
//                           color: Colors.red[400],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "PDF preview",
//                           style: Theme.of(context).textTheme.titleLarge,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Full PDF viewer coming soon",
//                           style: TextStyle(color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textomize/core/exports.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Add Syncfusion import

class MyDocView extends StatefulWidget {
  MyDocView({super.key});

  @override
  State<MyDocView> createState() => _MyDocViewState();
}

class _MyDocViewState extends State<MyDocView> {
  bool isLoading = true;
  List<Map<String, String>> recentFiles = [];

  @override
  void initState() {
    super.initState();
    _loadRecentPdfFiles();
  }

  Future<void> _loadRecentPdfFiles() async {
    try {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        debugPrint('Storage permission not granted');
        return;
      }

      Directory? downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadDir = await getDownloadsDirectory();
      }

      if (downloadDir == null || !downloadDir.existsSync()) {
        debugPrint('Download directory not found');
        return;
      }

      final List<FileSystemEntity> files = downloadDir.listSync();
      final List<File> pdfFiles = files.whereType<File>().where((file) {
        final fileName = file.uri.pathSegments.last.toLowerCase();
        return fileName.startsWith('scan_') && fileName.endsWith('.pdf');
      }).toList();

      pdfFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      final parsedFiles = pdfFiles.map((file) {
        final modified = file.lastModifiedSync();
        return {
          'title': file.uri.pathSegments.last,
          'date': DateFormat('yyyy-MM-dd').format(modified),
          'time': DateFormat('hh:mm a').format(modified),
          'path': file.path,
        };
      }).toList();

      if (mounted) {
        setState(() {
          recentFiles = parsedFiles;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading recent files: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Open PDF in Dialog
  void _openPDF(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          path.split('/').last,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfPdfViewer.file(File(path)), // Display PDF
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 90.h,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Documents",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      "Recently accessed files",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: DocumentDisplaySection(
                  title: 'Recent PDFs',
                  files: recentFiles, // Pass the recent files
                  onDocumentTap: (file) => _openPDF(context, file['path']!),
                  emptyMessage: 'No PDF documents found\nScan or upload documents to get started',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add document scanning/uploading logic
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class DocumentDisplaySection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> files;
  final Function(Map<String, String>) onDocumentTap;
  final String emptyMessage;

  DocumentDisplaySection({
    required this.title,
    required this.files,
    required this.onDocumentTap,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        if (files.isEmpty)
          Text(emptyMessage),
        // List of PDF files
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return GestureDetector(
              onTap: () => onDocumentTap(file),
              child: Container(
                height: 80.h,
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description,
                          size: 30, color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['title'] ?? 'Untitled',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              CustomText(
                                text: file['date'] ?? '',
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10.0),
                              CustomText(
                                text: file['time'] ?? '',
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.grey),
                      onPressed: () {
                        // Share logic can go here
                      },
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == "open" && file['path'] != null) {
                          onDocumentTap(file);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            child: CustomText(text: "Open"), value: "open"),
                        PopupMenuItem(
                            child: CustomText(text: "Delete"), value: "delete"),
                      ],
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
