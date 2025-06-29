import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_data/staff_model.dart';
import 'package:staff_data/add_staff.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  //function to show a confirmation dialog for deletion
  Future<void> _confirmDelete(BuildContext context, Staff staff) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${staff.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //dismiss dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); //dismiss dialog
                await _deleteStaff(context, staff.id!); //call delete function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  //function to delete staff data from Firestore
  Future<void> _deleteStaff(BuildContext context, String staffId) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff deleted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting staff: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      print('Error deleting staff: $e'); //for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff List'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        //listen to changes in the 'staff' collection.
        stream:
            FirebaseFirestore.instance
                .collection('staff')
                .orderBy(
                  'timestamp',
                  descending: true,
                ) //orderBy ensures the latest added staff appear at the top.
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No staff members yet. Add some!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          //map the Firestore documents to a list of Staff objects
          final staffList =
              snapshot.data!.docs
                  .map(
                    (doc) => Staff.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>,
                    ),
                  )
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return Card(
                elevation: 4, //add a slight shadow
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      staff.name[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  title: Text(
                    staff.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${staff.staffId}\nAge : ${staff.age}',
                    style: TextStyle(color: Colors.grey[700], height: 1.4),
                  ),
                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min, //important to prevent overflow
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Edit Staff',
                        onPressed: () {
                          //navigate to AddStaffPage for editing, passing the staff object
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddStaffPage(staffToEdit: staff),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Staff',
                        onPressed:
                            () => _confirmDelete(
                              context,
                              staff,
                            ), //show confirmation dialog
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //navigate to the Staff Creation Page
          Navigator.pushNamed(context, '/add_staff');
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Staff'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
