import 'package:flutter/material.dart';
import 'finance_lessons.dart';

class DataUploadScreen extends StatefulWidget {
  const DataUploadScreen({Key? key}) : super(key: key);

  @override
  State<DataUploadScreen> createState() => _DataUploadScreenState();
}

class _DataUploadScreenState extends State<DataUploadScreen> {
  bool _isLoading = false;
  String _status = 'Ready to upload data';

  Future<void> _uploadData() async {
    setState(() {
      _isLoading = true;
      _status = 'Uploading data to Firebase...';
    });

    try {
      await FinanceLessonsData.uploadLessonsToFirebase();
      setState(() {
        _status = 'Successfully uploaded all data!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error uploading data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Finance Data')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Finance Data Upload',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      _status.contains('Error')
                          ? Colors.red
                          : _status.contains('Success')
                          ? Colors.green
                          : Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _uploadData,
                    child: const Text('Upload Data to Firebase'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
