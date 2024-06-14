// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p4all/models/task/task_model.dart';
import 'package:p4all/shared/components/components.dart';
import 'package:p4all/shared/cubit/cubit.dart';
import 'package:p4all/shared/cubit/states.dart';
import '../../shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          print(state.toString());
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(

            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: color2,
              title: Text(
                '${cubit.titles[cubit.bottomBarIndex]}',
                style: TextStyle(
                  color: color3,

                ),
              ),
            ),
            body: ConditionalBuilder(

              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.bottomBarIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(
                  color: color1,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon,color: color4,),
              backgroundColor: color1,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(taskModel(titleController.text,
                        timeController.text, dateController.text));
                    cubit.changeBottomSheetState(false, Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: color2,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,

                            child: Column(

                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultTextFeild(

                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value.isEmpty || value == null) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultTextFeild(
                                  onTap: () {
                                    showTimePicker(

                                      context: context,
                                      initialTime: TimeOfDay.now(),

                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value.isEmpty || value == null) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DefaultTextFeild(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2999),
                                      initialDate: DateTime.now(),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMEd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(false, Icons.edit);
                  });
                  cubit.changeBottomSheetState(true, Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.bottomBarIndex,
                onTap: (index) {
                  cubit.changeIndex(index);

                },
                selectedItemColor: color3,
                backgroundColor: color2,
                unselectedItemColor: color1,



                items: [

                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                    activeIcon: Icon(Icons.menu_outlined),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.checkmark_alt_circle),
                    label: 'Done',
                    activeIcon: Icon(CupertinoIcons.checkmark_alt_circle_fill),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                    activeIcon: Icon(Icons.archive),
                  ),
                ]

            ),
          );
        },
      ),
    );
  }
}
