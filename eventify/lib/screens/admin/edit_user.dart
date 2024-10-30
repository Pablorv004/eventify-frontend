import 'package:flutter/material.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/user_provider.dart';

class EditUser extends StatelessWidget {
  final User user;

  EditUser({super.key, required this.user});

  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<bool> _activedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _emailConfirmedNotifier =
      ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name;
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
              backgroundImage:
                  user.profilePicture != null && user.profilePicture!.isNotEmpty
                      ? NetworkImage(user.profilePicture!)
                      : const AssetImage('assets/images/default_profile_image.png')
                          as ImageProvider,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: _emailConfirmedNotifier,
              builder: (context, value, child) {
                return Text(
                  value ? 'Email Verified' : 'Email Not Verified',
                  style: TextStyle(
                    color: value ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveChanges(context),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${user.email ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Role: ${user.role == 'u' ? 'User' : 'Organizer'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(
              height: 32,
              thickness: 1,
              color: Colors.grey,
            ),
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
                ElevatedButton(
                  onPressed: () => _deleteUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200]!,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.updateUser(
      user.id,
      _nameController.text,
    );
  }

  void _toggleActived(BuildContext context, bool newValue) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.toggleUserValidation(user.id, newValue);
    _activedNotifier.value = newValue;
  }

  void _deleteUser(BuildContext context) async {
    bool? confirm = await _showConfirmationDialog(context, 'Delete user? WARNING: This action cannot be undone!');
    if (confirm == true) {
      final userProvider = context.read<UserProvider>();
      await userProvider.deleteUser(user.id);
      Navigator.of(context).pop();
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
