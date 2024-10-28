import 'package:eventify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchAllUsers(userProvider.currentUser?.rememberToken ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: userProvider.fetchErrorMessage != null
          ? Center(child: Text(userProvider.fetchErrorMessage!))
          : ListView.builder(
              itemCount: userProvider.userList.length,
              itemBuilder: (context, index) {
                final user = userProvider.userList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email ?? 'No email provided'),
                    trailing: Text(user.role),
                  ),
                );
              },
            ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}