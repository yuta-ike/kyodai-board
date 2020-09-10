class Thread{
  const Thread({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.clubLastMessageId,
    this.userLastMessageId,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool clubLastMessageId;
  final bool userLastMessageId;
}