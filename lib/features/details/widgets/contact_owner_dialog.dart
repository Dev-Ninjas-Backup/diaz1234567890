import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ContactOwnerDialog extends StatefulWidget {
  final String listingId;

  const ContactOwnerDialog({super.key, required this.listingId});

  @override
  State<ContactOwnerDialog> createState() => _ContactOwnerDialogState();
}

class _ContactOwnerDialogState extends State<ContactOwnerDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _onSend() async {
    if (widget.listingId.trim().isEmpty) {
      EasyLoading.showError('Listing id not found');
      return;
    }

    final controller = Get.find<DetailsController>();

    final ok = await controller.contactOwner(
      listingId: widget.listingId.trim(),
      name: _nullIfEmpty(_nameController.text),
      email: _nullIfEmpty(_emailController.text),
      phone: _nullIfEmpty(_phoneController.text),
      message: _nullIfEmpty(_messageController.text),
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

  InputDecoration _decoration(String hint) {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Your name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Your email address'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Your phone number'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: _decoration('Write message...'),
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Send Message',
                onPressed: _onSend,
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
    );
  }
}
