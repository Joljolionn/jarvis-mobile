import 'package:flutter/material.dart';
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

  void changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Compras"), titleSpacing: 20),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar item...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: PressableButton(
                backgroundColor: Color(0xFF13ec5b),
                textColor: Colors.black,
                title: '+ Novo item',

                onTap: () => showDialog(
                  context: context,

                  builder: (BuildContext context) {
                    return Modal();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
