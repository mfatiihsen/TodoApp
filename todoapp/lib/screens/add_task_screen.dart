import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/helpers/database_helper.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/todo_list_screen.dart';

class AddTaskScreen extends StatefulWidget {
  //AddTaskScreen({Key? key, required this.task}) : super(key: key);

  final Function updateTaskList;
  final Task task;

  AddTaskScreen({required this.updateTaskList, required this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _priority = 'Düşük';
  int _status = 0;
  int _id = 0;
  bool _dark = true;

  var value;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  final List<String> _priorities = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id!);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print("$_title,$_date, $_priority");

      Task task = Task(
          title: _title, date: _date, priority: _priority!, status: _status);

      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }

      // Insert the task to our userS'S database
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Geri butonunun yazıldığı kod bloğu
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 10.0,
                    ),
                    // En üstteki görev ekle yazısı
                    Text(
                      // ignore: unnecessary_null_comparison
                      widget.task == null ? 'Görev Oluştur' : 'Görev Güncelle',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                SizedBox(height: 40.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // görev başlığının yazıldığı kod bloğu
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: 'Başlık',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Lütfen görev başlığını giriniz '
                              : null,
                          onSaved: (input) => _title = input!,
                          initialValue: _title,
                        ),
                      ),
                      // Tarih kısmının seçildiği alan
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                              labelText: 'Tarih',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ),
                      // görev zorluğğunun seçildiği bölüm
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                            value: _priority,
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 22.0,
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: _priorities.map((String priority) {
                              return new DropdownMenuItem<String>(
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                                value: priority,
                              );
                            }).toList(),
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Öncelik',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            validator: (input) => _priority == null
                                ? 'Please select a priority level '
                                : null,
                            onChanged: (value) => {
                                  setState(() {
                                    _priority = value as String?;
                                  })
                                }),
                      ),
                      // Butonun olduuğu kod bloğu
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: FlatButton(
                          child: Text(
                            widget.task == null ? 'OLUŞTUR' : 'GÜNCELLE',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.task != null
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: FlatButton(
                                child: Text(
                                  "SİL",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                onPressed: _delete,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
