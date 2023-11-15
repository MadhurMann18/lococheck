import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locomotive App',
      home: LocomotiveList(),
    );
  }
}

class LocomotiveList extends StatefulWidget {
  @override
  _LocomotiveListState createState() => _LocomotiveListState();
}

class _LocomotiveListState extends State<LocomotiveList> {
  final List<Locomotive> locomotives = [];
  String searchText = '';
  List<Locomotive> filteredLocomotives = [];
  Locomotive? selectedLocomotive;

  @override
  void initState() {
    super.initState();
    locomotives.addAll([
      Locomotive('Locomotive 1', 'Type A', 500, DateTime(2020, 5, 15), Colors.red),
      Locomotive('Locomotive 2', 'Type B', 600, DateTime(2019, 8, 23), Colors.green),
      // Add more locomotives here...
    ]);
    filteredLocomotives.addAll(locomotives);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locomotive Information'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Type or HP',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                  filteredLocomotives = locomotives
                      .where((loc) =>
                  loc.type.toLowerCase().contains(searchText) ||
                      loc.power.toString().contains(searchText))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocomotives.length,
              itemBuilder: (context, index) {
                final locomotive = filteredLocomotives[index];
                return ListTile(
                  title: Text(locomotive.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${locomotive.type}'),
                      Text('Power: ${locomotive.power} HP'),
                      Row(
                        children: [
                          Text(
                            'Date of Commissioning: ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(locomotive.dateOfCommissioning),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      if (locomotive.selectedDate != null)
                        Text(
                          'Selected Date: ${DateFormat('dd/MM/yyyy').format(locomotive.selectedDate!)}',
                          style: TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  leading: Container(
                    width: 24.0,
                    height: 24.0,
                    color: locomotive.color,
                  ),
                  trailing: DropdownButton<String>(
                    onChanged: (String? value) {
                      setState(() {
                        selectedLocomotive = locomotive;
                        if (value == 'View') {
                          _navigateToEditLocomotive(context, locomotive);
                        }
                      });
                    },
                    value: selectedLocomotive == locomotive ? 'View' : null,
                    items: <String>['View'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToAddLocomotive(context);
            },
            child: Text('PROCEED'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddLocomotive(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddLocomotive(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLocomotive()),
    );

    if (result != null) {
      setState(() {
        locomotives.add(result);
        filteredLocomotives.add(result);
      });
    }
  }

  void _navigateToEditLocomotive(
      BuildContext context, Locomotive locomotive) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditLocomotive(locomotive)),
    );

    if (result != null) {
      setState(() {
        final index =
        locomotives.indexWhere((item) => item.name == locomotive.name);
        locomotives[index] = result;
        final filteredIndex = filteredLocomotives
            .indexWhere((item) => item.name == locomotive.name);
        if (filteredIndex != -1) {
          filteredLocomotives[filteredIndex] = result;
        }
        selectedLocomotive = null;
      });
    }
  }
}

class AddLocomotive extends StatefulWidget {
  @override
  _AddLocomotiveState createState() => _AddLocomotiveState();
}

class _AddLocomotiveState extends State<AddLocomotive> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  DateTime? selectedDate;
  Color selectedColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Locomotive'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Locomotive Name'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Locomotive Type'),
            ),
            TextField(
              controller: powerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Power (HP)'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: TextFormField(
                controller: TextEditingController(
                  text: selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Select Date of Commissioning',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _editDateOfCommissioning(context);
              },
              child: Text('Edit Date'),
            ),
            Row(
              children: [
                Text('Select Color: '),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.red);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.green);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.yellow);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _saveLocomotive();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _editDateOfCommissioning(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _saveLocomotive() {
    final name = nameController.text;
    final type = typeController.text;
    final power = int.tryParse(powerController.text) ?? 0;

    if (name.isNotEmpty && type.isNotEmpty && selectedDate != null) {
      final newLocomotive = Locomotive(name, type, power, selectedDate!, selectedColor);
      Navigator.pop(context, newLocomotive);
    }
  }
}

class EditLocomotive extends StatefulWidget {
  final Locomotive locomotive;

  EditLocomotive(this.locomotive);

  @override
  _EditLocomotiveState createState() => _EditLocomotiveState();
}

class _EditLocomotiveState extends State<EditLocomotive> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  DateTime? selectedDate;
  Color selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.locomotive.name;
    typeController.text = widget.locomotive.type;
    powerController.text = widget.locomotive.power.toString();
    selectedDate = widget.locomotive.dateOfCommissioning;
    selectedColor = widget.locomotive.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Locomotive'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Locomotive Name'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Locomotive Type'),
            ),
            TextField(
              controller: powerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Power (HP)'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: TextFormField(
                controller: TextEditingController(
                  text: selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Select Date of Commissioning',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _editDateOfCommissioning(context);
              },
              child: Text('Edit Date'),
            ),
            Row(
              children: [
                Text('Select Color: '),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.red);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.green);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    _selectColor(Colors.yellow);
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _saveEditedLocomotive();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _editDateOfCommissioning(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _saveEditedLocomotive() {
    final name = nameController.text;
    final type = typeController.text;
    final power = int.tryParse(powerController.text) ?? 0;

    if (name.isNotEmpty && type.isNotEmpty && selectedDate != null) {
      final editedLocomotive = Locomotive(name, type, power, selectedDate!, selectedColor);
      Navigator.pop(context, editedLocomotive);
    }
  }
}

class Locomotive {
  final String name;
  final String type;
  final int power;
  DateTime dateOfCommissioning;
  final DateTime?   selectedDate;
  final Color color;

  Locomotive(this.name, this.type, this.power, this.dateOfCommissioning, this.color, {this.selectedDate});
}
