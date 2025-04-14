import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '考研神器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E35B1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const ExamMasterHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamMasterHomePage extends StatefulWidget {
  const ExamMasterHomePage({super.key});

  @override
  State<ExamMasterHomePage> createState() => _ExamMasterHomePageState();
}

class _ExamMasterHomePageState extends State<ExamMasterHomePage> {
  // 固定科目
  final List<String> fixedSubjects = ['政治', '英语', '数学'];
  // 专业下的科目
  List<String> majorSubjects = [];
  // 当前选中的科目（左侧列表）
  String? selectedSubject;
  // 考点数据结构：科目->考点列表
  Map<String, List<String>> subjectPoints = {};
  // 搜索关键字
  String searchKeyword = '';

  // 持久化相关
  static const String keyMajorSubjects = 'majorSubjects';
  static const String keySubjectPoints = 'subjectPoints';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    // 加载专业科目
    final majorSubjectsString = prefs.getString(keyMajorSubjects);
    if (majorSubjectsString != null) {
      majorSubjects = List<String>.from(json.decode(majorSubjectsString));
    }
    // 加载考点
    final subjectPointsString = prefs.getString(keySubjectPoints);
    if (subjectPointsString != null) {
      final decoded = json.decode(subjectPointsString) as Map<String, dynamic>;
      subjectPoints = decoded.map((k, v) => MapEntry(k, List<String>.from(v)));
    }
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMajorSubjects, json.encode(majorSubjects));
    await prefs.setString(keySubjectPoints, json.encode(subjectPoints));
  }

  // 右侧欢迎页
  Widget _buildWelcome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            '欢迎使用考研神器！',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '请选择左侧科目或添加专业科目开始使用',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 右侧考点列表页
  Widget _buildPointsList(String subject) {
    final points = subjectPoints[subject] ?? [];
    final filteredPoints = searchKeyword.isEmpty
        ? points
        : points.where((p) => p.contains(searchKeyword)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: '搜索考点',
              hintText: '输入关键词搜索考点',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            onChanged: (value) {
              setState(() {
                searchKeyword = value;
              });
            },
          ),
        ),
        // 考点列表
        Expanded(
          child: filteredPoints.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '没有找到相关考点',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredPoints.length,
                  itemBuilder: (context, index) {
                    final point = filteredPoints[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          point,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        leading: Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(
                                subject: subject,
                                point: point,
                              ),
                            ),
                          );
                        },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                        // 修改
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: '修改考点',
                          onPressed: () async {
                            final newPoint = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController(text: point);
                                final colorScheme = Theme.of(context).colorScheme;
                                return AlertDialog(
                                  title: Text(
                                    '修改考点',
                                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                                  content: TextField(
                                    controller: controller,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: '考点内容',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      prefixIcon: Icon(Icons.lightbulb_outline, color: colorScheme.primary),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
                                      child: const Text('取消'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, controller.text),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        foregroundColor: colorScheme.onPrimary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('保存'),
                                    ),
                                  ],
                                  actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                );
                              },
                            );
                        if (newPoint != null && newPoint.trim().isNotEmpty) {
                          setState(() {
                            subjectPoints[subject]![points.indexOf(point)] = newPoint.trim();
                          });
                          _saveData();
                        }
                      },
                    ),
                        // 删除
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          tooltip: '删除考点',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('确认删除'),
                                content: Text('确定要删除考点"$point"吗？'),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        subjectPoints[subject]!.remove(point);
                                      });
                                      _saveData();
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                                    child: const Text('删除'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
            );
            },
          ),
        ),
        // 添加考点按钮
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('添加考点'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () async {
              final newPoint = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  final colorScheme = Theme.of(context).colorScheme;
                  return AlertDialog(
                    title: Text(
                      '添加考点',
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: '考点内容',
                        hintText: '请输入考点名称',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.lightbulb_outline, color: colorScheme.primary),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
                        child: const Text('取消'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, controller.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('添加'),
                      ),
                    ],
                    actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  );
                },
              );
              if (newPoint != null && newPoint.trim().isNotEmpty) {
                setState(() {
                  subjectPoints.putIfAbsent(subject, () => []);
                  subjectPoints[subject]!.add(newPoint.trim());
                });
                _saveData();
              }
            },
          ),
        ),
      ],
    );
  }

  // 左侧列表
  Widget _buildSidebar() {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        children: [
          // 固定科目
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              '公共课',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ...fixedSubjects.map((subject) => ListTile(
                title: Text(
                  subject,
                  style: TextStyle(
                    fontWeight: selectedSubject == subject ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: selectedSubject == subject,
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                leading: Icon(
                  _getSubjectIcon(subject),
                  color: selectedSubject == subject
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[600],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  setState(() {
                    selectedSubject = subject;
                    searchKeyword = '';
                  });
                },
              )),
          // 专业
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              '专业课',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ExpansionTile(
            title: Text(
              '专业',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            leading: Icon(
              Icons.school,
              color: Theme.of(context).colorScheme.secondary,
            ),
            initiallyExpanded: true,
            children: [
              // 专业下的具体科目
              ...majorSubjects.map((subject) => ListTile(
                    title: Text(
                      subject,
                      style: TextStyle(
                        fontWeight: selectedSubject == subject ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selectedSubject == subject,
                    selectedTileColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                    leading: Icon(
                      Icons.book,
                      color: selectedSubject == subject
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey[600],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          if (selectedSubject == subject) selectedSubject = null;
                          majorSubjects.remove(subject);
                          subjectPoints.remove(subject);
                        });
                        _saveData();
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      setState(() {
                        selectedSubject = subject;
                        searchKeyword = '';
                      });
                    },
                  )),
              // 添加专业科目按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('添加专业科目'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                  final newSubject = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController();
                      final colorScheme = Theme.of(context).colorScheme;
                      return AlertDialog(
                        title: Text(
                          '添加专业科目',
                          style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: '科目名称',
                            hintText: '请输入专业科目名称',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            prefixIcon: Icon(Icons.book, color: colorScheme.secondary),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
                            child: const Text('取消'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, controller.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('添加'),
                          ),
                        ],
                        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      );
                    },
                  );
                  if (newSubject != null &&
                      newSubject.trim().isNotEmpty &&
                      !majorSubjects.contains(newSubject.trim()) &&
                      !fixedSubjects.contains(newSubject.trim())) {
                    setState(() {
                      majorSubjects.add(newSubject.trim());
                    });
                    _saveData();
                  }
                },
              ),
          ),
          ],
          ),
        ],
      ),
    );
  }

  // 获取科目对应的图标
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case '政治':
        return Icons.gavel;
      case '英语':
        return Icons.language;
      case '数学':
        return Icons.calculate;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '考研神器',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
      ),
      body: Row(
        children: [
          _buildSidebar(),
          // 右侧内容区
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: selectedSubject == null
                  ? _buildWelcome()
                  : _buildPointsList(selectedSubject!),
            ),
          ),
        ],
      ),
    );
  }
}
