/// Response from the init endpoint.
class InitResponse {
  /// Device ID.
  final String? did;

  /// Session ID (Seance).
  final String? seance;

  InitResponse({
    this.did,
    this.seance,
  });

  factory InitResponse.fromJson(Map<String, dynamic> json) {
    return InitResponse(
      did: json['did'] as String?,
      seance: json['seance'] as String?,
    );
  }
}
