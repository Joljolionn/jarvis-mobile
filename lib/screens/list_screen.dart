import 'package:flutter/material.dart';
import 'package:jarvis_mobile/data/db_helper.dart';
import 'package:jarvis_mobile/data/dtos/item_dto.dart';
import 'package:jarvis_mobile/screens/widgets/list_item.dart';
import 'package:jarvis_mobile/screens/widgets/modal.dart';
import 'package:jarvis_mobile/screens/widgets/new_item_button.dart';
import 'package:jarvis_mobile/screens/widgets/sliding_filter.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  FocusNode focusNode = FocusNode();
  String _selectedFilter = "all";
  String _search = "";
  List<ItemDto>? allItems;
  List<ItemDto>? filteredItems;
  DbHelper dbHelper = DbHelper();
  void receiveItems() async {
    final fetchedItems = await dbHelper.getAllItems();
    setState(() {
      allItems = fetchedItems;
      filteredItems = allItems;
    });
  }

  void addItem(String title) async {
    if (title.isEmpty) return;
    await dbHelper.insertItem(title);
    final updatedItems = await dbHelper.getAllItems();
    setState(() {
      allItems = updatedItems;
      filterSearch();
    });
  }

  void deleteItem(int id) async {
    final int rowsAffected = await dbHelper.deleteItem(id);
    if (rowsAffected == 1) {
      setState(() {
        allItems = allItems!.where((item) => item.id != id).toList();
        filterSearch();
      });
    }
  }

  void subNumItem(int id) async {
    final index = allItems!.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final item = allItems![index];
    if (item.num <= 1) return;

    int rowsAffected = await dbHelper.updateNumItem(id, item.num - 1);

    if (rowsAffected == 1) {
      setState(() {
        item.num -= 1;
      });
    }
  }

  void addNumItem(int id) async {
    final index = allItems!.indexWhere((item) => item.id == id);
    if (index == -1) return;
    final item = allItems![index];
    int rowsAffected = await dbHelper.updateNumItem(id, item.num + 1);
    if (rowsAffected == 1) {
      setState(() {
        item.num += 1;
      });
    }
  }

  void toggleCompletedItem(int id) async {
    final index = allItems!.indexWhere((item) => item.id == id);
    final item = allItems![index];
    int rowsAffected = await dbHelper.toggleCompletedItem(
      item.id,
      !item.completed,
    );
    if (rowsAffected == 1) {
      setState(() {
        item.completed = !item.completed;
      });
    }
  }

  void changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      filterSearch();
    });
  }

  void changeSearch(String search) {
    setState(() {
      _search = search;
      filterSearch();
    });
  }

  void filterSearch() {
    setState(() {
      if (allItems == null) return;

      filteredItems = allItems!.where((item) {
        final matchesName = item.name.toLowerCase().contains(
          _search.toLowerCase(),
        );

        bool matchesStatus = true;
        if (_selectedFilter == "pending") {
          matchesStatus = item.completed == false;
        } else if (_selectedFilter == "completed") {
          matchesStatus = item.completed == true;
        }

        return matchesName && matchesStatus;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    receiveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        animateColor: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Lista de Compras",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        titleSpacing: 20,
        scrolledUnderElevation: 0,
        elevation: 10,
        surfaceTintColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: focusNode.unfocus,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    onChanged: (String search) {
                      changeSearch(search);
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Buscar item...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF0EAD42),
                        ),
                      ),
                    ),
                  ),
                ),
                SlidingFilter(
                  selectedFilter: _selectedFilter,
                  onTap: (String filter) {
                    changeFilter(filter);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: PressableButton(
                    backgroundColor: Color(0xFF13ec5b),
                    textColor: Colors.black,
                    title: '+ Novo item',

                    onTap: () => showDialog(
                      context: context,

                      builder: (BuildContext context) {
                        return Modal(
                          onComplete: (title) {
                            addItem(title);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Row(children: [Text("ITENS (${filteredItems?.length ?? 0})")]),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        spacing: 20,
                        children:
                            filteredItems
                                ?.map(
                                  (item) => ListItem(
                                    item: item,
                                    toggleCompletedItem: (int id) {
                                      toggleCompletedItem(id);
                                    },
                                    addNumItem: (int id) {
                                      addNumItem(id);
                                    },
                                    subNumItem: (int id) {
                                      subNumItem(id);
                                    },
                                    deleteItem: (int id) {
                                      deleteItem(id);
                                    },
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
