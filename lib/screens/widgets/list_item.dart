import 'package:flutter/material.dart';
import 'package:jarvis_mobile/data/dtos/item_dto.dart';

class ListItem extends StatefulWidget {
  final ItemDto item;
  final Function(int) toggleCompletedItem;
  final Function(int) addNumItem;
  final Function(int) subNumItem;
  final Function(int) deleteItem;

  const ListItem({
    super.key,
    required this.item,
    required this.toggleCompletedItem,
    required this.addNumItem,
    required this.subNumItem,
    required this.deleteItem,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    Transform.scale(
                    scale: 1.3,
                      child: Checkbox(
                        value: widget.item.completed,
                        onChanged: (bool? value) {
                          widget.toggleCompletedItem(widget.item.id);
                        },
                        side: const BorderSide(color: Colors.grey, width: 2),
                        activeColor: const Color(0xFF0EAD42),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.06),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),

                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      widget.subNumItem(widget.item.id);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${widget.item.num}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.all(4),
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      widget.addNumItem(widget.item.id);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            widget.deleteItem(widget.item.id);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
