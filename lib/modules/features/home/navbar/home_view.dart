import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:textomize/widgets/info_details.dart';
import 'package:textomize/widgets/custom_text_widgets.dart';
import '../../../../controllers/controllers.dart';
import '../../../../controllers/newsfeed_controller.dart';
import '../../../../core/constatnts.dart';
import '../../../../core/exports.dart';
import '../../../../core/storage_services.dart';
import '../../../../models/tool_model.dart';
import '../tools/tools_section.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  String userName = '';
  String fullName = '';
  List<Map<String, String>> recentFiles = [];

  final NewsFeedController controller = Get.put(NewsFeedController());
  final HomeController _controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadRecentPdfFiles();

    if (_controller.hasShownShimmer) {
      isLoading = false;
    } else {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          _controller.hasShownShimmer = true;
        });
      });
    }
  }

  void loadUserData() {
    setState(() {
      userName = StorageService.getUserName() ?? '';
      fullName = StorageService.getUserName() ?? '';
    });
  }

  Future<void> loadRecentPdfFiles() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) return;

    Directory? downloadDir;
    if (Platform.isAndroid) {
      downloadDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadDir = await getDownloadsDirectory();
    }

    if (downloadDir == null || !downloadDir.existsSync()) return;

    final List<FileSystemEntity> files = downloadDir.listSync();

    final List<File> pdfFiles = files
        .whereType<File>()
        .where((file) {
      final fileName = file.uri.pathSegments.last.toLowerCase();
      return fileName.startsWith('scan_') && fileName.endsWith('.pdf');
    })
        .toList();


    // Sort by latest modified
    pdfFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    final List<Map<String, String>> parsedFiles = pdfFiles.map((file) {
      final modified = file.lastModifiedSync();
      return {
        'title': file.uri.pathSegments.last,
        'date': DateFormat('yyyy-MM-dd').format(modified),
        'time': DateFormat('hh:mm a').format(modified),
        'path': file.path,
      };
    }).toList();

    setState(() {
      recentFiles = parsedFiles;
    });
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'PDF Preview',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SfPdfViewer.file(File(path)),
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
      body: isLoading ? _buildShimmerEffect() : _buildHomeContent(),
    );
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerBox(height: 200, width: double.infinity),
          SizedBox(height: 16),
          _shimmerBox(height: 100, width: double.infinity),
          SizedBox(height: 16),
          _shimmerGrid(),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(
              username: userName,
              fullName: userName,
            ),
            SizedBox(height: 16.h),
            ToolsSection(
              tools: tools.map((tool) => Tool.fromMap(tool)).toList(),
            ),
            SizedBox(height: 16.h),
            RecentFilesSection(
              recentFiles: recentFiles,
              onOpenPdf: _openPDF,
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _shimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecentFilesSection extends StatelessWidget {
  final List<Map<String, String>> recentFiles;
  final Function(BuildContext context, String path) onOpenPdf;

  RecentFilesSection({required this.recentFiles, required this.onOpenPdf});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: AppConstants.recent_files,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.black, size: 22),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recentFiles.length,
          itemBuilder: (context, index) {
            final file = recentFiles[index];
            return Container(
              height: 80.h,
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 3),
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
                    child: Icon(Icons.description,
                        size: 30, color: AppColors.primaryColor),
                  ),
                  SizedBox(width: 12.0),
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
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            CustomText(
                              text: file['date'] ?? '',
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.0.w),
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
                    icon: Icon(Icons.share, color: Colors.grey),
                    onPressed: () {
                      // Share logic can go here
                    },
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == "open" && file['path'] != null) {
                        onOpenPdf(context, file['path']!);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(child: CustomText(text: "Open"), value: "open"),
                      PopupMenuItem(child: CustomText(text: "Delete"), value: "delete"),
                    ],
                    icon: Icon(Icons.more_vert, color: Colors.grey),
                  ),

                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
