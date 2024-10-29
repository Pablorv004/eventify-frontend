import 'package:eventify/domain/models/user.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/config/app_colors.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  Set<String> _filters = {'All'};

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchAllUsers(userProvider.currentUser?.rememberToken ?? '');
  }

  void _setFilter(String filter) {
    setState(() {
      if (filter == 'All') {
        _filters = {'All'};
      } else {
        _filters.remove('All');
        if (_filters.contains(filter)) {
          _filters.remove(filter);
        } else {
          _filters.add(filter);
        }
        if (_filters.isEmpty) {
          _filters.add('All');
        }
      }
    });
  }

  List<User> _getFilteredUsers(UserProvider userProvider) {
    if (_filters.contains('All')) {
      return userProvider.userList;
    }
    return userProvider.userList.where((user) {
      bool matches = true;
      if (_filters.contains('Non-activated')) {
        matches = matches && (user.actived ?? false) == false;
      }
      if (_filters.contains('Non-verified')) {
        matches = matches && (user.emailConfirmed ?? false) == false;
      }
      if (_filters.contains('Organizer')) {
        matches = matches && user.role == 'o';
      }
      if (_filters.contains('User')) {
        matches = matches && user.role == 'u';
      }
      return matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final filteredUsers = _getFilteredUsers(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Non-activated'),
                _buildFilterButton('Non-verified'),
                _buildFilterButton('Organizer'),
                _buildFilterButton('User'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: userProvider.fetchErrorMessage != null
                ? Center(child: Text(userProvider.fetchErrorMessage!))
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return UserCard(user: user);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () => _setFilter(filter),
        style: ElevatedButton.styleFrom(
          backgroundColor: _filters.contains(filter) ? AppColors.vibrantOrange : Colors.grey,
        ),
        child: Text(filter),
      ),
    );
  }
}

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
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email ?? 'No email provided'),
        trailing: Text(user.role),
      ),
    );
  }
}
