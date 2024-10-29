import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
