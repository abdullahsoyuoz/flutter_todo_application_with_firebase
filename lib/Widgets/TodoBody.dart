import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Services/todoService.dart';
import 'package:todo_app/Widgets/TodoBottomNavigation.dart';
import 'package:todo_app/Widgets/TodoDataWidget.dart';
import 'package:todo_app/Util/utility.dart';

class TodoBody extends StatefulWidget {
  @override
  _TodoBodyState createState() => _TodoBodyState();
}

class _TodoBodyState extends State<TodoBody> {
  @override
  void initState() {
    super.initState();
    todoService.fetchData();
    todoService.syncListFromFetch();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(fit: StackFit.expand, children: [
        Consumer<TodoService>(
          builder: (context, value, child) {
            return RefreshIndicator(
              key: GlobalKey<RefreshIndicatorState>(),
              onRefresh: value.fetchData,
              color: Theme.of(context).colorScheme.red,
              backgroundColor: Theme.of(context).primaryColor,
              displacement: getSize(context).size.height * 0.16,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: getSize(context).size.height * 0.16,
                    bottom: getSize(context).size.height * 0.12),
                itemCount: value.currentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return TodoDataWidget(value.currentList[index]);
                },
              ),
            );
          },
        ),
        TodoBottomNavigation()
      ]),
    );
  }
}
