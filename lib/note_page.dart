import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ai_response_page.dart';

class NotePage extends StatefulWidget {
  final String subject;
  final String point;

  const NotePage({super.key, required this.subject, required this.point});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Map<String, dynamic>> notes = [];
  String searchKeyword = '';
  static const String keyNotes = 'notes';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('${keyNotes}_${widget.subject}_${widget.point}');
    if (notesString != null) {
      final decoded = json.decode(notesString) as List<dynamic>;
      setState(() {
        notes = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${keyNotes}_${widget.subject}_${widget.point}', json.encode(notes));
  }

  Future<void> _addNote() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_rounded, color: colorScheme.primary, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                '添加笔记',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '标题',
                    hintText: '输入笔记标题',
                    prefixIcon: Icon(Icons.title_rounded, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '内容',
                    hintText: '输入笔记内容',
                    prefixIcon: Icon(Icons.edit_note_rounded, color: colorScheme.primary),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty &&
                    contentController.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'title': titleController.text.trim(),
                    'content': contentController.text.trim(),
                  });
                }
              },
              child: const Text('添加'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );

    if (result != null) {
      setState(() {
        notes.add({
          'title': result['title']!,
          'content': result['content']!,
          'date': DateTime.now().toString(),
        });
      });
      _saveNotes();
    }
  }

  Future<void> _editNote(int index) async {
    final note = notes[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: note['title']);
        final contentController = TextEditingController(text: note['content']);
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit_outlined, color: colorScheme.primary, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                '编辑笔记',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '标题',
                    prefixIcon: Icon(Icons.title_rounded, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '内容',
                    prefixIcon: Icon(Icons.edit_note_rounded, color: colorScheme.primary),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty &&
                    contentController.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'title': titleController.text.trim(),
                    'content': contentController.text.trim(),
                  });
                }
              },
              child: const Text('保存'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );

    if (result != null) {
      setState(() {
        notes[index] = {
          'title': result['title']!,
          'content': result['content']!,
          'date': note['date'],
        };
      });
      _saveNotes();
    }
  }

  Future<void> _deleteNote(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_rounded, 
                color: Theme.of(context).colorScheme.error, 
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text('确认删除'),
          ],
        ),
        content: Text('确定要删除这条笔记吗？此操作不可恢复。'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() {
        notes.removeAt(index);
      });
      _saveNotes();
    }
  }

  void _openAiResponse(Map<String, dynamic> note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiResponsePage(
          subject: widget.subject,
          point: widget.point,
          noteTitle: note['title'],
        ),
      ),
    );
  }

  void _viewNoteDetail(Map<String, dynamic> note) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.note_alt_rounded, color: colorScheme.primary, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                note['title'],
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
                  ),
                  child: Text(
                    note['content'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 16, color: colorScheme.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '创建时间：${_formatDate(note['date'])}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('关闭'),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.note_add_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 32),
          Text(
            searchKeyword.isEmpty ? '还没有笔记' : '没有找到相关笔记',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            searchKeyword.isEmpty ? '点击右下角按钮添加第一条笔记' : '尝试使用其他关键词搜索',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _viewNoteDetail(note),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.note_alt_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        note['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  note['content'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(note['date']),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.psychology_rounded,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20,
                          ),
                          tooltip: 'AI智能解析',
                          onPressed: () => _openAiResponse(note),
                          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.all(4),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          tooltip: '编辑笔记',
                          onPressed: () => _editNote(index),
                          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.all(4),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          ),
                          tooltip: '删除笔记',
                          onPressed: () => _deleteNote(index),
                          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = searchKeyword.isEmpty
        ? notes
        : notes.where((note) =>
            note['title'].toString().toLowerCase().contains(searchKeyword.toLowerCase()) ||
            note['content'].toString().toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.subject} - ${widget.point}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
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
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '搜索笔记',
                  hintText: '输入关键词搜索笔记内容',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: searchKeyword.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded),
                          onPressed: () {
                            setState(() {
                              searchKeyword = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value;
                  });
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: filteredNotes.isEmpty
                ? SliverFillRemaining(
                    child: _buildEmptyState(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final note = filteredNotes[index];
                        final originalIndex = notes.indexOf(note);
                        return _buildNoteCard(note, originalIndex);
                      },
                      childCount: filteredNotes.length,
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        tooltip: '添加笔记',
        icon: Icon(Icons.add_rounded),
        label: Text('添加笔记'),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}