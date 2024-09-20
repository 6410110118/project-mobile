// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
class Trip extends Equatable{
  final int id;
  final String imageUrl;
  final String tripName;
  final String description;
  final DateTime? endtime;
  final bool role;
  final bool isDone;
  final DateTime? doneTime;



  const Trip({
    required this.id,
    required this.imageUrl,
    required this.tripName,
    required this.description,
    required this.endtime,
    this.role = false,
    this.isDone = false,

    this.doneTime,
  });

  bool get islate => endtime != null && DateTime.now().isAfter(endtime!);
  @override
  List<Object?> get props => [id, imageUrl, tripName, description,endtime, role, isDone, doneTime];

  Trip copyWith({
    int? id,
    String? imageUrl,
    String? tripName,
    String? description,
    DateTime? endtime,
    bool? role,
    bool? isDone,
    DateTime? doneTime,
  }){
    return Trip(
      id: id?? this.id,
      imageUrl: imageUrl?? this.imageUrl,
      tripName: tripName?? this.tripName,
      description: description ?? this.description,
      endtime: endtime?? this.endtime,
      role: role?? this.role,
      isDone: isDone?? this.isDone,
      doneTime: doneTime?? this.doneTime,
    );
  }
}
