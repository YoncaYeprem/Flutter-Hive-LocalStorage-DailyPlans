import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'daily_task.g.dart';

@HiveType(typeId: 1)
class DailyTask extends HiveObject{
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String content;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isDone;

  DailyTask({ required this.id,required this.content,required this.createdAt,required this.isDone});

  factory DailyTask.create({required String content,required DateTime createdAt}){
    return DailyTask(id: const Uuid().v1(), content: content, createdAt: createdAt, isDone: false );
  }
  
}