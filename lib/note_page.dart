import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // 加载笔记数据
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

  // 保存笔记数据
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${keyNotes}_${widget.subject}_${widget.point}', json.encode(notes));
  }

  // 添加笔记
  Future<void> _addNote() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(
            '添加笔记',
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    prefixIcon: Icon(Icons.title, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '内容',
                    labelStyle: TextStyle(color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    prefixIcon: Icon(Icons.note, color: colorScheme.primary),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'title': titleController.text,
                'content': contentController.text,
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('添加'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );

    if (result != null &&
        result['title']!.trim().isNotEmpty &&
        result['content']!.trim().isNotEmpty) {
      setState(() {
        notes.add({
          'title': result['title']!.trim(),
          'content': result['content']!.trim(),
          'date': DateTime.now().toString(),
        });
      });
      _saveNotes();
    }
  }

  // 编辑笔记
  Future<void> _editNote(int index) async {
    final note = notes[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: note['title']);
        final contentController = TextEditingController(text: note['content']);
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(
            '编辑笔记',
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    prefixIcon: Icon(Icons.title, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '内容',
                    labelStyle: TextStyle(color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    prefixIcon: Icon(Icons.note, color: colorScheme.primary),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'title': titleController.text,
                'content': contentController.text,
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('保存'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );

    if (result != null &&
        result['title']!.trim().isNotEmpty &&
        result['content']!.trim().isNotEmpty) {
      setState(() {
        notes[index] = {
          'title': result['title']!.trim(),
          'content': result['content']!.trim(),
          'date': note['date'], // 保留原创建日期
        };
      });
      _saveNotes();
    }
  }

  // 删除笔记
  void _deleteNote(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '确认删除',
          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text('确定要删除这条笔记吗？'),
            const Text('删除后将无法恢复', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                notes.removeAt(index);
              });
              _saveNotes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('删除'),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  // 查看笔记详情
  void _viewNoteDetail(Map<String, dynamic> note) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          note['title'],
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    note['content'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '创建时间: ${DateTime.parse(note['date']).toLocal().toString().split('.')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('关闭'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取主题颜色
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;
    
    // 根据搜索关键字过滤笔记
    final filteredNotes = searchKeyword.isEmpty
        ? notes
        : notes
            .where((note) =>
                note['title'].toString().contains(searchKeyword) ||
                note['content'].toString().contains(searchKeyword))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subject} - ${widget.point}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
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
        child: Column(
          children: [
            // 搜索框
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '搜索笔记',
                  labelStyle: TextStyle(color: primaryColor),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  suffixIcon: searchKeyword.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchKeyword = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value;
                  });
                },
              ),
            ),
            // 笔记列表
            Expanded(
              child: filteredNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 64,
                            color: primaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '暂无笔记，点击右下角按钮添加',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                note['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    note['content'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white70
                                          : Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '创建于: ${DateTime.parse(note['date']).toLocal().toString().split(' ')[0]}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _viewNoteDetail(note),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, color: secondaryColor),
                                    tooltip: '编辑笔记',
                                    onPressed: () => _editNote(
                                        notes.indexOf(note)), // 使用原始列表的索引
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                    tooltip: '删除笔记',
                                    onPressed: () => _deleteNote(
                                        notes.indexOf(note)), // 使用原始列表的索引
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        tooltip: '添加笔记',
        icon: const Icon(Icons.add),
        label: const Text('添加笔记'),
        backgroundColor: secondaryColor,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
