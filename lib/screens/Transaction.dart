import 'package:flutter/material.dart';
import 'models/notes_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'noResult.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

final _formKey = GlobalKey<FormState>();

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  bool isloading = true;
  List<dynamic> pendingTrans = [];
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _reloadPage() async {
    setState(() {});
    await fetchData();
  }

  Future<List> fetchPendingTranscation() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/delay-transcation?is_pending=True'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isloading = false;
        pendingTrans = data;
      });
      print(data);
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }

  Future<void> fetchData() async {
    List<dynamic> result = await fetchPendingTranscation();
    setState(() {
      data = result;
    });
  }

  DateTime? _date = DateTime.now();

  void updateSelectedDate(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  _showEditDialog(data) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDialog(
          initialDate: DateTime.now(),
          onDateSelected: updateSelectedDate,
          data: data,
        );
      },
    );
    print(result);
    if (result != null) {
      setState(() {
        _date = result;
      });
    }
  }

  _showAddMyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDialog(
          initialDate: DateTime.now(),
          onDateSelected: updateSelectedDate,
        );
      },
    );
    print(result);
    if (result != null) {
      setState(() {
        _date = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showAddMyDialog();
            _reloadPage();
          },
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.grey[300],
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Transaction",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                      ),
                      controller: tabController,
                      tabs: const [
                        Text(
                          "INCOMING",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          "OUTGOING",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      isloading
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                          : result(),
                      notesStarred(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  result() {
    if (data == []) {
      return NoResult();
    } else {
      return ValueListenableBuilder<List<dynamic>>(
        valueListenable: ValueNotifier(data),
        builder: (context, dataList, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            child: ListView.builder(
                itemCount: dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  data[index]['name'].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  data[index]['amount'].toString() + " /Rs",
                                  style: TextStyle(
                                      color: Colors.blue[500], fontSize: 12),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () async {
                                      await _showEditDialog(data[index]);
                                      _reloadPage();
                                    },
                                    child: Icon(Icons.edit)),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await deleteTranscationData(
                                        data[index]['id']);
                                    _reloadPage();
                                  },
                                  child: Icon(
                                    Icons.done_all,
                                    color: Colors.redAccent[200],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data[index]['deadline'].toString(),
                              style: TextStyle(
                                  color: Colors.red[200], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      );
    }
  }

  Future<void> deleteTranscationData(int id) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://shamhadchoudhary.pythonanywhere.com/api/store/update-delay-transcation/$id'));
      if (response.statusCode == 204) {
        print('Data with ID $id deleted successfully');
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}

// #########
Future<void> deleteitem(NotesModel notesModel) async {
  await notesModel.delete();
}

class notesStarred extends StatefulWidget {
  const notesStarred({Key? key}) : super(key: key);

  @override
  State<notesStarred> createState() => _notesStarredState();
}

class _notesStarredState extends State<notesStarred> {
  bool isloading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _reloadPage() async {
    setState(() {});
    await fetchData();
  }

  Future<List> fetchToDOTranscation() async {
    final response = await http.get(Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/delay-transcation?is_pending=False'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isloading = false;
      });
      return data;
      print(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }

  Future<void> fetchData() async {
    List<dynamic> result = await fetchToDOTranscation();
    setState(() {
      data = result;
    });
  }

  DateTime? _date = DateTime.now();

  void updateSelectedDate(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  _showEditDialog(data) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDialog(
          initialDate: DateTime.now(),
          onDateSelected: updateSelectedDate,
          data: data,
        );
      },
    );
    print(result);
    if (result != null) {
      setState(() {
        _date = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : result();
  }

  result() {
    if (data == []) {
      return NoResult();
    } else {
      return ValueListenableBuilder<List<dynamic>>(
        valueListenable: ValueNotifier(data),
        builder: (context, dataList, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            child: ListView.builder(
                itemCount: dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data[index]['name'].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  data[index]['amount'].toString() + " /Rs",
                                  style: TextStyle(
                                      color: Colors.blue[500], fontSize: 12),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () async {
                                      await _showEditDialog(data[index]);
                                      _reloadPage();
                                    },
                                    child: Icon(Icons.edit)),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await deleteTranscationData(
                                        data[index]['id']);
                                    _reloadPage();
                                  },
                                  child: Icon(
                                    Icons.done_all,
                                    color: Colors.redAccent[200],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data[index]['deadline'].toString(),
                              style: TextStyle(
                                  color: Colors.red[200], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      );
    }
  }

  Future<void> deleteTranscationData(int id) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://shamhadchoudhary.pythonanywhere.com/api/store/update-delay-transcation/$id'));
      if (response.statusCode == 204) {
        print('Data with ID $id deleted successfully');
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}

//
// # http://127.0.0.1:8000/api/store/delay-transcation?id=3
// # http://127.0.0.1:8000/api/store/delay-transcation?is_pending=True
// path('update-delay-transcation/<str:pk>', TranscationUpdateView.as_view()),
// # http://127.0.0.1:8000/api/store/update-delay-transcation/3

class EditDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final Map<String, dynamic> data;

  EditDialog(
      {required this.initialDate,
      required this.onDateSelected,
      required this.data});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  DateTime? _selectedDate;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  bool? _isPending;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _isPending = widget.data['is_pending'];
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.data['name'];
    descriptionController.text = widget.data['description'];
    amountController.text = widget.data['amount'].toString();
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Edit Date'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter Name or Leave Empty",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the name';
                  } else if (value.length > 10)
                    return "Input limit exceeded";
                  else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter proper name";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter correct description';
                  } else if (value.length > 10)
                    return "Input limit exceeded";
                  else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter proper description";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: InputDecoration(
                    hintText: "Enter Amount in Rs..",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Amount Correctly';
                  } else if (value.length > 10)
                    return "Limit exceeded";
                  else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter the integer";

                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                child: CheckboxListTile(
                  title: Text('INCOMING'),
                  value: _isPending,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPending = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      print(picked);
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              nameController.clear();
              descriptionController.clear();
              amountController.clear();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Update'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.onDateSelected != null) {
                  widget.onDateSelected(_selectedDate!);
                }
                updateTranscationData(widget.data['id']);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateTranscationData(int id) async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/update-delay-transcation/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "name": nameController.text,
      "description": descriptionController.text,
      "amount": amountController.text,
      "is_pending": _isPending,
      "deadline": _selectedDate.toString().split(' ')[0]
    });
    print(body);

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // request successful
      print(response.body);
    } else {
      // request failed
      print(response.reasonPhrase);
    }
  }
}

class AddDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  AddDialog({required this.initialDate, required this.onDateSelected});

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  DateTime? _selectedDate;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  bool _isPending = true;

  String _inputvalue3 = " ";
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Edit Date'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter Name or Leave Empty",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the name';
                  } else if (value.length > 10)
                    return "Input limit exceeded";
                  else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter the proper name";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the description';
                  } else if (value.length > 10)
                    return "Input limit exceeded";
                  else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter the proper description";
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: InputDecoration(
                    hintText: "Enter Amount in Rs..",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Amount Correctly';
                  } else if (value.length > 10)
                    return "Limit exceeded";
                  else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value!))
                    return "Enter integer";

                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                child: CheckboxListTile(
                  title: Text('INCOMING'),
                  value: _isPending,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPending = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      print(picked);
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                          // if (widget.onDateSelected != null) {
                          //   widget.onDateSelected!(_selectedDate!);
                          // }
                        });
                      }
                    },
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              nameController.clear();
              descriptionController.clear();
              amountController.clear();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.onDateSelected != null) {
                  widget.onDateSelected(_selectedDate!);
                }
                postTranscationData();
                // if (_formKey.currentState!.validate()) {
                //   // updateTranscationData(data['id']);
                //   // updateTranscationData(data['id']);
                //   nameController.clear();
                //   descriptionController.clear();
                //   nameController.clear();
                //   descriptionController.clear();
                //   amountController.clear();
                // }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> postTranscationData() async {
    final url = Uri.parse(
        'https://shamhadchoudhary.pythonanywhere.com/api/store/delay-transcation');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "name": nameController.text,
      "description": descriptionController.text,
      "amount": amountController.text,
      "is_pending": _isPending,
      "deadline": _selectedDate.toString().split(' ')[0],
    });
    print(body);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // request successful
      print(response.body);
    } else {
      // request failed
      print(response.reasonPhrase);
    }
  }
}
