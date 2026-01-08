import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/profile/main/controller/profile_controller.dart';
import 'package:diaz1234567890/core/common/style/global_text_style.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final ProfileController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: getTextStyle(fontSize: 16)),
        actions: [
          IconButton(
            onPressed: () async {
              await ctrl.markAllRead();
            },
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Obx(() {
        final list = ctrl.notifications;
        if (list.isEmpty) {
          return Center(child: Text('No notifications', style: getTextStyle()));
        }

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final item = list[i];
            final notif = item['notification'] is Map
                ? Map<String, dynamic>.from(item['notification'])
                : <String, dynamic>{};
            final title = notif['title']?.toString() ?? '';
            final message = notif['message']?.toString() ?? '';
            // prefer using an explicit mark-read action so tapping can be used
            // to navigate to the related record later.
            return ListTile(
              title: Text(title, style: getTextStyle()),
              subtitle: Text(message, style: getTextStyle(color: Colors.grey)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                tooltip: 'Mark as read',
                onPressed: () async {
                  final id = item['id']?.toString() ?? '';
                  if (id.isNotEmpty) await ctrl.markOneRead(id);
                },
              ),
              onTap: () {
                // Placeholder: navigate to related record using `notif['meta']` if desired.
              },
            );
          },
        );
      }),
    );
  }
}
