class TaskModel{
  String? id;
  String? task;
  bool? status;
  TaskModel({ required this.task, required this.status});
  factory TaskModel.fromDoc(Map<String,dynamic> json){
   return TaskModel( task: json['task'], status: json['status']);
  }
  Map<String,dynamic> toJson(){
    return {'id':id,'task':task,'status':status};
  }
}