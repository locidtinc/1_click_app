enum StatusOrder {
  all('All', 'Tất cả'),
  draft('Draft', 'Dự thảo'),
  pending('1', 'Chờ xác nhận'),
  accept('2', 'Đã xác nhận'),
  deny('3', 'Từ chối'),
  complete('4', 'Hoàn thành');

  const StatusOrder(this.id, this.title);

  final String id;
  final String title;
}
