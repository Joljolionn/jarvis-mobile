import 'package:flutter/material.dart';
import 'package:jarvis_mobile/data/db_helper.dart';
import 'package:jarvis_mobile/data/dtos/item_dto.dart';
import 'package:jarvis_mobile/screens/widgets/modal.dart';
import 'package:jarvis_mobile/screens/widgets/new_item_button.dart';
import 'package:jarvis_mobile/screens/widgets/sliding_filter.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _selectedFilter = "all";
  List<ItemDto>? items;
  DbHelper dbHelper = DbHelper();
  void receiveItems() async {
    final fetchedItems = await dbHelper.items();
    setState(() {
      items = fetchedItems;
    });
  }

  void addItem(String title) async {
    await dbHelper.insertItem(
      ItemDto(id: null, name: title, num: 1, completed: false),
    );
    final updatedItems = await dbHelper.items();
    setState(() {
      items = updatedItems;
    });
  }

  void changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  void initState() {
    receiveItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        animateColor: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Lista de Compras"),
        titleSpacing: 20,
        scrolledUnderElevation: 0,
        elevation: 10,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar item...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        items
                            ?.map(
                              (item) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("id: ${item.id}"),
                                      Text("name: ${item.name}"),
                                      Text("num: ${item.num}"),
                                      Text(
                                        "Completed? ${item.completed ? 'true' : 'false'}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
