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
    final UserProvider userProvider = context.watch<UserProvider>();

    return Slidable(
      key: ValueKey(user.id),
      closeOnScroll: true,
      dragStartBehavior: DragStartBehavior.start,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditUser(user: user)));
            },
            backgroundColor: const Color.fromARGB(255, 33, 149, 243),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            autoClose: true,
            icon: Icons.edit,
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
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            autoClose: true,
            icon: user.actived! ? Icons.close : Icons.check,
          ),
        ],
      ),
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            // TODO: Implement delete user in UserProvider
          },
          backgroundColor: const Color.fromARGB(255, 255, 29, 33),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          autoClose: true,
          icon: Icons.delete,
        )
      ]),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.vibrantOrange, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: user.profilePicture != null ? NetworkImage(user.profilePicture!) : AssetImage('assets/images/default_profile_image.png'),
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
