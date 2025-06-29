import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staff_data/staff_model.dart';

class AddStaffPage extends StatefulWidget {
  final Staff? staffToEdit;

  const AddStaffPage({super.key, this.staffToEdit});

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>(); //key for form validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.staffToEdit != null) {
      _nameController.text = widget.staffToEdit!.name;
      _staffIdController.text = widget.staffToEdit!.staffId;
      _ageController.text = widget.staffToEdit!.age.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _staffIdController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveStaff() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final staff = Staff(
          name: _nameController.text.trim(),
          staffId: _staffIdController.text.trim(),
          age: int.parse(_ageController.text.trim()),
        );

        if (widget.staffToEdit == null) {
          //create new staff
          await FirebaseFirestore.instance
              .collection('staff')
              .add(staff.toFirestore());
          _showSnackBar('Staff added successfully!');
        } else {
          //update existing staff
          await FirebaseFirestore.instance
              .collection('staff')
              .doc(widget.staffToEdit!.id)
              .update(staff.toFirestore());
          _showSnackBar('Staff updated successfully!');
        }

        //navigate back to the Staff List Page after successful operation
        Navigator.pop(context);
      } catch (e) {
        _showSnackBar('Error saving staff: $e', isError: true);
        print('Error saving staff: $e'); // For debugging
      } finally {
        setState(() {
          _isLoading = false; //hide loading indicator
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.staffToEdit == null ? 'Add New Staff' : 'Edit Staff',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Staff Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter staff name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _staffIdController,
                decoration: InputDecoration(
                  labelText: 'Staff ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter staff ID';
                  }
                  if (value.length < 3) {
                    return 'Staff ID must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Staff Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number, //only allow numbers
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter staff age';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _saveStaff,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor, //button color
                      foregroundColor: Colors.white, //text color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, //add a shadow
                    ),
                    child: Text(
                      widget.staffToEdit == null
                          ? 'Submit Staff'
                          : 'Update Staff',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
