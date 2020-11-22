import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Model/todo.dart';
import 'package:todo_app/Services/todoService.dart';
import 'package:todo_app/Util/utility.dart';

// ignore: must_be_immutable
class TodoDataWidget extends StatelessWidget {
  Todo item;
  TodoDataWidget(this.item);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(debugLabel: item.content),
      background: dismissBackWidget(context),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text("Silmek üzeresin \u{1F914}"),
                content: Text(item.content),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Provider.of<TodoService>(context).remove(item, context);
                      Navigator.of(context).pop();
                    },
                    child: Text("Sil"),
                    color: Theme.of(context).colorScheme.red,
                  )
                ],
              );
            },
          );
          todoService.fetchData();
          FocusScope.of(context).unfocus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: getSize(context).size.height * 0.0105,
          left: getSize(context).size.height * 0.03,
          right: getSize(context).size.height * 0.03,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            todoContent(item, context),
            todoIsCompleted(item, context)
          ],
        ),
      ),
    );
  }

  todoContent(Todo item, BuildContext context) {
    DateTime time = item.time.toDate().toUtc();
    int fark = DateTime.now().difference(time).inDays;

    return Flexible(
      fit: FlexFit.tight,
      flex: 4,
      child: InkWell(
        child: Container(
          padding:
              EdgeInsets.only(left: getSize(context).size.height * 0.07 / 3),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(getSize(context).size.height * 0.07 / 2),
            color: item.isCompleted == true
                ? Theme.of(context).backgroundColor
                : Theme.of(context).accentColor,
          ),
          height: getSize(context).size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: item.isCompleted == true
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: getSize(context).size.height * 0.07 / 3),
                child: Text(
                  fark == 0
                      ? "Bugün"
                      : fark == 1
                          ? "Dün"
                          : fark == 2
                              ? "Evvelsi gün"
                              : "$fark gün önce",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
        ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onLongPress: () {
          // showModalBottomSheet(
          //     backgroundColor:
          //         Theme.of(context).backgroundColor.withOpacity(0.5),
          //     builder: (context) {
          //       return Center(
          //           child: Container(
          //         child: Text("content showModalBottomSheet"),
          //       ));
          //     },
          //     context: context);
        },
      ),
    );
  }

  todoIsCompleted(Todo item, BuildContext context) {
    return Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: InkWell(
          key: GlobalKey(debugLabel: item.toString()),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: item.isCompleted == true
                    ? Theme.of(context).colorScheme.green
                    : Theme.of(context).colorScheme.red),
            height: getSize(context).size.height * 0.07,
            width: getSize(context).size.height * 0.07,
          ),
          highlightColor: item.isCompleted == true
              ? Theme.of(context).colorScheme.green.withOpacity(0.5)
              : Theme.of(context).colorScheme.red.withOpacity(0.5),
          splashColor: Colors.transparent,
          onDoubleTap: () {
            Provider.of<TodoService>(context).updateIsComplete(item, context);
          },
          onLongPress: () {
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return AlertDialog(
            //       backgroundColor: Theme.of(context).accentColor,
            //       title: Text("Silmek üzeresin \u{1F914}"),
            //       content: Text(item.content),
            //       actions: [
            //         FlatButton(
            //           onPressed: () {
            //             Provider.of<TodoService>(context).remove(item, context);
            //             Navigator.of(context).pop();
            //           },
            //           child: Text("Sil"),
            //           color: Theme.of(context).colorScheme.red,
            //         )
            //       ],
            //     );
            //   },
            // );
          },
        ));
  }

  dismissBackWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(context).size.height * 0.03),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.red,
          ),
        ),
      ),
    );
  }
}
