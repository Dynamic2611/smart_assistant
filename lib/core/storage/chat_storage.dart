import 'package:hive_flutter/hive_flutter.dart';

class ChatStorage {
  static const String _sessionsBoxName = 'chat_sessions';
  static const String _messagesBoxName = 'chat_messages';

  static Box? _sessionsBox;
  static Box? _messagesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _sessionsBox = await Hive.openBox(_sessionsBoxName);
    _messagesBox = await Hive.openBox(_messagesBoxName);
  }

  static Future<String> createSession() async {
    final box = _sessionsBox!;
    final sessionId =
        'session_${DateTime.now().millisecondsSinceEpoch}';

    await box.put(sessionId, {
      'session_id': sessionId,
      'created_at': DateTime.now().toIso8601String(),
    });

    return sessionId;
  }

  static Future<void> saveMessage({
    required String sessionId,
    required String sender,
    required String message,
  }) async {
    final box = _messagesBox!;

    final existing = List<Map>.from(box.get(sessionId, defaultValue: []) as List);

    existing.add({
      'sender': sender,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await box.put(sessionId, existing);
  }

  static List<Map<String, dynamic>> getSessionMessages(String sessionId) {
    final box = _messagesBox!;
    final raw = box.get(sessionId, defaultValue: []) as List;
    return raw.map((m) {
      final map = Map<String, dynamic>.from(m as Map);
      return map;
    }).toList();
  }

  static List<Map<String, dynamic>> getAllSessions() {
    final sessionsBox = _sessionsBox!;
    final sessions = <Map<String, dynamic>>[];

    for (final key in sessionsBox.keys) {
      final sessionData = Map<String, dynamic>.from(sessionsBox.get(key) as Map);
      final messages = getSessionMessages(key as String);

      if (messages.isNotEmpty) {
        sessions.add({
          'session_id': sessionData['session_id'],
          'created_at': sessionData['created_at'],
          'messages': messages,
        });
      }
    }

    sessions.sort((a, b) {
      final aTime = DateTime.parse(a['created_at'] as String);
      final bTime = DateTime.parse(b['created_at'] as String);
      return bTime.compareTo(aTime);
    });

    return sessions;
  }

  static Future<void> deleteSession(String sessionId) async {
    await _sessionsBox?.delete(sessionId);
    await _messagesBox?.delete(sessionId);
  }
}
