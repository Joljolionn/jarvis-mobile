class ItemDto {
  int id;
  String name;
  int num;
  bool completed;

  ItemDto({
    required this.id,
    required this.name,
    required this.num,
    required this.completed,
  });

  factory ItemDto.fromMap(Map<String, dynamic> map) {
    return ItemDto(
      id: map["id"],
      name: map["name"],
      num: map["num"],
      completed: (map['completed'] as int) == 1,
    );
  }
  factory ItemDto.fromServerMap(Map<String, dynamic> map) {
    return ItemDto(
      id: map["id"],
      name: map["name"],
      num: map["num"],
      completed: map["completed"]
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'num': num, 'completed': completed ? 1 : 0};
  }
}
