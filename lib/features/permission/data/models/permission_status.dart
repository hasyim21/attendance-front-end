enum PermissionStatus {
  reject(0),
  approved(1),
  process(2),
  all(3);

  final int value;

  const PermissionStatus(this.value);
}
