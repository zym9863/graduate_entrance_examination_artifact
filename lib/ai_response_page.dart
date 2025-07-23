import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class AiResponsePage extends StatefulWidget {
  final String subject;
  final String point;
  final String noteTitle;

  const AiResponsePage({
    super.key,
    required this.subject,
    required this.point,
    required this.noteTitle,
  });

  @override
  State<AiResponsePage> createState() => _AiResponsePageState();
}

class _AiResponsePageState extends State<AiResponsePage>
    with TickerProviderStateMixin {
  static const String keyAiResponse = 'ai_response';
  bool _isLoading = true;
  String _aiResponse = '';
  String _errorMessage = '';
  late AnimationController _loadingController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _loadAiResponse();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadAiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '${keyAiResponse}_${widget.subject}_${widget.point}_${widget.noteTitle}';
    final saved = prefs.getString(cacheKey);
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        _aiResponse = saved;
        _isLoading = false;
      });
      _fadeController.forward();
    } else {
      await _generateAiResponse();
    }
  }

  Future<void> _generateAiResponse({bool forceNew = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    _fadeController.reset();

    try {
      var prompt =
          "作为一位考研辅导专家，请详细解释${widget.subject}学科中'${widget.point}'这个考点下关于'${widget.noteTitle}'的概念。请提供清晰的定义、相关理论背景、重要应用场景以及考试中的常见题型和解题思路。如有必要，可以举例说明并提供记忆技巧。";
      if (forceNew) {
        final nonce = Random().nextInt(1000000);
        prompt +=
            "\n\n（请换种角度重新生成以下回答。ID：$nonce，时间：${DateTime.now().toIso8601String()}）";
        debugPrint('Regenerate prompt with nonce: $nonce');
      }

      final response = await http.post(
        Uri.parse('https://text.pollinations.ai/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'model': 'openai-large',
          'private': true,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _aiResponse = response.body;
          _isLoading = false;
        });
        _fadeController.forward();
        
        final prefs = await SharedPreferences.getInstance();
        final cacheKey = '${keyAiResponse}_${widget.subject}_${widget.point}_${widget.noteTitle}';
        await prefs.setString(cacheKey, response.body);
      } else {
        setState(() {
          _errorMessage = '获取AI回复失败: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '发生错误: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(32),
          ),
          child: AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingController.value * 2.0 * pi,
                child: Icon(
                  Icons.psychology_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 32),
        Text(
          'AI正在思考中...',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Container(
          constraints: BoxConstraints(maxWidth: 300),
          child: AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              final dots = ('.' * ((_loadingController.value * 3).floor() + 1)).padRight(3);
              return Text(
                '正在为您生成专业详细的解答$dots',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        SizedBox(height: 32),
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: (_loadingController.value * 2) % 1.0,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(2),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 24),
          Text(
            '获取回复失败',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _generateAiResponse(),
            icon: Icon(Icons.refresh_rounded),
            label: Text('重新获取'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部信息卡片
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
                  Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI 智能解析',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.subject} > ${widget.point} > ${widget.noteTitle}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // 回复内容卡片
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '详细解答',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                MarkdownBody(
                  data: _aiResponse,
                  styleSheet: MarkdownStyleSheet(
                    p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    ),
                    blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                    listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _aiResponse));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('内容已复制到剪贴板'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.copy_rounded, size: 18),
                  label: Text('复制内容'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _generateAiResponse(forceNew: true),
                  icon: Icon(Icons.refresh_rounded, size: 18),
                  label: Text('重新生成'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'AI 智能解析',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverFillRemaining(
              child: _isLoading
                  ? _buildLoadingAnimation()
                  : _errorMessage.isNotEmpty
                      ? _buildErrorState()
                      : _buildResponseContent(),
            ),
          ),
        ],
      ),
    );
  }
}