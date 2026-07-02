import 'package:flutter/material.dart';
import 'package:learn_flutter_nodejs/models/user.model.dart';
import 'package:learn_flutter_nodejs/pages/edit_user.dart';
import 'package:learn_flutter_nodejs/services/user.service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserModel> users = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isloading = true;
    });
    final result = await UserService.getUsers(); //call api
    setState(() {
      users = result;
      isloading = false;
    });
  }

  Future<void> confirmDeleteUser(UserModel user) async {
    final confrim = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${user.full_name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confrim == true) {
      final result = await UserService.deleteUser(user.id);
      if (!mounted) return;
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Deleted Well'),
            backgroundColor: Colors.green,
          ),
        );
      }
      fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User Not Deleted'),
          backgroundColor: Colors.red,
        ),
      );
    }
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("USERS CRUD"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No Users Found"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.cyan,
                      child: Text(user.full_name[0].toUpperCase()),
                    ),
                    title: Text(user.full_name),
                    subtitle: Text(user.username),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            // We push directly to the page and hand it the user object.
                            // This is how you pass data to a page that ISN'T a plain named route.
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUserPage(user: user),
                              ),
                            );

                            // EditUserPage calls Navigator.pop(context, true) after a successful update.
                            // If we get true back, refresh the list so the change shows immediately.
                            if (updated == true) fetchUsers();
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),

                        IconButton(
                          onPressed: () {
                            confirmDeleteUser(user);
                          },
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-user');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
