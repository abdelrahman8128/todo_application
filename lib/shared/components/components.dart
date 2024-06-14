// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';

Widget DefaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  required String text,
  required Function function,
  double radius = 10,
}) {
  return Container(
    width: width,
    height: 40.0,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: () {
        function();
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget DefaultTextFeild({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator validate,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  required String label,
  IconData? prefix,
  Widget? suffix,
  bool obscure = false,
  bool isEnabled = true,
  bool show = false,
  Color color = Colors.white,
  bool readOnly=false,
}) =>
    TextFormField(
      onTap: () {
        onTap!();
      },
      onChanged: (value) {
        onChange!(value);
      },
      enabled: isEnabled,
      controller: controller,
      validator: validate,
      keyboardType: type,

      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      readOnly:readOnly,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color3),

        border: OutlineInputBorder(borderSide: BorderSide(color: color3)),
disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color4)),
        prefixIcon: Icon(prefix,color: color3,),
        suffixIcon: suffix,

      ),
    );

Widget buildTaskItem(
  Map m,
  context,
) =>
    Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            backgroundColor: color1,
            radius: 35,
            child: Text(
              '${m['time']}',
              style: TextStyle(
                fontSize: 13,
                color: color4,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${m['title']}',
                  style: TextStyle(
                    color: color4,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${m['date']}',
                  style: TextStyle(color: color3, fontSize: 15),
                ),
              ],
            ),
          ),
          Visibility(
            visible: m['status'] == 'new',
            child: IconButton(
              tooltip: 'archive',
              onPressed: () {
                AppCubit.get(context).updateData('archived', m['id']);
              },
              icon: Icon(Icons.archive_outlined),
              color: color3,
            ),
          ),
          Visibility(
            visible: m['status'] == 'archived',
            child: IconButton(
              tooltip: 'unarchive',
              onPressed: () {
                AppCubit.get(context).updateData('new', m['id']);
              },
              icon: Icon(Icons.unarchive_outlined),
              color: color3,
            ),
          ),
          Visibility(
            visible: m['status'] != 'done',
            child: IconButton(
              tooltip: 'mark done',
              onPressed: () {
                AppCubit.get(context).updateData('done', m['id']);
              },
              icon: Icon(Icons.done_outline_outlined),
              color: color3,
            ),
          ),
          IconButton(
            tooltip: 'delete task',
            onPressed: () {
              AppCubit.get(context).deleteData(m['id']);
            },
            icon: Icon(Icons.delete_outline),
            color: color3,
          ),
        ],
      ),
    );


void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void showToast(String text) => Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
      fontSize: 16.0,
    );
