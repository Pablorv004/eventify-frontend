import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/main.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/manage_users_screen.dart';
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

    final userProvider = context.watch<UserProvider>();

    return Slidable(
      key: ValueKey(user.id),
      closeOnScroll: true,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {

            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              userProvider.toggleUserValidation(user.id, !user.actived!);
              if (userProvider.validationErrorMessage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(user.actived! ? 'User Unvalidated!' : 'User Validated!'),
                    backgroundColor: AppColors.vibrantOrange,
                  ),
                );
              }
            },
            backgroundColor: user.actived! ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            icon: user.actived! ? Icons.close : Icons.check,
            label: user.actived! ? 'Unvalidate' : 'Validate',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.vibrantOrange, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: user.profilePicture != null
                ? NetworkImage(user.profilePicture!)
                : const NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(user.email ?? 'No email provided'),
          trailing: Text(user.role == 'u' ? 'User' : 'Organizer'),
        ),
      ),
    );
  }
}
