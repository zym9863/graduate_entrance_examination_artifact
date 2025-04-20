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

class _AiResponsePageState extends State<AiResponsePage> {
  static const String keyAiResponse = 'ai_response';
  bool _isLoading = true;
  String _aiResponse = '';
  String _errorMessage = '';

  /// 加载缓存的 AI 回复，若无则请求
  Future<void> _loadAiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '${keyAiResponse}_${widget.subject}_${widget.point}_${widget.noteTitle}';
    final saved = prefs.getString(cacheKey);
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        _aiResponse = saved;
        _isLoading = false;
      });
    } else {
      await _generateAiResponse();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAiResponse();
  }

  Future<void> _generateAiResponse({bool forceNew = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 构建提示词，结合考点和笔记标题
      var prompt =
          "作为一位考研辅导专家，请详细解释${widget.subject}学科中'${widget.point}'这个考点下关于'${widget.noteTitle}'的概念。请提供清晰的定义、相关理论背景、重要应用场景以及考试中的常见题型和解题思路。如有必要，可以举例说明并提供记忆技巧。";
      if (forceNew) {
        final nonce = Random().nextInt(1000000);
        prompt +=
            "\n\n（请换种角度重新生成以下回答。ID：$nonce，时间：${DateTime.now().toIso8601String()}）";
        debugPrint('Regenerate prompt with nonce: $nonce');
      }

      // 调用Pollinations API
      final response = await http.post(
        Uri.parse('https://text.pollinations.ai/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'model': 'gemini',
          'private': true, // 响应不会出现在公共feed中
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _aiResponse = response.body;
          _isLoading = false;
        });
        // 缓存 AI 回复
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

  /// 手动重新生成：清除缓存后重新请求
  Future<void> _regenerateAiResponse() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在重新生成 AI 响应...')),
    );
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '${keyAiResponse}_${widget.subject}_${widget.point}_${widget.noteTitle}';
    await prefs.remove(cacheKey);
    await _generateAiResponse(forceNew: true);
  }

  void _copyAiResponse() {
    if (_aiResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可复制的内容')),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: _aiResponse));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制至剪贴板')),
    );
  }

  void _showAiResponseSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择文本'),
        content: SingleChildScrollView(
          child: SelectableText(_aiResponse),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI解析: ${widget.noteTitle}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              colorScheme.primaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildContent(colorScheme),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'regenerate',
            onPressed: _regenerateAiResponse,
            tooltip: '重新生成',
            backgroundColor: colorScheme.secondary,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'copy',
            onPressed: _copyAiResponse,
            tooltip: '复制',
            backgroundColor: colorScheme.secondary,
            child: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'AI正在思考中...',
              style: TextStyle(color: colorScheme.primary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateAiResponse,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.subject} - ${widget.point} - ${widget.noteTitle}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onLongPress: _showAiResponseSelection,
                child: SingleChildScrollView(
                  child: Markdown(
                    data: _aiResponse,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    styleSheet: MarkdownStyleSheet(
                      h1: TextStyle(
                        fontSize: 22,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: TextStyle(fontSize: 20, color: colorScheme.primary),
                      h3: TextStyle(fontSize: 18, color: colorScheme.primary),
                      p: const TextStyle(fontSize: 16, height: 1.5),
                      blockquote: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                      code: TextStyle(
                        backgroundColor: colorScheme.primaryContainer.withOpacity(
                          0.2,
                        ),
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
