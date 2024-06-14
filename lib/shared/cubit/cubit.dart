import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p4all/shared/cubit/states.dart';
import 'package:p4all/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/task/task_model.dart';
import '../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database dataBase;

  int bottomBarIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  bool isDarkTheme =(CacheHelper.getDate('isDark')??false);
  bool onBoarding=CacheHelper.getDate('onBoarding')??true ;


  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    bottomBarIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState(bool isShow, IconData icon) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('data base created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('failed to create table');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('data base opened ');
      },
    ).then((value) {
      dataBase = value;
      emit(AppCreateDatabaseState());
    });
  }

  void getDataFromDatabase(database) async {
    emit(AppGetDatabaseLoadingState());
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void insertToDatabase(taskModel model) async {
    await dataBase.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("${model.title}","${model.date}","${model.time}","new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(dataBase);
        print('$value insert success');
      }).catchError((error) {
        print("insert fail ${error.toString()}");
      });
    });
  }

  void updateData(String status, int id) async  {
    dataBase.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['${status}', id],
    ).then((value) {
      getDataFromDatabase(dataBase);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData(int id) {
    dataBase.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]
    ).then((value) {
      getDataFromDatabase(dataBase);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeAppTheme()
  {
    isDarkTheme= !isDarkTheme!;

     CacheHelper.putData( key: 'isDark',value: isDarkTheme!,).then((value) =>emit(AppChangeThemeState()));

  }

}
