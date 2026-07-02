// This is the Edit User Page
// It receives an existing UserModel, pre-fills the form with its data,
// and lets the admin update it via the API

import 'package:flutter/material.dart';
import '../models/user.model.dart';
import '../services/user.service.dart';

class EditUserPage extends StatefulWidget {
  // We receive the user to edit from the previous page (HomePage)
  final UserModel user;

  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers hold the text typed in each field
  late TextEditingController _fullName;
  late TextEditingController _email;
  late TextEditingController _username;

  bool isSaving = false; // Disables button + shows spinner while saving

  // initState runs once when the page opens
  // We use it to PRE-FILL the form with the existing user's data
  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: widget.user.full_name);
    _email = TextEditingController(text: widget.user.email);
    _username = TextEditingController(text: widget.user.username);
  }

  // Always dispose controllers to avoid memory leaks
  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _username.dispose();
    super.dispose();
  }

  // Called when the "UPDATE" button is pressed
  Future<void> handleUpdate() async {
    if (!_formKey.currentState!.validate()) return; // Stop if form invalid

    setState(() => isSaving = true);

    final result = await UserService.updateUser(
      id: widget.user.id,
      full_name: _fullName.text.trim(),
      email: _email.text.trim(),
      username: _username.text.trim(),
    );

    setState(() => isSaving = false);

    // Check if widget is still on screen before using context (good practice)
    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // true tells HomePage "refresh the list"
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Update failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EDIT USER"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Show spinner while saving, otherwise show the button
              isSaving
                  ? const CircularProgressIndicator()
                  : MaterialButton(
                      onPressed: handleUpdate,
                      color: Colors.blue,
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}