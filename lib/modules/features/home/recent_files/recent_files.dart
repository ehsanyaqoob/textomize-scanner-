import 'package:textomize/core/exports.dart';

class RecentFilesSection extends StatefulWidget {
  final List<Map<String, String>> recentFiles;

  RecentFilesSection({required this.recentFiles});

  @override
  State<RecentFilesSection> createState() => _RecentFilesSectionState();
}

class _RecentFilesSectionState extends State<RecentFilesSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          // List of Recent Files
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.recentFiles.length,
            itemBuilder: (context, index) {
              return Container(
              
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.85),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // File Icon
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description,
                        size: 30,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(width: 12.0),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.recentFiles[index]['title']!,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              CustomText(
                            text:     widget.recentFiles[index]['date']!,
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                
                              ),
                              SizedBox(width: 10.0),
                              CustomText(
                             text:    widget.recentFiles[index]['time']!,
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                 text:  'Sharing ${widget.recentFiles[index]['title']}',
                                ),
                              ),
                            );
                          },
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: CustomText( text: "Open"),
                              value: "open",
                            ),
                            PopupMenuItem(
                              child: CustomText( text: "Delete"),
                              value: "delete",
                            ),
                          ],
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                          onSelected: (value) {
                            if (value == "delete") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomText(
                               text:      '${widget.recentFiles[index]['title']} deleted.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


