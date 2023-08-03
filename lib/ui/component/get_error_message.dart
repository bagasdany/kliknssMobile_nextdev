/*
------------------------------------ getErrorMessage ---------------------------
Response Api
{
    "type": "ValidationError",
    "errors": {
        "verificationCode": [
            "Kode verifikasi yang dimasukkan tidak valid" ---->>> get this
        ]
    }
}
// catch string error @first array
------------------------------------ getErrorMessage ---------------------------
*/

class GetErrorMessage {
  static String getErrorMessage(Map? response) {
    dynamic array = [];

    response?.forEach((key, value) {
      array = value ?? "";
    });
    String? firstArray = array != []
        ? array != null
            ? array![0] ?? "Terjadi Kesalahan,Silahkan coba lagi"
            : "Terjadi Kesalahan,Silahkan coba lagi"
        : "Terjadi Kesalahan,Silahkan coba lagi";

    return firstArray ?? "Terjadi Kesalahan,Silahkan coba lagi";
  }
}
