import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../models/access_result.dart';
import '../services/data_service.dart';
import '../widgets/employee_card.dart';
import '../widgets/room_rules_card.dart';
import '../widgets/simulation_button.dart';

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
          if (isSimulated)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetSimulation,
              tooltip: 'Reset Simulation',
            ),
        ],
      ),
      body: Column(
        children: [
          // Room Rules Section
          const RoomRulesCard(),

          // Simulation Button
          SimulationButton(
            onPressed: _runSimulation,
            isLoading: isLoading && !isSimulated,
            isSimulated: isSimulated,
          ),

          // Results Section
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (isLoading && employees.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading employee data...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEmployeeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (employees.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No Employee Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No employee requests found to simulate.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Section Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isSimulated ? Icons.assignment_turned_in : Icons.people,
                    color: Colors.indigo[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isSimulated
                          ? 'Simulation Results'
                          : 'Employee Requests',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  Text(
                    '${isSimulated ? simulationResults.length : employees.length} requests',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (isSimulated) ...[
                const SizedBox(height: 8),
                _buildResultsSummary(),
              ],
            ],
          ),
        ),

        // Employee List
        Expanded(
          child: ListView.builder(
            itemCount: isSimulated ? simulationResults.length : employees.length,
            itemBuilder: (context, index) {
              if (isSimulated) {
                final AccessResult result = simulationResults[index];
                return EmployeeCard(
                  employee: result.employee,
                  result: result,
                  showResult: true,
                );
              } else {
                return EmployeeCard(employee: employees[index]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSummary() {
    if (!isSimulated || simulationResults.isEmpty) {
      return const SizedBox.shrink();
    }

    final int grantedCount = simulationResults.where((r) => r.granted).length;
    final int deniedCount = simulationResults.length - grantedCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryChip(
            icon: Icons.check_circle,
            label: 'Granted',
            count: grantedCount,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          _buildSummaryChip(
            icon: Icons.cancel,
            label: 'Denied',
            count: deniedCount,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}