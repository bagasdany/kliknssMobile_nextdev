class DataState {
  Map<String, dynamic> data = {};

  Map<String, dynamic> getData() {
    return data;
  }

  void updateData(Map<String, dynamic> newData) {
    data = newData;
  }
}