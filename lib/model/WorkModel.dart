
class WorkModel {

  String key;
  String title;
  String content;
  DateTime createdDate;
  DateTime modifiedDate;
  bool isDelete = false;

  WorkModel(this.title, this.content, this.createdDate, this.modifiedDate);
}
