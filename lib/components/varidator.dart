import 'package:form_field_validator/form_field_validator.dart';

MultiValidator ValidatorEmpty = MultiValidator([
  RequiredValidator(errorText: "กรุณาป้อนข้อมูลด้วย"),
]);

MultiValidator ValidatorUsername = MultiValidator(
  [
    RequiredValidator(errorText: "กรุณาป้อนเลขบัตรสมาชิกด้วย"),
    MinLengthValidator(13, errorText: "เลขบัตรไม่ถูกต้อง")

  ],
);

MultiValidator ValidatorPassword = MultiValidator(
  [
    RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วย"),
    MinLengthValidator(6, errorText: "รหัสผ่านต้องไม่ต่ำกว่า 6 ตัว")
  ],
);

MultiValidator ValidatorPhone = MultiValidator(
  [
    RequiredValidator(errorText: "กรุณาป้อนข้อมูลด้วย"),
    MinLengthValidator(10, errorText: "หมายเลขโทรศัพท์ต้องมี 10 ตัว")
  ],
);
