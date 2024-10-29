import 'package:flutter/material.dart';
import 'package:eventify/domain/models/user.dart';

class EditUser extends StatelessWidget {
  final User user;

  EditUser({super.key, required this.user});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<bool> _activedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _emailConfirmedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name;
    _emailController.text = user.email ?? '';
    _activedNotifier.value = user.actived ?? false;
    _emailConfirmedNotifier.value = user.emailConfirmed ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
                backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
                  ? NetworkImage(user.profilePicture!)
                    : const AssetImage('assets/default_profile_picture.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatusButton(
                  notifier: _activedNotifier,
                  activeText: 'Activated',
                  inactiveText: 'Deactivated',
                  activeColor: Colors.green[200]!,
                  inactiveColor: Colors.red[200]!,
                  onPressed: (value) => _toggleActived(context, value),
                ),
                StatusButton(
                  notifier: _emailConfirmedNotifier,
                  activeText: 'Email Verified',
                  inactiveText: 'Email Not Verified',
                  activeColor: Colors.green[200]!,
                  inactiveColor: Colors.red[200]!,
                  onPressed: (value) => _toggleEmailConfirmed(context, value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement API call to save changes
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleActived(BuildContext context, bool newValue) async {
    bool? confirm = await _showConfirmationDialog(context, 'Change activation status?');
    if (confirm == true) {
      _activedNotifier.value = newValue;
      // TODO: Implement API call to update actived status
    }
  }

  void _toggleEmailConfirmed(BuildContext context, bool newValue) async {
    bool? confirm = await _showConfirmationDialog(context, 'Change email verification status?');
    if (confirm == true) {
      _emailConfirmedNotifier.value = newValue;
      // TODO: Implement API call to update emailConfirmed status
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class StatusButton extends StatelessWidget {
  final ValueNotifier<bool> notifier;
  final String activeText;
  final String inactiveText;
  final Color activeColor;
  final Color inactiveColor;
  final Function(bool) onPressed;

  const StatusButton({
    super.key,
    required this.notifier,
    required this.activeText,
    required this.inactiveText,
    required this.activeColor,
    required this.inactiveColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: value ? activeColor : inactiveColor,
          ),
          onPressed: () => onPressed(!value),
          child: Text(value ? activeText : inactiveText),
        );
      },
    );
  }
}