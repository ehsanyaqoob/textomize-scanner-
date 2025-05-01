import 'package:textomize/core/exports.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<Map<String, dynamic>> notifications = [
    {'title': 'New Update Available', 'subtitle': 'Tap to update the app.', 'isRead': false},
    {'title': 'Scan Completed', 'subtitle': 'Your document scan is ready.', 'isRead': true},
    {'title': 'Subscription Reminder', 'subtitle': 'Your trial expires in 2 days.', 'isRead': false},
  ];

  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      notifications.insert(0, {
        'title': 'New Message',
        'subtitle': 'You have a new message waiting.',
        'isRead': false,
      });
    });
  }

  void _markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Notifications', centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  'No notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Dismissible(
                    key: Key(item['title']),
                    onDismissed: (direction) => _removeNotification(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () => _markAsRead(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: item['isRead'] ? Colors.grey[200] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item['isRead'] ? Icons.notifications_none : Icons.notifications_active,
                              color: item['isRead'] ? Colors.grey : Colors.blueAccent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['subtitle'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!item['isRead'])
                              const Icon(Icons.circle, size: 10, color: Colors.blueAccent),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
