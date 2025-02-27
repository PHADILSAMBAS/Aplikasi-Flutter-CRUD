import 'package:flutter/material.dart';
import 'package:phadil_e_2106176/services/api_service.dart';

class TambahSalesPage extends StatefulWidget {
  const TambahSalesPage({super.key});

  @override
  State<TambahSalesPage> createState() => _TambahSalesPageState();
}

class _TambahSalesPageState extends State<TambahSalesPage> {
  final _formKey = GlobalKey<FormState>();
  final _salesBuyerController = TextEditingController();
  final _salesPhoneController = TextEditingController();
  final _salesDateController = TextEditingController();
  final _salesStatusController = TextEditingController();
  String? _selectedStatus; // Variabel untuk menyimpan nilai yang dipilih
  final List<String> _statuses = [
    'Order',
    'Pending',
    'Proses',
    'Selesai',
    'Batal'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Add Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _salesBuyerController,
                  decoration: InputDecoration(
                    labelText: 'Buyer Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Buyer Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _salesPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Phone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _salesDateController,
                  decoration: InputDecoration(
                    labelText: 'Sales Date',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _salesDateController.text =
                            "${pickedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Sales Date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey.shade300,
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: _statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                      _salesStatusController.text = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Status';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var response = await ApiService().createSales(
                            _salesBuyerController.text,
                            _salesPhoneController.text,
                            _salesDateController.text,
                            _salesStatusController.text);
                        print(
                            'Sales created successfully: ${response.statusCode}');
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text('Sales created successfully'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        print('Error creating Sales: $e');
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Failed'),
                              content: Text('Sales creation failed'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Add Sales'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
