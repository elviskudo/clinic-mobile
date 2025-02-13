// lib/app/modules/personal_data/views/personal_data_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/personal_data_controller.dart';

class PersonalDataView extends GetView<PersonalDataController> {
  const PersonalDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Clinic',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.lightGreen[100],
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'johndoe@email.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Pasien',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View your account settings',
                  style: TextStyle(color: Colors.green),
                ),
              ),

              // Incomplete Data Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Segera selesaikan data yang belum terselesaikan!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Selesaikan Personal Data di profil kamu',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/images/orangeBadge.png",
                          width: 128,
                          height: 92,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Diagnosis Item
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Diagnosis (Alergi, Riwayat Trauma ...)'),
                          Icon(Icons.check, color: Colors.blue),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Personal Data Item
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Data Personal (No. KTP, Gender)'),
                          Text('String value'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                subtitle: const Text('Off'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Riwayat'),
                subtitle: const Text("Doctor's appointments and purchases"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English (Device Language)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help Center'),
                subtitle: const Text('General help, FAQs, Contact us'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Kirim umpan balik'),
                subtitle: const Text('Give some feedback'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
