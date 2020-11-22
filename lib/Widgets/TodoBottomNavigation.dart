import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Services/firestoreAuthService.dart';
import 'package:todo_app/Services/todoService.dart';
import 'package:todo_app/Model/todo.dart';
import 'package:todo_app/Util/utility.dart';

class TodoBottomNavigation extends StatefulWidget {
  @override
  _TodoBottomNavigationState createState() => _TodoBottomNavigationState();
}

class _TodoBottomNavigationState extends State<TodoBottomNavigation> {
  TextEditingController _searchController;
  FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    // bu ibne
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    _searchFocusNode.requestFocus();
    return Padding(
      padding: EdgeInsets.only(
        bottom: getSize(context).size.height * 0.03,
        left: getSize(context).size.height * 0.03,
        right: getSize(context).size.height * 0.03,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: Theme.of(context).primaryColor),
                height: getSize(context).size.height * 0.07,
                child:
                    todoSearchBar(context, _searchController, _searchFocusNode),
              ),
            ),
            todoAddButton(context, _searchController)
          ],
        ),
      ),
    );
  }

  todoAddButton(
    BuildContext context,
    TextEditingController _searchController,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(context).padding.top * 0.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColor),
        height: getSize(context).size.height * 0.07,
        width: getSize(context).size.height * 0.07,
        child: InkWell(
          child: Icon(Icons.add, color: Theme.of(context).backgroundColor),
          onTap: _onAdd,
        ),
      ),
    );
  }

  todoSearchBar(BuildContext context, TextEditingController _contentController,
      FocusNode searchFocusNode) {
    return Container(
      child: TextField(
        focusNode: searchFocusNode,
        maxLines: 1,
        controller: _contentController,
        textDirection: TextDirection.ltr,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            suffix: IconButton(
              focusNode: _searchFocusNode,
              iconSize: getSize(context).size.height * 0.03,
              icon: Icon(Icons.clear, color: Theme.of(context).accentColor),
              onPressed: () {
                setState(() {
                  _contentController.clear();
                });
              },
            ),
            isDense: false,
            hintText: "Ara veya Oluştur ?",
            contentPadding:
                EdgeInsets.only(left: getSize(context).size.height * 0.03),
            hintStyle: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.4),
                fontSize: getSize(context).size.height * 0.03),
            border: InputBorder.none),
        showCursor: false,
        style: GoogleFonts.catamaran(
            textStyle: TextStyle(color: Theme.of(context).backgroundColor),
            fontWeight: FontWeight.w200,
            decoration: TextDecoration.none,
            fontSize: 20),
      ),
    );
  }

  void _onAdd() {
    if (_searchController.text.isNotEmpty) {
      Todo newItem = Todo(
          _searchController.text[0].toUpperCase() +
              _searchController.text.substring(1),
          false,
          Timestamp.now(),
          firebaseAuthService.auth.currentUser.uid);
      Provider.of<TodoService>(context).create(newItem, context);
      FocusScope.of(context).unfocus();
      _searchController.clear();
    }
  }

  void _onSearchChanged() {
    print(_searchController.text + "--------------");
    var toRemove = []; // because of _GrowableList error
    todoService.syncListFromFetch();
    if (_searchController.text.isEmpty) {
      todoService.queryResultList.clear();
      todoService.syncListFromFetch();
      todoService.fetchData(isQuery: true);
    }
    if (_searchController.text.isNotEmpty) {
      todoService.currentList.forEach((element) {
        var content = element.content.toLowerCase();

        if (content.contains(_searchController.text.toLowerCase())) {
          if (!todoService.queryResultList.contains(element)) {
            todoService.queryResultList.add(element);
          }
        }

        if (!content.contains(_searchController.text.toLowerCase())) {
          toRemove.add(element);
        }
      });

      todoService.queryResultList
          .removeWhere((element) => toRemove.contains(element));
      todoService.queryResultList.forEach((element) {
        print(element.content);
      });
      toRemove.clear();
      todoService.currentList = todoService.queryResultList;
      //todoService.queryResultList.clear();
      todoService.fetchData(isQuery: true);
    }
  }
}
