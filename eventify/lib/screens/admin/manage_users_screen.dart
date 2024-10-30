import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ManageUsersScreenState createState() => ManageUsersScreenState();
}

class ManageUsersScreenState extends State<ManageUsersScreen> {
  Set<String> _filters = {'All'};

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchAllUsers();
    _setFilter("All");
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final filteredUsers = _getFilteredUsers(userProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      appBar: AppBar(
        title: const Text('Manage Users', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColors.vibrantOrange,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 3),
            child: Row(
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Non-activated'),
                _buildFilterButton('Non-verified'),
                _buildFilterButton('Deleted'),
                _buildFilterButton('Organizer'),
                _buildFilterButton('User'),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          Expanded(
            child: userProvider.fetchErrorMessage != null
                ? Center(child: Text(userProvider.fetchErrorMessage!))
                : SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return UserCard(user: user);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _setFilter(String filter) {
    setState(() {
      if (filter == 'All') {
        _filters = {'All'};
      } else {
        _filters.remove('All');
        if (_filters.contains(filter)) {
          _filters.remove(filter);
        } else if (filter == 'Organizer'){
          _filters.remove('User');
          _filters.add(filter);
        } else if (filter == 'User'){
          _filters.remove('Organizer');
          _filters.add(filter);
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
      if (_filters.contains('Deleted')) {
        matches = matches && user.deleted == true;
      }
      return matches;
    }).toList();
  }

  Widget _buildFilterButton(String filter) {
    IconData icon = Icons.filter_list;
    icon = iconChooser(filter, icon);

    bool isSelected = _filters.contains(filter);
    Color iconColor = isSelected ? Colors.white : Colors.black;
    Color iconBackgroundColor = isSelected ? AppColors.vibrantOrange : Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        margin: const EdgeInsets.only(right: 3),
        child: FilterButton(
          isSelected: isSelected,
          filter: filter,
          icon: icon,
          iconBackgroundColor: iconBackgroundColor,
          iconColor: iconColor,
          onPressed: _setFilter,
        ),
      ),
    );
  }

  IconData iconChooser(String filter, IconData icon) {
    switch (filter) {
      case 'Non-activated':
        icon = Icons.block;
        break;
      case 'Non-verified':
        icon = Icons.verified_outlined;
        break;
      case 'Deleted':
        icon = Icons.delete;
        break;
      case 'Organizer':
        icon = Icons.event;
        break;
      case 'User':
        icon = Icons.person;
        break;
      default:
        icon = Icons.filter_list;
    }
    return icon;
  }
}

class FilterButton extends StatelessWidget {
  final bool isSelected;
  final String filter;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Function(String) onPressed;

  const FilterButton({
    super.key,
    required this.isSelected,
    required this.filter,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.vibrantOrange : Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: iconColor),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
