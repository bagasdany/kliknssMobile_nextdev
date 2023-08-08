class DataState {
  Map<dynamic, dynamic> data = {};
  List list = [''];

  Map<dynamic, dynamic> getData() {
    return data;
  }
  dynamic getList() {
    return list;
  }
  
  

  void updateData(Map<dynamic, dynamic> newData) {
    data = newData;
  }
    void addData(Map<dynamic, dynamic> addData) {
    data['data'].addEntries(addData.entries);
  }
}