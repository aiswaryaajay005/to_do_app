// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:to_do_app/controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await HomeScreenController.getAllTasks();

      setState(() {});
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text(
            "Todo App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.deepOrange,
          // bottom: TabBar(
          //   tabAlignment: TabAlignment.center,
          //   unselectedLabelColor: Colors.grey,

          //   isScrollable: true,
          //   indicatorPadding: EdgeInsets.zero,
          //   labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   indicator: BoxDecoration(
          //     color: Colors.deepOrange,
          //     borderRadius: BorderRadius.circular(100),
          //   ),
          //   labelColor: Colors.white,
          //   dividerHeight: 0,
          //   indicatorSize: TabBarIndicatorSize.label,
          //   tabs: [
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.deepOrange),
          //         borderRadius: BorderRadius.circular(100),
          //       ),
          //       child: Tab(text: "  All  ", height: 30),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.deepOrange),
          //         borderRadius: BorderRadius.circular(100),
          //       ),
          //       child: Tab(text: "Pending", height: 30),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.deepOrange),
          //         borderRadius: BorderRadius.circular(100),
          //       ),
          //       child: Tab(text: "Completed", height: 30),
          //     ),
          //   ],
          // ),
        ),
        body: Column(children: [SizedBox(height: 10), _buildTaskTiles()]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            _buildBottomSheet(context);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskTiles() {
    return Expanded(
      child: ListView.builder(
        itemCount: HomeScreenController.todoList.length,
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: CheckboxListTile(
                  activeColor: Color(0xff2ecc71),
                  side: BorderSide(color: Color(0xff4a90e2)),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  tileColor:
                      HomeScreenController.checkOverDue(
                                    HomeScreenController
                                        .todoList[index]['date'],
                                  ) ==
                                  "Overdue" &&
                              HomeScreenController.todoList[index]["status"] ==
                                  "pending"
                          ? Color(0xffFDEDEC)
                          : HomeScreenController.checkOverDue(
                                    HomeScreenController
                                        .todoList[index]['date'],
                                  ) ==
                                  "Due Today" &&
                              HomeScreenController.todoList[index]["status"] ==
                                  "pending"
                          ? Color(0xffFFF3E0)
                          : HomeScreenController.checkOverDue(
                                    HomeScreenController
                                        .todoList[index]['date'],
                                  ) ==
                                  "Tomorrow" &&
                              HomeScreenController.todoList[index]["status"] ==
                                  "pending"
                          ? Color(0xffF5F0F7)
                          : HomeScreenController.checkOverDue(
                                    HomeScreenController
                                        .todoList[index]['date'],
                                  ) ==
                                  "Upcoming" &&
                              HomeScreenController.todoList[index]["status"] ==
                                  "pending"
                          ? Color(0xffEAF4FD)
                          : Color(0xfff7f7f7),

                  value:
                      HomeScreenController.todoList[index]["status"] ==
                              "completed"
                          ? true
                          : false,
                  onChanged: (value) async {
                    String newStatus = value! ? "completed" : "pending";
                    await HomeScreenController.updateTask(
                      HomeScreenController.todoList[index]['id'],
                      newStatus,
                    );
                    HomeScreenController.checkOverDue(
                      HomeScreenController.todoList[index]['date'],
                    );
                    setState(() {});
                  },
                  title: Row(
                    children: [
                      Text(
                        HomeScreenController.todoList[index]['task'] ?? "Todo",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff333333),
                          decorationColor: Colors.deepOrange,
                          decoration:
                              HomeScreenController.todoList[index]["status"] ==
                                      "completed"
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      Text(
                        HomeScreenController.todoList[index]["status"] ==
                                "completed"
                            ? ""
                            : " • ",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff4A90E2),
                        ),
                      ),
                      Text(
                        HomeScreenController.todoList[index]["status"] ==
                                "completed"
                            ? ""
                            : HomeScreenController.checkOverDue(
                              HomeScreenController.todoList[index]['date'],
                            ),
                        style: TextStyle(
                          color:
                              HomeScreenController.checkOverDue(
                                        HomeScreenController
                                            .todoList[index]['date'],
                                      ) ==
                                      "Overdue"
                                  ? Color(0xffE74C3C)
                                  : HomeScreenController.checkOverDue(
                                        HomeScreenController
                                            .todoList[index]['date'],
                                      ) ==
                                      "Due Today"
                                  ? Color(0xffFF5722)
                                  : HomeScreenController.checkOverDue(
                                        HomeScreenController
                                            .todoList[index]['date'],
                                      ) ==
                                      "Tomorrow"
                                  ? Color(0xff9B59B6)
                                  : Color(0xff4A90E2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  subtitle:
                      HomeScreenController.todoList[index]["status"] ==
                              "completed"
                          ? SizedBox()
                          : Row(
                            children: [
                              Text(
                                HomeScreenController.todoList[index]['date'],
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                " • ",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xff4A90E2),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  HomeScreenController
                                          .todoList[index]['priority'] ??
                                      "",
                                  style: TextStyle(
                                    color:
                                        HomeScreenController
                                                    .todoList[index]['priority'] ==
                                                "High Priority"
                                            ? Color(0xff8E44AD)
                                            : HomeScreenController
                                                    .todoList[index]['priority'] ==
                                                "Medium Priority"
                                            ? Color(0xff9B59B6)
                                            : HomeScreenController
                                                    .todoList[index]['priority'] ==
                                                "Low Priority"
                                            ? Color(0xffBB8FCE)
                                            : Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _buildBottomSheet(
                                    context,
                                    task: HomeScreenController.todoList[index],
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xff4A90E2),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var taskId =
                                      HomeScreenController
                                          .todoList[index]['id'];
                                  await HomeScreenController.deleteTasks(
                                    taskId,
                                  );
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(0xffE74C3C),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
      ),
    );
  }

  Future<dynamic> _buildBottomSheet(BuildContext context, {Map? task}) {
    bool isEdit = task != null;

    taskController.text = isEdit ? task['task'] : '';
    dateController.text = isEdit ? task['date'] : '';
    HomeScreenController.selectedPriority =
        isEdit ? task['priority'] : HomeScreenController.priorities[3];

    return showModalBottomSheet(
      backgroundColor: Color(0xfff7f7f7),
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 10,
                        children: [
                          const SizedBox(height: 20, width: double.infinity),
                          Text(
                            isEdit ? "Update Task" : "Add New Task",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xff333333)),
                            controller: taskController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff4a90e2),
                                ),
                              ),
                              hintText:
                                  "e.g. Take kids to the park after work tom",
                              hintStyle: TextStyle(color: Color(0xff666666)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff4a90e2),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff4a90e2),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a task";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xff333333)),
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              dateController.text =
                                  await HomeScreenController.onDateSelection(
                                    context,
                                  );
                              setModalState(() {});
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Date",
                              hintStyle: TextStyle(color: Color(0xff666666)),
                              suffixIcon: Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xff4A90E2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff4a90e2),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff4a90e2),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a date";
                              }
                              return null;
                            },
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: HomeScreenController.selectedPriority,
                              style: const TextStyle(
                                color: Color(0xff8E44AD),
                                fontWeight: FontWeight.bold,
                              ),
                              hint: Text(
                                "Select Priority",
                                style: TextStyle(color: Color(0xff666666)),
                              ),
                              iconDisabledColor: Color(0xff4A90E2),
                              iconEnabledColor: Color(0xff4A90E2),
                              items: List.generate(
                                HomeScreenController.priorities.length,
                                (index) => DropdownMenuItem<String>(
                                  value: HomeScreenController.priorities[index],
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        color:
                                            HomeScreenController
                                                .priorityFlags[index],
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        HomeScreenController.priorities[index]
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                HomeScreenController.onPrioritySelection(value);
                                setModalState(() {});
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (isEdit) {
                                  await HomeScreenController.updateTaskDetails(
                                    task: taskController.text,
                                    date: dateController.text,
                                    todoId: task['id'],
                                  );
                                } else {
                                  await HomeScreenController.insertData(
                                    task: taskController.text,
                                    date: dateController.text,
                                  );
                                }
                                taskController.clear();
                                dateController.clear();
                                HomeScreenController.onPrioritySelection(
                                  HomeScreenController.priorities[3],
                                );
                                Navigator.pop(context);
                                setState(() {});
                              }
                            },
                            child: Text(
                              isEdit ? "Update Task" : "Save Task",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
    );
  }
}
