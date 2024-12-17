import 'package:equatable/equatable.dart';

class Entry extends Equatable {
  final int? id;
  final String name;
  final String path;
  final bool isDeleted;

  const Entry({
    this.id,
    required this.name,
    required this.path,
    required this.isDeleted,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      isDeleted: json['isDeleted'] == 1 ? true : false,
    );
  }

  Entry deleteFile() {
    return Entry(id: id, name: name, path: path, isDeleted: true);
  }

  Entry copywithId(int id) {
    return Entry(id: id, name: name, path: path, isDeleted: false);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        path,
        isDeleted,
      ];
}
