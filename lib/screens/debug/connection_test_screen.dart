import 'package:flutter/material.dart';
import '../../utils/connection_tester.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({Key? key}) : super(key: key);

  @override
  _ConnectionTestScreenState createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _results;
  String? _error;

  Future<void> _runTests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ConnectionTester.runDiagnostics();
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
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
      appBar: AppBar(
        title: const Text('API Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This screen helps verify the connection between your Flutter app and Laravel backend.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _runTests,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Run Connection Tests'),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_error!),
                  ],
                ),
              ),
            ] else if (_results != null) ...[
              Text(
                'Test Results:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('Base URL: ${_results!['baseUrl']}'),
              const SizedBox(height: 8),
              Text(
                'Tests:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._results!['tests'].entries.map((entry) {
                return Row(
                  children: [
                    Icon(
                      entry.value ? Icons.check_circle : Icons.error,
                      color: entry.value ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key),
                  ],
                );
              }).toList(),
              if (_results!.containsKey('testResponse')) ...[
                const SizedBox(height: 16),
                Text(
                  'API Response:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(_results!['testResponse']),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
