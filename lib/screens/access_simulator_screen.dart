// lib/screens/access_simulator_screen.dart
import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../models/access_result.dart';
import '../services/data_service.dart';
import '../widgets/room_rules_card.dart';
import '../widgets/simulation_button.dart';
import 'results_screen.dart';
import 'employees_screen.dart';

class AccessSimulatorScreen extends StatefulWidget {
  const AccessSimulatorScreen({Key? key}) : super(key: key);

  @override
  State<AccessSimulatorScreen> createState() => _AccessSimulatorScreenState();
}

class _AccessSimulatorScreenState extends State<AccessSimulatorScreen> {
  List<Employee> employees = [];
  List<AccessResult> simulationResults = [];
  bool isLoading = true;
  bool isSimulated = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final List<Employee> loadedEmployees = await DataService.loadEmployeeData();

      setState(() {
        employees = loadedEmployees;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _runSimulation() {
    if (employees.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    // Simulate some processing time
    Future.delayed(const Duration(milliseconds: 800), () {
      final List<AccessResult> results = DataService.simulateEmployeeAccess(employees);

      setState(() {
        simulationResults = results;
        isSimulated = true;
        isLoading = false;
      });

      // Navigate to results screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(results: results),
        ),
      );
    });
  }

  void _resetSimulation() {
    setState(() {
      simulationResults = [];
      isSimulated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Access Simulator'),
        centerTitle: true,
        actions: [
          // View Employees Button
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmployeesScreen(
                    employees: employees,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onRetry: _loadEmployeeData,
                  ),
                ),
              );
            },
            tooltip: 'View Employees',
          ),
          if (isSimulated)
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultsScreen(results: simulationResults),
                  ),
                );
              },
              tooltip: 'View Results',
            ),
          if (isSimulated)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetSimulation,
              tooltip: 'Reset Simulation',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Room Rules Section
              const RoomRulesCard(),

              // View Employees Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EmployeesScreen(
                          employees: employees,
                          isLoading: isLoading,
                          errorMessage: errorMessage,
                          onRetry: _loadEmployeeData,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people),
                  label: Text(
                    employees.isEmpty
                        ? 'View Employee List'
                        : 'View Employees (${employees.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.indigo[300]!),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              // Quick Status Card
              if (!isLoading)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: employees.isEmpty ? Colors.orange[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: employees.isEmpty ? Colors.orange[200]! : Colors.green[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        employees.isEmpty ? Icons.warning : Icons.check_circle,
                        color: employees.isEmpty ? Colors.orange[600] : Colors.green[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          employees.isEmpty
                              ? 'No employees loaded. Check employee data.'
                              : '${employees.length} employees ready for simulation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: employees.isEmpty ? Colors.orange[700] : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Simulation Button
              SimulationButton(
                onPressed: _runSimulation,
                isLoading: isLoading && !isSimulated,
                isSimulated: isSimulated,
              ),

              // Quick Results Summary (if simulated)
              if (isSimulated)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo[50]!, Colors.indigo[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in, color: Colors.indigo[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Simulation Complete!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultsScreen(results: simulationResults),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Detailed Results'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo,
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),

              // Loading State
              if (isLoading && !isSimulated)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading employees...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              // Error State
              if (errorMessage != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadEmployeeData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
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
}