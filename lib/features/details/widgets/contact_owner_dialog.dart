import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ContactOwnerDialog extends StatelessWidget {
  final String listingId;

  const ContactOwnerDialog({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    final tag = 'contact_owner_$listingId';
    final form = Get.put(_ContactOwnerFormController(), tag: tag);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          Get.delete<_ContactOwnerFormController>(tag: tag, force: true);
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Contact Owner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                TextField(
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Your name'),
                  onChanged: (v) => form.name.value = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Your email address'),
                  onChanged: (v) => form.email.value = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Your phone number'),
                  onChanged: (v) => form.phone.value = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: _decoration('Write message...'),
                  onChanged: (v) => form.message.value = v,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Send Message',
                  onPressed: () async {
                    if (listingId.trim().isEmpty) {
                      EasyLoading.showError('Listing id not found');
                      return;
                    }

                    final controller = Get.find<DetailsController>();
                    final ok = await controller.contactOwner(
                      listingId: listingId.trim(),
                      name: form.nullIfEmpty(form.name.value),
                      email: form.nullIfEmpty(form.email.value),
                      phone: form.nullIfEmpty(form.phone.value),
                      message: form.nullIfEmpty(form.message.value),
                    );

                    if (ok && context.mounted) {
                      Get.delete<_ContactOwnerFormController>(
                        tag: tag,
                        force: true,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  width: double.infinity,
                  height: 52,
                  borderRadius: 14,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6E8EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6E8EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF006EF0), width: 1.2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _ContactOwnerFormController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final message = ''.obs;

  String? nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
