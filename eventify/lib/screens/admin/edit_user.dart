// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:provider/provider.dart';
import 'package:eventify/providers/user_provider.dart';

class EditUser extends StatefulWidget {
  final User user;

  const EditUser({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: AppColors.mediumOrange,
      centerTitle: true,
      title: const Text(
        'Edit User',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        ),
      ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
        const SizedBox(height: 16),
        Stack(
          children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: widget.user.profilePicture != null &&
                widget.user.profilePicture!.isNotEmpty
              ? NetworkImage(widget.user.profilePicture!)
              : const AssetImage(
                  'assets/images/default_profile_image.png')
                as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[100],
            child: Icon(
              widget.user.role == 'u'
                ? Icons.person
                : Icons.calendar_today,
              color: AppColors.mediumOrange,
              size: 30,
            ),
            ),
          ),
          ],
        ),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
          'Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkOrange),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.amberOrange),
          ),
          ),
        ),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
          'Email',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.user.email ?? '',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 32),
        const Spacer(),
        const Text(
          'ACTIONS',
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: AppColors.deepOrange,
          ),
        ),
        const Divider(
          height: 32,
          thickness: 2,
          color: AppColors.deepOrange,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
            onPressed: () => _saveChanges(context),
            child: const Text('Save Name Change'),
          ),
          ElevatedButton(
            onPressed: () => _toggleActived(context),
            style: ElevatedButton.styleFrom(
            backgroundColor: widget.user.actived == true
              ? Colors.white
              : AppColors.darkOrange,
            ),
            child: Text(
            widget.user.actived == true ? 'Activated' : 'Activate',
            style: TextStyle(
              color: widget.user.actived == true
                ? AppColors.darkOrange
                : Colors.white,
            ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _deleteUser(context),
            style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkOrange,
            ),
            child: const Text(
            'Delete',
            style: TextStyle(color: Colors.white),
            ),
          ),
          ],
        ),
        const Divider(
          height: 32,
          thickness: 2,
          color: AppColors.deepOrange,
        ),
        ],
      ),
      ),
    );
  }

  void _saveChanges(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.updateUser(
      widget.user.id,
      _nameController.text,
    );
    await userProvider.fetchAllUsers();
  }

  void _toggleActived(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    bool newValue = !(widget.user.actived ?? false);
    await userProvider.toggleUserValidation(widget.user.id, newValue);
    setState(() {
      widget.user.actived = newValue;
    });
  }

  void _deleteUser(BuildContext context) async {
    bool? confirm = await _showConfirmationDialog(
        context, 'Delete user? WARNING: This action cannot be undone!');
    if (confirm == true) {
      final userProvider = context.read<UserProvider>();
      await userProvider.deleteUser(widget.user.id);
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
