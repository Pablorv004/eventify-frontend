import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/edit_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(user.id),
      closeOnScroll: true,
      dragStartBehavior: DragStartBehavior.start,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditUser(user: user)));
            },
            backgroundColor: const Color.fromARGB(255, 33, 149, 243),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            autoClose: true,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (context) {
              _showValidationConfirmationDialog(context, user);
            },
            backgroundColor: user.actived! ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            autoClose: true,
            icon: user.actived! ? Icons.close : Icons.check,
          ),
        ],
      ),
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            _showDeletionConfirmationDialog(context, user);
          },
          backgroundColor: const Color.fromARGB(255, 255, 29, 33),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          autoClose: true,
          icon: Icons.delete,
        )
      ]),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.vibrantOrange, width: 2),
          borderRadius: BorderRadius.circular(7),
        ),
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: user.profilePicture != null
                ? NetworkImage(user.profilePicture!)
                : const AssetImage('assets/images/default_profile_image.png'),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(user.email ?? 'No email provided'),
          trailing: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.softOrange, width: 2),
            ),
            child: Text(
              user.role == 'u' ? 'User' : 'Organizer',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _showValidationConfirmationDialog(BuildContext context, User user) {
    UserProvider userProvider = context.read<UserProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: user.actived!
              ? const Text('Unvalidate User')
              : const Text('Validate User'),
          content: user.actived!
              ? const Text('Are you sure you want to unvalidate this user?')
              : const Text('Are you sure you want to validate this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                userProvider.toggleUserValidation(user.id, !user.actived!);
                Navigator.of(context).pop();
                if (userProvider.validationErrorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user.actived!
                          ? 'User Unvalidated!'
                          : 'User Validated!'),
                      backgroundColor: AppColors.vibrantOrange,
                    ),
                  );
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showDeletionConfirmationDialog(BuildContext context, User user) {
    UserProvider userProvider = context.read<UserProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: user.actived!
              ? const Text('Delete User')
              : const Text('restore User'),
          content: user.actived!
              ? const Text('Are you sure you want to delete this user?')
              : const Text('Are you sure you want to restore this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                userProvider.deleteUser(user.id);
                Navigator.of(context).pop();
                if (userProvider.deleteErrorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user.actived!
                          ? 'User deleted!'
                          : 'User restored!'),
                      backgroundColor: AppColors.vibrantOrange,
                    ),
                  );
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
