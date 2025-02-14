import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/list_user_controller.dart';

class ListUserView extends GetView<ListUserController> {
  ListUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: controller.isAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !(snapshot.data ?? false)) {
          return Scaffold(
            appBar: AppBar(title: Text('Access Denied')),
            body: const Center(
              child: Text('You do not have permission to access this page.'),
            ),
          );
        }

        return Scaffold(
          floatingActionButton: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showCreateDialog(context),
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User List'),
                Gap(20),
              ],
            ),
          ),
          body: FutureBuilder<List<Users>>(
            future: controller.fetchUsers(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Obx(
                () => ListView.builder(
                  itemCount: controller.usersList.length,
                  itemBuilder: (context, index) {
                    final user = controller.usersList[index];
                    // Check if this is the current user
                    final isCurrentUser =
                        user.id == controller.currentUserId.value;
                    return ListTile(
                      title: Text(
                        '${user.name} (${user.role})${isCurrentUser ? ' (You)' : ''}' ??
                            'No Name',
                      ),
                      subtitle: Text(user.email ?? 'No Email'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          IconButton(
                            tooltip: 'edit',
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                controller.showEditDialog(context, user),
                          ),
                          IconButton(
                            tooltip: 'delete',

                            icon: Icon(Icons.delete),
                            // Disable delete button for current user
                            onPressed: isCurrentUser
                                ? null // This will gray out the button
                                : () async {
                                    final confirm = await controller
                                        .showConfirmationDialog(context);
                                    if (confirm) {
                                      await controller.deleteUser(user.id);
                                    }
                                  },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New User'),
          content: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller.namaController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  FutureBuilder<List<Map<String, String>>>(
                    future: controller.fetchRoles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No roles available');
                      }
                      return DropdownButtonFormField<String>(
                        value: controller.selectedRoleId.value.isEmpty
                            ? null
                            : controller.selectedRoleId.value,
                        items: snapshot.data!.map((role) {
                          return DropdownMenuItem(
                            value: role['id'],
                            child: Text(role['name']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedRoleId.value = value ?? '';
                        },
                        decoration: InputDecoration(labelText: 'Role'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            Obx(() => TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.createUser(),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text('Create'),
                )),
          ],
        );
      },
    );
  }
}
