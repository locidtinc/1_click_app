enum StatusOrderSystem {
  all('All', 'Tất cả'),
  draft('Draft', 'Dự thảo'),
  pending('1', 'Chờ xác nhận'),
  pendingNPT('2', 'Chờ phản hồi'),
  denyNPT('3', 'Chờ phản hồi'),
  accept('4', 'Đã xác nhận'),
  complete('5', 'Hoàn thành'),
  deny('6', 'Từ chối'),
  denyImport('7', 'Từ chối nhận');

  const StatusOrderSystem(this.id, this.title);

  final String id;
  final String title;
}
