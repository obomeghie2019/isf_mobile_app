import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:isf_app/screens/registration_success_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ContinueRegistrationScreen extends StatefulWidget {
  final String email;
  final String amount;
  final String reference;
  final String name;
  final String phone;
  final String regNo;

  const ContinueRegistrationScreen({
    super.key,
    required this.email,
    required this.amount,
    required this.reference,
    required this.name,
    required this.phone,
    required this.regNo,
  });

  @override
  State<ContinueRegistrationScreen> createState() =>
      _ContinueRegistrationScreenState();
}

class _ContinueRegistrationScreenState
    extends State<ContinueRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _lgaController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _tshirtSizeController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _hasAgreed = false;

  String? _selectedGender;
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  void _showPreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to close
      builder: (context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // 🔥 WIDER HERE
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close icon
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Text(
                    'Preview Registration',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  _previewItem('Full Name', _nameController.text),
                  _previewItem('Phone', _phoneController.text),
                  _previewItem('Email', widget.email),
                  _previewItem('Registration No.', widget.regNo),
                  _previewItem('Date of Birth', _dobController.text),
                  _previewItem('Gender', _selectedGender ?? '-'),
                  _previewItem('LGA', _lgaController.text),
                  _previewItem(
                      'Emergency Contact', _emergencyContactController.text),
                  _previewItem('Race Category', _selectedCategory ?? '-'),
                  _previewItem('T-Shirt Size', _tshirtSizeController.text),
                  _previewItem('Blood Group', _bloodGroupController.text),
                  _previewItem(
                    'Medical Conditions',
                    _medicalConditionsController.text.isEmpty
                        ? 'None'
                        : _medicalConditionsController.text,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 59, 59, 223), // Blue
                                Color.fromARGB(255, 1, 44, 3), // Green
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() => _isSubmitting = true);

                                    try {
                                      await _submitRegistration();

                                      // Close preview ONLY after successful submit
                                      if (mounted) Navigator.pop(context);
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isSubmitting = false);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _previewItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }

  final List<String> categories = [
    '6KM Run Price',
    '6KM Fun Walk',
    '6KM Exercise Walk',
  ];
  final List<String> tshirtSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  Future<Map<String, dynamic>> submitRegistration(
      Map<String, dynamic> payload) async {
    const String url =
        "https://360globalnetwork.com.ng/isf2025/reg_athlete.php";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      return jsonDecode(response.body);
    } on TimeoutException {
      return {"status": "timeout", "message": "Request timed out"};
    } catch (e) {
      return {"status": "error", "message": "Network error"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.offline_share_sharp, color: Colors.white),
        title: const Text('Continue Registration...'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 59, 59, 223),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Success Banner
              Card(
                color: Colors.green[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Payment Successful!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('₦${widget.amount} paid',
                                style: TextStyle(color: Colors.green[700])),
                            Text('Ref: ${widget.reference}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 10, 115, 41))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Step 2: Complete Registration Form',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Please fill in your details below:',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Editable fields
                    _buildTextField(
                        label: 'Full Name',
                        value: _nameController.text,
                        controller: _nameController,
                        icon: Icons.person,
                        readOnly: false),
                    _buildTextField(
                        label: 'Phone',
                        value: _phoneController.text,
                        controller: _phoneController,
                        icon: Icons.phone_in_talk,
                        readOnly: false),

                    // Read-only fields
                    _buildTextField(
                        label: 'Email', value: widget.email, icon: Icons.email),
                    _buildTextField(
                        label: 'Registration No.',
                        value: widget.regNo,
                        icon: Icons.confirmation_number),

                    const SizedBox(height: 20),

                    // Date of Birth
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please select date of birth'
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female'].map((gender) {
                        return DropdownMenuItem(
                            value: gender, child: Text(gender));
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      validator: (value) =>
                          value == null ? 'Please select gender' : null,
                    ),

                    const SizedBox(height: 20),

                    // Address
                    TextFormField(
                      controller: _lgaController,
                      decoration: InputDecoration(
                        labelText: 'Local Government Area',
                        prefixIcon: const Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please Enter Local Government Area'
                          : null,
                    ),

                    const SizedBox(height: 20),

                    // Emergency Contact
                    TextFormField(
                      controller: _emergencyContactController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact & Number',
                        prefixIcon: const Icon(Icons.phone_in_talk),
                        border: OutlineInputBorder(),
                        counterText: "", // hides the default character counter
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // only allow numbers
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter emergency contact';
                        }
                        if (value.length != 11) {
                          return 'Contact number must be exactly 11 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Race Category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Race Category',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value),
                      validator: (value) =>
                          value == null ? 'Please select race category' : null,
                    ),

                    const SizedBox(height: 20),

                    // T-Shirt Size
                    DropdownButtonFormField<String>(
                      value: _tshirtSizeController.text.isNotEmpty
                          ? _tshirtSizeController.text
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Bib Size',
                        prefixIcon: const Icon(Icons.photo_size_select_large),
                        border: OutlineInputBorder(),
                      ),
                      items: tshirtSizes
                          .map((size) =>
                              DropdownMenuItem(value: size, child: Text(size)))
                          .toList(),
                      onChanged: (value) => _tshirtSizeController.text = value!,
                      validator: (value) =>
                          value == null ? 'Please select bib size' : null,
                    ),

                    const SizedBox(height: 20),

                    // Blood Group (Optional)
                    DropdownButtonFormField<String>(
                      value: _bloodGroupController.text.isNotEmpty
                          ? _bloodGroupController.text
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Blood Group (Optional)',
                        prefixIcon: const Icon(Icons.bloodtype),
                        border: OutlineInputBorder(),
                      ),
                      items: bloodGroups
                          .map((group) => DropdownMenuItem(
                              value: group, child: Text(group)))
                          .toList(),
                      onChanged: (value) => _bloodGroupController.text = value!,
                    ),

                    const SizedBox(height: 20),

                    // Medical Conditions (Optional)
                    TextFormField(
                      controller: _medicalConditionsController,
                      decoration: InputDecoration(
                        labelText: 'Medical Conditions/Allergies (Optional)',
                        prefixIcon: const Icon(Icons.medical_services),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 30),

                    // Declaration Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _hasAgreed,
                          onChanged: (value) {
                            setState(() {
                              _hasAgreed = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'I declare that all information provided is true and accurate. '
                            'I understand the risks involved in marathon running and participate at my own risk.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _hasAgreed
                                ? [
                                    const Color.fromARGB(255, 59, 59, 223),
                                    const Color.fromARGB(255, 1, 44, 3),
                                  ]
                                : [
                                    Colors.grey.shade400,
                                    Colors.grey.shade500,
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: _hasAgreed
                              ? _showPreviewDialog
                              : null, // Disable if not agreed
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // important for gradient
                            shadowColor:
                                Colors.transparent, // remove default shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.preview,
                                  color: Colors.white), // registration icon
                              SizedBox(width: 10),
                              Text(
                                'Preview',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required IconData icon,
    bool readOnly = true,
    TextEditingController? controller,
  }) {
    final TextEditingController controller0 =
        controller ?? TextEditingController(text: value);

    // Check if this is the Phone field
    final bool isPhoneField = label.toLowerCase().contains('phone');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller0,
          readOnly: readOnly,
          keyboardType:
              isPhoneField ? TextInputType.number : TextInputType.text,
          maxLength: isPhoneField ? 11 : null,
          inputFormatters:
              isPhoneField ? [FilteringTextInputFormatter.digitsOnly] : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[700]),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
            counterText: isPhoneField ? "" : null, // hide counter for phone
          ),
          validator: (val) {
            if (!readOnly && (val == null || val.isEmpty)) {
              return 'Please enter $label';
            }
            if (isPhoneField && val != null && val.length != 11) {
              return 'Phone number must be exactly 11 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final url = Uri.parse(
        'https://360globalnetwork.com.ng/isf2025/reg_athlete.php'); // Replace with your API URL

    final body = jsonEncode({
      "name": _nameController.text,
      "phone": _phoneController.text,
      "email": widget.email,
      "regNo": widget.regNo,
      "dob": _dobController.text,
      "gender": _selectedGender,
      "lga": _lgaController.text,
      "emergencyContact": _emergencyContactController.text,
      "category": _selectedCategory,
      "tshirtSize": _tshirtSizeController.text,
      "bloodGroup": _bloodGroupController.text,
      "medicalConditions": _medicalConditionsController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        Get.snackbar(
          "Registration Complete!",
          data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => RegistrationSuccessScreen(
                name: _nameController.text,
                appNo: widget.regNo,
                category: _selectedCategory ?? 'N/A',
                eventName: data['event_name'] ?? 'N/A',
                eventDate: data['event_date'] ?? 'N/A',
                venue: data['venue'] ?? 'N/A',
              ));
        });
      } else {
        Get.snackbar(
          "Registration Failed",
          data['message'] ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
