import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  final String eventId;

  const RegistrationPage({super.key, required this.eventId});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController(); // New Address Controller
  final _feedbackController = TextEditingController();

  String? _selectedProfession; // Variable to store selected profession
  bool _isLoading = false;

  // List of profession options
  final List<String> _professions = [
    'Student',
    'Engineer',
    'Doctor',
    'Teacher',
    'Developer',
    'Designer',
    'Other',
  ];

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .collection('registered_users')
            .add({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'city': _cityController.text,
          'district': _districtController.text,
          'address': _addressController.text, // Added Address field
          'profession': _selectedProfession ?? 'Not specified',
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration successful!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        _formKey.currentState!.reset();
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _cityController.clear();
        _districtController.clear();
        _addressController.clear(); // Reset address
        setState(() {
          _selectedProfession = null; // Reset dropdown
        });
        _feedbackController.clear();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error registering user: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Registration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'Name', Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_phoneController, 'Phone', Icons.phone,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', Icons.email,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_cityController, 'City', Icons.location_city),
                const SizedBox(height: 16),
                _buildTextField(_districtController, 'District', Icons.map),
                const SizedBox(height: 16),
                _buildTextField(_addressController, 'Address', Icons.home),
                const SizedBox(height: 16),
                _buildProfessionDropdown(),
                const SizedBox(height: 16),
                _buildTextField(_feedbackController,
                    'Would you like to join this type of program?', Icons.feedback,
                    maxLines: 3),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: 0.9 + (value * 0.1),
                            child: Opacity(
                              opacity: value,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.save, size: 24),
                                label: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.blue.withOpacity(0.5),
                                ),
                                onPressed: _registerUser,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated TextField builder
  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter your $label' : null,
    );
  }

  // Profession dropdown
  Widget _buildProfessionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProfession,
      decoration: InputDecoration(
        labelText: 'Profession',
        prefixIcon: const Icon(Icons.work, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      hint: const Text('Select your profession'),
      items: _professions.map((String profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(profession),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedProfession = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a profession' : null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose(); // Dispose address controller
    _feedbackController.dispose();
    super.dispose();
  }
}
