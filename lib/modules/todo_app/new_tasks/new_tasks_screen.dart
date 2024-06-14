// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p4all/shared/cubit/cubit.dart';
import 'package:p4all/shared/cubit/states.dart';
import 'package:p4all/shared/styles/colors.dart';

import '../../../shared/components/components.dart';


class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (BuildContext context, state) {

        var tasks = AppCubit.get(context).newTasks;
        return ConditionalBuilder(

          condition: tasks.length>0,

          builder: (BuildContext context) {
            return Container(
              color: color2,
              child: ListView.separated(

                itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
                itemCount: tasks.length,
              ),
            );

          },
          fallback: (BuildContext context) {
            return Center(

              child: Container(
                width: double.infinity,
                color: color2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size:100.0,
                      color: color1,
                    ),
                    Text('No Tasks Yet, Please Add Some Tasks',style: TextStyle(color: color3),),
                  ],
                ),
              ),
            );
          },
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
