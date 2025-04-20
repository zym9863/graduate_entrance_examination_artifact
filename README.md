[English](README_EN.md)

# 考研神器 (Graduate Entrance Examination Artifact)

一款帮助考研学生高效管理考点和笔记的Flutter应用。

## 应用介绍

考研神器是一款专为考研学生设计的学习辅助工具，帮助用户系统化地管理各科目考点和相关笔记，提高复习效率。应用采用现代化UI设计，操作简便，功能实用。

## 主要功能

### 科目管理
- 内置政治、英语、数学三个固定科目
- 支持添加、编辑和删除专业科目
- 科目分类清晰，便于系统化复习

### 考点管理
- 为每个科目添加重要考点
- 支持考点的添加、编辑和删除
- 考点搜索功能，快速定位所需内容

### 笔记系统
- 为每个考点添加详细笔记
- 笔记支持标题和内容格式
- 笔记的添加、编辑和删除功能
- 笔记搜索功能，方便查找

### 数据持久化
- 使用SharedPreferences本地存储数据
- 自动保存用户添加的所有内容
- 应用重启后数据不丢失

### AI智能答疑
- 针对每条笔记，支持调用AI接口自动生成详细解读和答疑内容
- 支持缓存AI回复，减少重复请求

### 主题设置
- 支持浅色、深色和跟随系统三种主题模式
- 可在设置页面切换主题

## 技术实现

- 使用Flutter框架开发，支持多平台部署
- Material Design 3设计风格
- 响应式UI设计，适配不同屏幕尺寸
- 使用SharedPreferences进行数据持久化存储
- 集成AI接口实现智能答疑功能
- 支持主题切换（浅色/深色/系统）

## 开发环境

- Flutter SDK: ^3.7.2
- Dart SDK: 与Flutter SDK兼容版本
- 依赖包:
  - shared_preferences: ^2.5.3
  - cupertino_icons: ^1.0.8
  - http: ^1.1.0
  - flutter_markdown: ^0.6.18+3

## 安装与使用

1. 确保已安装Flutter环境
2. 克隆项目到本地
3. 运行以下命令安装依赖：
   ```
   flutter pub get
   ```
4. 连接设备或启动模拟器，运行应用：
   ```
   flutter run
   ```

## 项目结构

- `lib/main.dart`: 应用主入口，包含首页和科目管理、主题切换功能
- `lib/note_page.dart`: 笔记页面，实现笔记的增删改查和AI答疑入口
- `lib/ai_response_page.dart`: AI智能答疑页面，自动生成笔记详细解读
- `lib/settings_page.dart`: 设置页面，支持主题切换
- `assets/`: 存放应用图标等资源文件

## 贡献指南

欢迎提交Issue或Pull Request来完善本项目。
