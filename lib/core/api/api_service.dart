import '../storage/chat_storage.dart';

class ApiService {
  Future<Map<String, dynamic>> getSuggestions({
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    const totalItems = 50;
    final totalPages = (totalItems / limit).ceil();
    final currentPage = page.clamp(1, totalPages);
    final startIndex = (currentPage - 1) * limit;

    final titles = [
      'Summarize my notes', 'Generate email reply', 'Explain a concept',
      'Write a to-do list', 'Translate text', 'Fix my grammar',
      'Brainstorm ideas', 'Draft a message', 'Create a study plan',
      'Analyze data trends', 'Write meeting notes', 'Code review tips',
      'Plan a presentation', 'Simplify jargon', 'Create a checklist',
      'Research a topic', 'Write a blog post', 'Debug my code',
      'Suggest book titles', 'Optimize my resume', 'Explain Flutter widgets',
      'Compare technologies', 'Write unit tests', 'Design a database',
      'Improve UX copy', 'Generate API docs', 'Plan sprint tasks',
      'Write release notes', 'Create user stories', 'Automate workflows',
      'Analyze competitors', 'Draft a proposal', 'Set up CI/CD',
      'Write documentation', 'Review architecture', 'Create wireframes',
      'Improve accessibility', 'Optimize performance', 'Manage dependencies',
      'Write error messages', 'Plan onboarding flow', 'Audit security',
      'Create color palette', 'Write test scenarios', 'Refactor legacy code',
      'Estimate project time', 'Design notifications', 'Migrate database',
      'Build a dashboard', 'Review PR feedback',
    ];

    final descriptions = [
      'Get a concise summary of your text', 'Create a professional email response',
      'Break down complex topics simply', 'Organize your tasks for the day',
      'Convert text between languages', 'Correct grammar and spelling errors',
      'Generate creative ideas for your project', 'Compose a thoughtful message',
      'Organize your learning schedule', 'Understand patterns in your data',
      'Summarize key discussion points', 'Get feedback on your code quality',
      'Structure your talk effectively', 'Make technical language easy to understand',
      'Build a step-by-step checklist', 'Get a quick overview of any subject',
      'Draft engaging content for your blog', 'Find and fix issues in your code',
      'Get reading recommendations', 'Improve your resume for job applications',
      'Understand core Flutter UI components', 'Evaluate pros and cons of different tools',
      'Create test cases for your functions', 'Plan your database schema',
      'Make your app\'s text more user-friendly', 'Document your API endpoints clearly',
      'Break work into sprint-sized chunks', 'Summarize changes in your release',
      'Define features from a user perspective', 'Identify tasks that can be automated',
      'Research what competitors are doing', 'Write a compelling project proposal',
      'Plan your continuous integration pipeline', 'Create clear technical documentation',
      'Evaluate your app\'s architecture', 'Sketch out your app\'s layout',
      'Make your app usable for everyone', 'Speed up your application',
      'Keep your packages up to date', 'Create helpful error notifications',
      'Design a smooth first-time experience', 'Check for common vulnerabilities',
      'Design a harmonious color scheme', 'Plan end-to-end test cases',
      'Clean up and modernize old code', 'Break down tasks with time estimates',
      'Plan your push notification strategy', 'Plan a safe database migration',
      'Design an analytics dashboard layout', 'Summarize pull request comments',
    ];

    final endIndex = (startIndex + limit).clamp(0, totalItems);
    final pageData = <Map<String, dynamic>>[];

    for (int i = startIndex; i < endIndex; i++) {
      pageData.add({
        'id': i + 1,
        'title': titles[i],
        'description': descriptions[i],
      });
    }

    return {
      'status': 'success',
      'data': pageData,
      'pagination': {
        'current_page': currentPage,
        'total_pages': totalPages,
        'total_items': totalItems,
        'limit': limit,
        'has_next': currentPage < totalPages,
        'has_previous': currentPage > 1,
      },
    };
  }

  Future<Map<String, dynamic>> sendMessage(String message, {required String sessionId}) async {
    await Future.delayed(const Duration(seconds: 1));

    await ChatStorage.saveMessage(
      sessionId: sessionId,
      sender: 'user',
      message: message,
    );

    final reply = _generateReply(message);

    await ChatStorage.saveMessage(
      sessionId: sessionId,
      sender: 'assistant',
      message: reply,
    );

    return {
      'status': 'success',
      'reply': reply,
    };
  }

  Future<Map<String, dynamic>> getChatHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sessions = ChatStorage.getAllSessions();

    return {
      'status': 'success',
      'data': sessions,
    };
  }

  Future<Map<String, dynamic>> getSessionMessages(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final messages = ChatStorage.getSessionMessages(sessionId);

    return {
      'status': 'success',
      'data': messages,
    };
  }

  static int _replyCounter = 0;

  String _generateReply(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('flutter')) {
      return 'Flutter is an open-source UI toolkit by Google for building '
          'natively compiled applications for mobile, web, and desktop from '
          'a single codebase. It uses the Dart programming language and '
          'provides a rich set of pre-built widgets.';
    } else if (lower.contains('state management')) {
      return 'Flutter state management helps you manage UI updates efficiently. '
          'Popular options include Provider, Riverpod, Bloc, and GetX. '
          'Riverpod is a great choice for its compile-time safety and testability.';
    } else if (lower.contains('dart')) {
      return 'Dart is a client-optimized programming language developed by Google. '
          'It\'s the language behind Flutter and supports both AOT and JIT compilation, '
          'making it fast for production and productive during development.';
    } else if (lower.contains('api') || lower.contains('rest')) {
      return 'REST APIs use standard HTTP methods (GET, POST, PUT, DELETE) to '
          'communicate between client and server. In Flutter, the `http` or `dio` '
          'packages are commonly used for making API calls with proper error handling.';
    } else if (lower.contains('database') || lower.contains('sql')) {
      return 'For local databases in Flutter, popular choices include SQLite '
          '(via sqflite), Hive (a lightweight NoSQL box), and Isar. For cloud '
          'databases, Firebase Firestore and Supabase are excellent options.';
    } else if (lower.contains('test') || lower.contains('testing')) {
      return 'Flutter supports three types of testing:\n'
          '• Unit tests — test individual functions and classes\n'
          '• Widget tests — test UI components in isolation\n'
          '• Integration tests — test the complete app flow\n\n'
          'Use `flutter test` to run your test suite.';
    } else if (lower.contains('design') || lower.contains('ui') || lower.contains('ux')) {
      return 'Great UI/UX design in Flutter starts with a clear design system. '
          'Use ThemeData for consistent colors and typography, create reusable '
          'widget components, and follow Material Design or Cupertino guidelines '
          'for platform-appropriate experiences.';
    } else if (lower.contains('summarize') || lower.contains('summary') || lower.contains('notes')) {
      return 'Here\'s a concise summary of your request about "$message":\n\n'
          'The key points are:\n'
          '1. Identify the main topic and objectives\n'
          '2. Extract the most important information\n'
          '3. Organize into a clear, structured format\n'
          '4. Remove redundancy while keeping essential details';
    } else if (lower.contains('email') || lower.contains('mail')) {
      return 'Here\'s a professional email draft:\n\n'
          'Subject: Re: Your Request\n\n'
          'Dear [Recipient],\n\n'
          'Thank you for your message. I\'ve reviewed the details and '
          'would like to share my thoughts.\n\n'
          'I believe we can move forward with the proposed approach. '
          'Please let me know if you have any questions.\n\n'
          'Best regards,\n[Your Name]';
    } else if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return 'Hello! 👋 I\'m your Smart Assistant. I can help you with '
          'summaries, email drafts, code explanations, brainstorming, and more. '
          'How can I assist you today?';
    } else if (lower.contains('help')) {
      return 'I can help you with:\n'
          '• Summarizing notes and text\n'
          '• Generating email replies\n'
          '• Explaining technical concepts\n'
          '• Brainstorming ideas\n'
          '• Writing code and debugging\n'
          '• Planning and organizing tasks\n\n'
          'Just type your question or request!';
    } else if (lower.contains('code') || lower.contains('program') || lower.contains('debug')) {
      return 'When it comes to coding best practices:\n\n'
          '• Write clean, readable code with clear naming\n'
          '• Break complex logic into smaller functions\n'
          '• Add error handling for edge cases\n'
          '• Write tests to verify your logic\n'
          '• Use version control (Git) consistently\n\n'
          'Would you like help with a specific coding challenge?';
    } else if (lower.contains('plan') || lower.contains('organize') || lower.contains('schedule')) {
      return 'Here\'s a structured approach to planning "$message":\n\n'
          '1. Define your goals and success criteria\n'
          '2. Break the work into smaller milestones\n'
          '3. Estimate time for each milestone\n'
          '4. Prioritize by impact and urgency\n'
          '5. Build in buffer time for unexpected issues\n'
          '6. Review and adjust the plan regularly';
    } else if (lower.contains('idea') || lower.contains('brainstorm') || lower.contains('creative')) {
      return 'Here are some creative angles to explore for "$message":\n\n'
          '💡 Think about the problem from the user\'s perspective\n'
          '💡 Look at how other industries solve similar challenges\n'
          '💡 Combine two existing ideas into something new\n'
          '💡 Ask "what if" questions to push boundaries\n'
          '💡 Start with the ideal outcome and work backwards';
    } else if (lower.contains('explain') || lower.contains('what is') || lower.contains('how does')) {
      return 'Great question! Let me break down "$message" for you:\n\n'
          'At its core, this concept involves understanding the fundamental '
          'principles and how they connect. Think of it as building blocks — '
          'each piece serves a purpose and fits together to create the bigger picture.\n\n'
          'The key takeaway is to start with the basics and gradually build '
          'your understanding through practice and experimentation.';
    } else if (lower.contains('write') || lower.contains('draft') || lower.contains('compose')) {
      return 'I\'d be happy to help you write about "$message"! Here\'s a draft:\n\n'
          'This is a topic that deserves careful attention. The main points to cover are '
          'the background context, the current situation, and the proposed way forward. '
          'Each section should flow naturally into the next, creating a cohesive narrative '
          'that your audience can easily follow.';
    } else if (lower.contains('compare') || lower.contains('difference') || lower.contains('vs')) {
      return 'When comparing different options for "$message", consider:\n\n'
          '📊 Performance — which option is faster/more efficient?\n'
          '📊 Ease of use — which has a gentler learning curve?\n'
          '📊 Community — which has better documentation and support?\n'
          '📊 Scalability — which grows better with your needs?\n'
          '📊 Cost — which fits your budget constraints?';
    } else if (lower.contains('thank')) {
      return 'You\'re welcome! 😊 I\'m glad I could help. Feel free to ask me '
          'anything else — I\'m here to assist you anytime.';
    } else if (lower.contains('bye') || lower.contains('goodbye')) {
      return 'Goodbye! 👋 It was great chatting with you. Come back anytime '
          'you need help. Have a wonderful day!';
    } else {
      
      final replies = [
        'Interesting question about "$message"! Here\'s what I think:\n\n'
            'This topic has several important aspects to consider. The key is to '
            'approach it systematically — start with research, then plan, and finally '
            'execute with attention to detail.',
        'I\'d love to help with "$message"! Let me share my thoughts:\n\n'
            'The best approach here is to break this down into manageable steps. '
            'Start with the fundamentals, build a solid foundation, and then '
            'iterate on your solution until you\'re satisfied.',
        'That\'s a thoughtful topic — "$message". Here\'s my take:\n\n'
            'Consider looking at this from multiple angles. What works in one '
            'context might not work in another, so it\'s important to understand '
            'your specific requirements and constraints first.',
        'Great topic! Regarding "$message":\n\n'
            'I recommend starting with a clear definition of what success looks like. '
            'Once you have that clarity, the path forward becomes much easier to navigate. '
            'Don\'t hesitate to experiment and learn from the results.',
        'Let me help you with "$message":\n\n'
            'The most effective strategy involves three phases: understanding (research '
            'and gather info), planning (define steps and timeline), and execution '
            '(implement with regular checkpoints). This ensures a solid outcome.',
        'Here\'s my analysis of "$message":\n\n'
            'There are a few key considerations to keep in mind. First, clarity of '
            'purpose is essential. Second, having a structured approach saves time. '
            'Third, feedback loops help you course-correct early.',
        'Regarding "$message" — here\'s what I\'d suggest:\n\n'
            'Start by identifying the core challenge. Often what seems complex on '
            'the surface can be simplified by asking the right questions. Focus on '
            'the "why" before diving into the "how".',
        'Thanks for asking about "$message"! My thoughts:\n\n'
            'This is one of those topics where hands-on experience is invaluable. '
            'I\'d suggest starting small with a prototype or proof of concept, '
            'learning from it, and then scaling up your approach.',
      ];

      final reply = replies[_replyCounter % replies.length];
      _replyCounter++;
      return reply;
    }
  }
}