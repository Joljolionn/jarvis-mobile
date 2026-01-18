import 'package:flutter/material.dart';
import 'package:jarvis_mobile/screens/widgets/new_item_button.dart';

class Modal extends StatefulWidget {
  final Function(String) onComplete;
  const Modal({super.key, required this.onComplete});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final FocusNode focusNode = FocusNode();
  String _title = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: focusNode.unfocus,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF0EAD42),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [_CloseModalButton()],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Novo item',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'O que vamos comprar hoje?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Nome do produto",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextField(
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          hintText: "Ex: Leite, Pão, Ovos...",
                        ),
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 2,
                        children: [
                          Text("Pressione"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "X",
                              style: TextStyle(
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Text("ou fora do modal para sair rapidamente"),
                        ],
                      ),
                      Column(
                        spacing: 10,
                        children: [
                          PressableButton(
                            backgroundColor: Color(0xFF13ec5b),
                            textColor: Colors.black,
                            title: "Adicionar",
                            onTap: () => {
                              widget.onComplete(_title),
                              Navigator.pop(context),
                            },
                          ),
                          PressableButton(
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            title: "Cancelar",
                            onTap: () => {Navigator.pop(context)},
                          ),
                        ],
                      ),
                    ],
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

class _CloseModalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink(
        height: 35,
        decoration: const ShapeDecoration(
          color: Colors.black26,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.close, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}
