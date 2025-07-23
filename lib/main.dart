import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'note_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 主题模式，默认跟随系统
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '考研神器',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF6366F1),
          onPrimary: Colors.white,
          secondary: Color(0xFF8B5CF6),
          onSecondary: Colors.white,
          tertiary: Color(0xFF06B6D4),
          onTertiary: Colors.white,
          error: Color(0xFFEF4444),
          onError: Colors.white,
          background: Color(0xFFFAFAFC),
          onBackground: Color(0xFF1F2937),
          surface: Colors.white,
          onSurface: Color(0xFF1F2937),
          primaryContainer: Color(0xFFEEF2FF),
          onPrimaryContainer: Color(0xFF3730A3),
          secondaryContainer: Color(0xFFF3E8FF),
          onSecondaryContainer: Color(0xFF6B21A8),
        ),
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          headlineLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
          headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
          headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
          titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
          titleMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF374151)),
          bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF374151)),
          bodySmall: TextStyle(fontSize: 12.0, color: Color(0xFF6B7280)),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Color(0xFF6366F1), width: 1.5),
            foregroundColor: Color(0xFF6366F1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Microsoft YaHei',
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF818CF8),
          onPrimary: Color(0xFF1E1B4B),
          secondary: Color(0xFFA78BFA),
          onSecondary: Color(0xFF3B0764),
          tertiary: Color(0xFF22D3EE),
          onTertiary: Color(0xFF083344),
          error: Color(0xFFFF6B6B),
          onError: Color(0xFF7F1D1D),
          background: Color(0xFF0F172A),
          onBackground: Color(0xFFE2E8F0),
          surface: Color(0xFF1E293B),
          onSurface: Color(0xFFE2E8F0),
          primaryContainer: Color(0xFF312E81),
          onPrimaryContainer: Color(0xFFE0E7FF),
          secondaryContainer: Color(0xFF581C87),
          onSecondaryContainer: Color(0xFFF3E8FF),
        ),
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFFE2E8F0)),
          displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color(0xFFE2E8F0)),
          displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFE2E8F0)),
          headlineLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
          headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
          headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
          titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(0xFFE2E8F0)),
          titleMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFFCBD5E1)),
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFFCBD5E1)),
          bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFFCBD5E1)),
          bodySmall: TextStyle(fontSize: 12.0, color: Color(0xFF94A3B8)),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Color(0xFF1E293B),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Color(0xFF818CF8),
            foregroundColor: Color(0xFF1E1B4B),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Color(0xFFA78BFA),
            foregroundColor: Color(0xFF3B0764),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Color(0xFF818CF8), width: 1.5),
            foregroundColor: Color(0xFF818CF8),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF475569)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF475569)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF818CF8), width: 2),
          ),
          filled: true,
          fillColor: Color(0xFF334155),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          backgroundColor: Color(0xFF818CF8),
          foregroundColor: Color(0xFF1E1B4B),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1B4B),
            fontFamily: 'Microsoft YaHei',
          ),
        ),
      ),
      home: ExamMasterHomePage(
        onThemeModeChanged: setThemeMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ExamMasterHomePage extends StatefulWidget {
  final void Function(ThemeMode)? onThemeModeChanged;

  const ExamMasterHomePage({super.key, this.onThemeModeChanged});

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '欢迎使用考研神器！',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: Text(
                '专为考研学子打造的智能学习助手\n管理知识点，记录学习笔记，AI智能问答',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '请从左侧选择科目或添加专业科目开始使用',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        // 顶部区域：标题和搜索框
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 科目标题
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getSubjectIcon(subject),
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${points.length} 个考点',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 搜索框
              TextField(
                decoration: InputDecoration(
                  labelText: '搜索考点',
                  hintText: '输入关键词搜索考点',
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
            ],
          ),
        ),
        // 考点列表
        Expanded(
          child: filteredPoints.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredPoints.length,
                  itemBuilder: (context, index) {
                    final point = filteredPoints[index];
                    return _buildPointCard(subject, point, points);
                  },
                ),
        ),
        // 底部添加按钮
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add_rounded),
            label: Text('添加考点'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _showAddPointDialog(subject),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              searchKeyword.isEmpty ? Icons.lightbulb_outline_rounded : Icons.search_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          SizedBox(height: 24),
          Text(
            searchKeyword.isEmpty ? '还没有考点' : '没有找到相关考点',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            searchKeyword.isEmpty ? '点击下方按钮添加第一个考点' : '尝试使用其他关键词搜索',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(String subject, String point, List<String> points) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '点击查看详细笔记',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      tooltip: '编辑考点',
                      onPressed: () => _showEditPointDialog(subject, point, points),
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      tooltip: '删除考点',
                      onPressed: () => _showDeletePointDialog(subject, point),
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
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

  Future<void> _showAddPointDialog(String subject) async {
    final newPoint = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
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
                '添加考点',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: '考点内容',
              hintText: '请输入考点名称',
              prefixIcon: Icon(Icons.lightbulb_outline_rounded, color: colorScheme.primary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('添加'),
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
  }

  Future<void> _showEditPointDialog(String subject, String point, List<String> points) async {
    final newPoint = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: point);
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
                '编辑考点',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: '考点内容',
              prefixIcon: Icon(Icons.lightbulb_outline_rounded, color: colorScheme.primary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('保存'),
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
  }

  Future<void> _showDeletePointDialog(String subject, String point) async {
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
        content: Text('确定要删除考点"$point"吗？此操作不可恢复。'),
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
        subjectPoints[subject]!.remove(point);
      });
      _saveData();
    }
  }

  // 左侧列表
  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部标题区域
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '科目导航',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '选择学习科目',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 科目列表
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // 公共课标题
                _buildSectionHeader('公共课', Icons.school_rounded, Theme.of(context).colorScheme.primary),
                SizedBox(height: 8),
                // 固定科目列表
                ...fixedSubjects.map((subject) => _buildSubjectTile(
                  subject: subject,
                  icon: _getSubjectIcon(subject),
                  isSelected: selectedSubject == subject,
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    setState(() {
                      selectedSubject = subject;
                      searchKeyword = '';
                    });
                  },
                )),
                SizedBox(height: 24),
                // 专业课标题
                _buildSectionHeader('专业课', Icons.science_rounded, Theme.of(context).colorScheme.secondary),
                SizedBox(height: 8),
                // 专业科目展开面板
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      '专业科目',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.folder_special_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.only(bottom: 8),
                    children: [
                      // 专业科目列表
                      ...majorSubjects.map((subject) => _buildSubjectTile(
                        subject: subject,
                        icon: Icons.auto_stories_rounded,
                        isSelected: selectedSubject == subject,
                        color: Theme.of(context).colorScheme.secondary,
                        showDelete: true,
                        onTap: () {
                          setState(() {
                            selectedSubject = subject;
                            searchKeyword = '';
                          });
                        },
                        onDelete: () {
                          setState(() {
                            if (selectedSubject == subject) selectedSubject = null;
                            majorSubjects.remove(subject);
                            subjectPoints.remove(subject);
                          });
                          _saveData();
                        },
                      )),
                      // 添加专业科目按钮
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: FilledButton.icon(
                          icon: Icon(Icons.add_rounded, size: 18),
                          label: Text('添加专业科目'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            minimumSize: Size(double.infinity, 40),
                          ),
                          onPressed: () => _showAddSubjectDialog(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTile({
    required String subject,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
              ? color.withOpacity(0.2)
              : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? color : color.withOpacity(0.8),
            size: 20,
          ),
        ),
        title: Text(
          subject,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected 
              ? color 
              : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        selected: isSelected,
        selectedTileColor: color.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        trailing: showDelete ? IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.error.withOpacity(0.7),
          ),
          onPressed: onDelete,
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.all(4),
        ) : null,
        onTap: onTap,
      ),
    );
  }

  Future<void> _showAddSubjectDialog() async {
    final newSubject = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_rounded, color: colorScheme.secondary, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                '添加专业科目',
                style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: '科目名称',
              hintText: '请输入专业科目名称',
              prefixIcon: Icon(Icons.auto_stories_rounded, color: colorScheme.secondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('添加'),
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
  }

  // 获取科目对应的图标
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case '政治':
        return Icons.account_balance_rounded;
      case '英语':
        return Icons.translate_rounded;
      case '数学':
        return Icons.functions_rounded;
      default:
        return Icons.auto_stories_rounded;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () async {
              if (widget.onThemeModeChanged == null) return;
              final selectedMode = await Navigator.push<ThemeMode>(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentMode: Theme.of(context).brightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  ),
                ),
              );
              if (selectedMode != null) {
                widget.onThemeModeChanged!(selectedMode);
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          // 右侧内容区
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
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
