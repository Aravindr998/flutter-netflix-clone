class BadRequest implements Exception {
  const BadRequest(this.message);
  final Map<String, dynamic> message;
}
