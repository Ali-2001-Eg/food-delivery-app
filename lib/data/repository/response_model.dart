//model to receive response fields
class ResponseModel{
  bool isSuccess;
  String message;
  //private variables cannot be wrapped around { required this._pla}
  ResponseModel(this.isSuccess,this.message);

}