import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../App/app_colors.dart';

class DocumentManager {
  static Future<List<Map<String, dynamic>>> loadDocuments({
    String? directoryPath,
    List<String> extensions = const ['pdf'],
    String? filenamePrefix,
    int maxFiles = 20,
  }) async {
    try {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

      Directory? targetDir;
      if (directoryPath != null) {
        targetDir = Directory(directoryPath);
      } else {
        targetDir = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getDownloadsDirectory();
      }

      if (targetDir == null || !targetDir.existsSync()) {
        throw Exception('Directory not found');
      }

      final files = targetDir.listSync().whereType<File>().where((file) {
        final fileName = file.path.split('/').last.toLowerCase();
        final hasPrefix = filenamePrefix == null || 
                         fileName.startsWith(filenamePrefix.toLowerCase());
        final hasExtension = extensions.any(
          (ext) => fileName.endsWith('.${ext.toLowerCase()}')
        );
        return hasPrefix && hasExtension;
      }).toList();

      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      return files.take(maxFiles).map((file) {
        final modified = file.lastModifiedSync();
        return {
          'title': _cleanFilename(file.path.split('/').last),
          'date': DateFormat('MMM dd, yyyy').format(modified),
          'time': DateFormat('hh:mm a').format(modified),
          'path': file.path,
          'size': _formatFileSize(file.lengthSync()),
          'modified': modified,
          'file': file,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading documents: $e');
      rethrow;
    }
  }

  static String _cleanFilename(String filename) {
    return filename
      .replaceAll(RegExp(r'[_-]'), ' ')
      .replaceAll(RegExp(r'\.(pdf|doc|docx)$'), '')
      .trim();
  }

  static String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

class DocumentDisplaySection extends StatefulWidget {
  final String? title;
  final String? emptyMessage;
  final List<String> fileExtensions;
  final String? filenamePrefix;
  final String? directoryPath;
  final int maxFiles;
  final bool showLoading;
  final Color? headerColor;
  final ValueChanged<File>? onDocumentTap;

  const DocumentDisplaySection({
    super.key,
    this.title,
    this.emptyMessage = 'No documents found',
    this.fileExtensions = const ['pdf'],
    this.filenamePrefix,
    this.directoryPath,
    this.maxFiles = 20,
    this.showLoading = true,
    this.headerColor,
    this.onDocumentTap,
  });

  @override
  State<DocumentDisplaySection> createState() => _DocumentDisplaySectionState();
}

class _DocumentDisplaySectionState extends State<DocumentDisplaySection> {
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final loadedDocs = await DocumentManager.loadDocuments(
        directoryPath: widget.directoryPath,
        extensions: widget.fileExtensions,
        filenamePrefix: widget.filenamePrefix,
        maxFiles: widget.maxFiles,
      );

      documents.value = loadedDocs;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Obx(() {
          if (isLoading.value && widget.showLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (errorMessage.value.isNotEmpty) {
            return _buildErrorState();
          }
          if (documents.isEmpty) {
            return _buildEmptyState();
          }
          return _buildDocumentsList();
        }),
      ],
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade400),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDocuments,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.folder_open, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            widget.emptyMessage!,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _buildDocumentItem(doc);
      },
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> doc) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onDocumentTap?.call(doc['file']),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getFileColor(doc['path']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getFileIcon(doc['path']),
                    color: _getFileColor(doc['path']),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${doc['date']} • ${doc['size']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
                onPressed: () => _showDocumentOptions(doc['file']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getFileColor(String path) {
    if (path.toLowerCase().endsWith('.pdf')) return Colors.red;
    if (path.toLowerCase().endsWith('.doc') || 
        path.toLowerCase().endsWith('.docx')) return Colors.blue;
    return Colors.grey;
  }

  IconData _getFileIcon(String path) {
    if (path.toLowerCase().endsWith('.pdf')) return Icons.picture_as_pdf;
    if (path.toLowerCase().endsWith('.doc') || 
        path.toLowerCase().endsWith('.docx')) return Icons.description;
    return Icons.insert_drive_file;
  }

  void _showDocumentOptions(File file) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.open_in_new, color: AppColors.primaryColor),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDocumentTap?.call(file);
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.blue.shade400),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  _shareDocument(file);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red.shade400),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareDocument(File file) async {
    // Implement sharing functionality
    Get.snackbar('Share', 'Sharing ${file.path.split('/').last}');
  }

  Future<void> _confirmDelete(File file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Delete ${file.path.split('/').last}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await file.delete();
        documents.removeWhere((doc) => doc['path'] == file.path);
        Get.snackbar('Success', 'Document deleted');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete document');
      }
    }
  }
}