import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack 图层魔法',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        scaffoldBackgroundColor: const Color(0xFFF4F1E8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F1E8),
          foregroundColor: Color(0xFF1E2A2A),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1E2A2A),
          displayColor: const Color(0xFF1E2A2A),
        ),
      ),
      home: const StackMagicDemoPage(),
    );
  }
}

enum DemoViewMode { interactive, poster }

class StackMagicDemoPage extends StatefulWidget {
  const StackMagicDemoPage({super.key});

  @override
  State<StackMagicDemoPage> createState() => _StackMagicDemoPageState();
}

class _StackMagicDemoPageState extends State<StackMagicDemoPage> {
  bool _showLoading = false;
  bool _useExpandedFit = false;
  bool _isExpanded = false;
  int _selectedIndex = 0;
  DemoViewMode _viewMode = DemoViewMode.interactive;

  void _toggleLoading() {
    setState(() {
      _showLoading = !_showLoading;
    });
  }

  List<Widget> _buildPosterSections() {
    return const [
      _PosterIntroCard(),
      SizedBox(height: 18),
      _PosterPanel(
        eyebrow: '01',
        title: '自由叠加',
        subtitle: '后声明的 child 会覆盖先声明的 child，就像在设计工具里不断加图层。',
        footer: '适合用来做封面图、引导页主视觉和卡片叠层。',
        child: _PosterLayerScene(),
      ),
      SizedBox(height: 18),
      _PosterPanel(
        eyebrow: '02',
        title: '绝对定位',
        subtitle: '角标、按钮和说明标签通过 Positioned 精准压在内容的指定边缘。',
        footer: '典型场景是商品卡片、运营角标和局部悬浮操作。',
        child: _PosterPositionScene(),
      ),
      SizedBox(height: 18),
      _PosterPanel(
        eyebrow: '03',
        title: '头像状态',
        subtitle: 'clipBehavior: Clip.none 让状态点稍微越界，看起来更像真实的社交产品。',
        footer: '在线点、徽标、未读角标，都是 Stack 的高频用法。',
        child: _PosterStatusScene(),
      ),
      SizedBox(height: 18),
      _PosterPanel(
        eyebrow: '04',
        title: '蒙层覆盖',
        subtitle: '把半透明遮罩和加载指示器压在内容上层，就能快速得到沉浸式状态反馈。',
        footer: '加载中、支付处理中、操作引导，都可以用同一套思路实现。',
        child: _PosterOverlayScene(),
      ),
      SizedBox(height: 18),
      _PosterPanel(
        eyebrow: '05',
        title: 'IndexedStack',
        subtitle: '一次只显示一个 child，但其它 child 的状态仍然留在内存里，不会被销毁。',
        footer: '底部导航、内容切页、保留滚动位置，都适合用这个模式。',
        child: _PosterIndexedScene(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('解锁 Flutter 的 Stack')),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                _HeroBanner(showLoading: _showLoading),
                const SizedBox(height: 18),
                _ModeSwitchCard(
                  viewMode: _viewMode,
                  onChanged: (DemoViewMode viewMode) {
                    setState(() {
                      _viewMode = viewMode;
                      if (viewMode == DemoViewMode.poster) {
                        _showLoading = false;
                      }
                    });
                  },
                ),
                const SizedBox(height: 18),
                if (_viewMode == DemoViewMode.interactive) ...[
                  _DemoSection(
                    title: '基础叠加',
                    description:
                        '三个未定位子组件默认会跟随 alignment 对齐，后声明的 child 会覆盖前一个。',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _DemoCanvas(
                          height: 220,
                          child: Center(
                            child: SizedBox(
                              width: 210,
                              height: 210,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _LayerTile(
                                    size: 176,
                                    color: Color(0xFFE76F51),
                                    label: '底层',
                                    angle: -0.12,
                                  ),
                                  _LayerTile(
                                    size: 128,
                                    color: Color(0xFF2A9D8F),
                                    label: '中层',
                                    angle: 0.08,
                                  ),
                                  _LayerTile(
                                    size: 88,
                                    color: Color(0xFF264653),
                                    label: '顶层',
                                    angle: -0.04,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '这里没有任何 Positioned，所以它们只是在同一个坐标系里逐层叠放。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: '对齐与绝对定位',
                    description:
                        '未定位子组件走 alignment，定位子组件走 left / top / right / bottom。',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DemoCanvas(
                          height: 190,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F6EF),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: const Color(0xFFE0D7CA),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 144,
                                  height: 108,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD7EFEA),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 40, top: 38),
                                child: SizedBox(
                                  width: 96,
                                  height: 72,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF76C4B7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 18,
                                bottom: 18,
                                child: _AnchorTag(
                                  label: 'right: 18\nbottom: 18',
                                  color: Color(0xFF264653),
                                  textColor: Colors.white,
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 24,
                                child: Text(
                                  'alignment: topLeft',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: const Color(0xFF4E5B5B),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '左上角两块是未定位子组件，都会贴着 alignment 走；右下角标签则被 Positioned 锁定到容器边缘。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: '头像在线状态',
                    description:
                        '右下角的小绿点是最常见的 Stack 场景之一，通常还会搭配 clipBehavior: Clip.none。',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 116,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatusAvatar(
                                initials: 'LI',
                                name: 'Lina',
                                accent: Color(0xFFE9C46A),
                                online: true,
                              ),
                              _StatusAvatar(
                                initials: 'MO',
                                name: 'Momo',
                                accent: Color(0xFF84A59D),
                                online: true,
                              ),
                              _StatusAvatar(
                                initials: 'KE',
                                name: 'Kero',
                                accent: Color(0xFFF28482),
                                online: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '状态点故意略微超出头像边缘，这样更接近真实社交应用的视觉表现。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: '卡片角标',
                    description: '电商卡片上的“新品”“热卖”通常就是一个 Positioned 标签覆盖在主内容之上。',
                    child: Center(
                      child: SizedBox(
                        width: 320,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDFCF9),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFE7DED2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFDDEFE8),
                                          Color(0xFFB8DDD2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.headphones_rounded,
                                      size: 44,
                                      color: Color(0xFF295B57),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Layer Pods Pro',
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '用一个 Stack 叠出角标、收藏和价格区。',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF5D6666),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          '¥ 699',
                                          style: textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF0F766E),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              left: 0,
                              top: 0,
                              child: _CornerBadge(label: '新品'),
                            ),
                            Positioned(
                              right: 16,
                              bottom: -16,
                              child: Material(
                                color: const Color(0xFF0F766E),
                                shape: const CircleBorder(),
                                elevation: 6,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {},
                                  child: const SizedBox(
                                    width: 52,
                                    height: 52,
                                    child: Icon(
                                      Icons.add_shopping_cart_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: '悬浮按钮与蒙层',
                    description: '这个页面本身就是一个大 Stack：底层是滚动内容，右下角按钮和加载蒙层都叠在上面。',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DemoCanvas(
                          height: 170,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: List.generate(
                                      4,
                                      (int index) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Container(
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                                ? const Color(0xFFE5EEE9)
                                                : const Color(0xFFF0E8DB),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 16,
                                bottom: 16,
                                child: _MiniFloatingButton(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '点击页面右下角“显示蒙层”，就能看到一个全屏半透明覆盖层压在所有内容之上。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: 'fit 属性',
                    description:
                        'fit 只影响未定位子组件。StackFit.loose 保持内容尺寸，StackFit.expand 则让它铺满可用区域。',
                    trailing: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(value: false, label: Text('loose')),
                        ButtonSegment<bool>(value: true, label: Text('expand')),
                      ],
                      selected: <bool>{_useExpandedFit},
                      showSelectedIcon: false,
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() {
                          _useExpandedFit = selection.first;
                        });
                      },
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DemoCanvas(
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Stack(
                              fit: _useExpandedFit
                                  ? StackFit.expand
                                  : StackFit.loose,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: _useExpandedFit
                                        ? const Color(0xFFDDEFE8)
                                        : const Color(0xFFF0E8DB),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      _useExpandedFit
                                          ? 'StackFit.expand\n未定位子组件已经铺满整个舞台'
                                          : 'StackFit.loose\n未定位子组件保持自己的内容大小',
                                      textAlign: TextAlign.center,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: _AnchorTag(
                                    label: 'Positioned',
                                    color: Color(0xFF264653),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '注意右上角标签始终不受 fit 影响，因为它本身是定位子组件。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: 'IndexedStack 保留状态',
                    description: '切换展示面板时，隐藏的子组件不会销毁，因此局部状态可以继续保留。',
                    trailing: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment<int>(
                          value: 0,
                          icon: Icon(Icons.home_rounded),
                          label: Text('首页'),
                        ),
                        ButtonSegment<int>(
                          value: 1,
                          icon: Icon(Icons.search_rounded),
                          label: Text('搜索'),
                        ),
                        ButtonSegment<int>(
                          value: 2,
                          icon: Icon(Icons.person_rounded),
                          label: Text('我的'),
                        ),
                      ],
                      selected: <int>{_selectedIndex},
                      showSelectedIcon: false,
                      onSelectionChanged: (Set<int> selection) {
                        setState(() {
                          _selectedIndex = selection.first;
                        });
                      },
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 220,
                            child: IndexedStack(
                              index: _selectedIndex,
                              children: const [
                                _IndexedCounterPane(
                                  title: '首页',
                                  subtitle: '切出去再回来，计数还在。',
                                  icon: Icons.home_rounded,
                                  accent: Color(0xFFE9C46A),
                                ),
                                _IndexedCounterPane(
                                  title: '搜索',
                                  subtitle: '这类状态很适合底部导航切页。',
                                  icon: Icons.search_rounded,
                                  accent: Color(0xFF84A59D),
                                ),
                                _IndexedCounterPane(
                                  title: '我的',
                                  subtitle: '表单输入、滚动位置也能这样保留。',
                                  icon: Icons.person_rounded,
                                  accent: Color(0xFFF28482),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '先在某个面板里点几次“加 1”，再切换到别的 tab 后返回，就能看到状态没有丢失。',
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF5D6666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DemoSection(
                    title: '动画定位',
                    description: 'Stack 不只负责叠放，配合 AnimatedPositioned 还能把图层动起来。',
                    trailing: FilledButton.tonalIcon(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: Icon(
                        _isExpanded
                            ? Icons.compress_rounded
                            : Icons.open_in_full_rounded,
                      ),
                      label: Text(_isExpanded ? '回到起点' : '展开图层'),
                    ),
                    child: _DemoCanvas(
                      height: 220,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 18,
                            top: 18,
                            right: 18,
                            child: Text(
                              '点击上面的按钮，观察图层在两组坐标之间平滑过渡。',
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF5D6666),
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 480),
                            curve: Curves.easeInOutCubic,
                            left: _isExpanded ? 18 : 138,
                            top: _isExpanded ? 56 : 124,
                            child: _AnimatedLayerBlob(expanded: _isExpanded),
                          ),
                          Positioned(
                            right: 18,
                            bottom: 18,
                            child: Text(
                              _isExpanded ? '展开状态' : '收起状态',
                              style: textTheme.labelLarge?.copyWith(
                                color: const Color(0xFF4E5B5B),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E6D8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD7C3A7)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.tips_and_updates_rounded,
                          color: Color(0xFF9A5A2C),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '补充一点：较新的 Flutter 版本已经移除了旧的 overflow 参数。想让超出边界的子组件继续显示，请使用 clipBehavior: Clip.none。',
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6D4B2F),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ..._buildPosterSections(),
                ],
              ],
            ),
            if (_viewMode == DemoViewMode.interactive)
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'overlay-demo',
                  onPressed: _toggleLoading,
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  icon: Icon(
                    _showLoading
                        ? Icons.visibility_off_rounded
                        : Icons.layers_rounded,
                  ),
                  label: Text(_showLoading ? '关闭蒙层' : '显示蒙层'),
                ),
              ),
            if (_showLoading && _viewMode == DemoViewMode.interactive)
              Positioned.fill(child: _LoadingOverlay(onClose: _toggleLoading)),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.showLoading});

  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF163832), Color(0xFF23514A), Color(0xFFB8683E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33163832),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stack 图层魔法实验室',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '一个页面串起悬浮、重叠、绝对定位、角标、蒙层和 IndexedStack 的典型用法。',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                showLoading
                                    ? Icons.visibility_rounded
                                    : Icons.layers_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  showLoading ? '全局蒙层：开启' : '全局蒙层：关闭',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: _HeroLayers(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FeatureChip(label: '自由叠加'),
                  _FeatureChip(label: '精准定位'),
                  _FeatureChip(label: '状态保留'),
                  _FeatureChip(label: '蒙层覆盖'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroLayers extends StatelessWidget {
  const _HeroLayers();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _LayerTile(
            size: 82,
            color: Color(0xFFF4A261),
            label: '',
            angle: -0.18,
            showLabel: false,
          ),
          _LayerTile(
            size: 66,
            color: Color(0xFF6AC3B6),
            label: '',
            angle: 0.1,
            showLabel: false,
          ),
          _LayerTile(
            size: 50,
            color: Color(0xFFFFFFFF),
            label: '',
            angle: -0.04,
            showLabel: false,
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ModeSwitchCard extends StatelessWidget {
  const _ModeSwitchCard({required this.viewMode, required this.onChanged});

  final DemoViewMode viewMode;
  final ValueChanged<DemoViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7DED2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '浏览模式',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '交互演示模式适合边看边点，文章配图模式适合直接截图发文。',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D6666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SegmentedButton<DemoViewMode>(
            segments: const [
              ButtonSegment<DemoViewMode>(
                value: DemoViewMode.interactive,
                icon: Icon(Icons.tune_rounded),
                label: Text('交互演示'),
              ),
              ButtonSegment<DemoViewMode>(
                value: DemoViewMode.poster,
                icon: Icon(Icons.photo_library_rounded),
                label: Text('文章配图'),
              ),
            ],
            selected: <DemoViewMode>{viewMode},
            showSelectedIcon: false,
            onSelectionChanged: (Set<DemoViewMode> selection) {
              onChanged(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class _PosterIntroCard extends StatelessWidget {
  const _PosterIntroCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17342F),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2617342F),
            blurRadius: 22,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '文章配图模式',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '下面这些卡片是为截图场景重新排版的海报视图。每一张都围绕一个 Stack 能力点来组织画面，适合单独截图后插入文章。',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeatureChip(label: '封面可截图'),
              _FeatureChip(label: '画面更完整'),
              _FeatureChip(label: '文案更少'),
              _FeatureChip(label: '更适合发文'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PosterPanel extends StatelessWidget {
  const _PosterPanel({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.footer,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F1EE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              eyebrow,
              style: textTheme.labelLarge?.copyWith(
                color: const Color(0xFF0F766E),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF5D6666),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(aspectRatio: 4 / 5, child: child),
          ),
          const SizedBox(height: 14),
          Text(
            footer,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D6666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterLayerScene extends StatelessWidget {
  const _PosterLayerScene();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF17342F), Color(0xFF275750), Color(0xFFCF8451)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -36,
            right: -24,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 24,
            right: 24,
            child: Text(
              'Stack\n像图层一样把元素堆起来',
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
          ),
          const Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _LayerTile(
                    size: 190,
                    color: Color(0xFFE76F51),
                    label: '底层',
                    angle: -0.14,
                  ),
                  _LayerTile(
                    size: 138,
                    color: Color(0xFF2A9D8F),
                    label: '中层',
                    angle: 0.08,
                  ),
                  _LayerTile(
                    size: 96,
                    color: Color(0xFF264653),
                    label: '顶层',
                    angle: -0.03,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Text(
              '没有 Positioned 时，所有子组件共享同一块舞台，由 alignment 决定它们的默认对齐方式。',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterPositionScene extends StatelessWidget {
  const _PosterPositionScene();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6F2E9), Color(0xFFE8DDD1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 24,
            left: 24,
            child: Text(
              'Positioned 可以把角标、按钮和提示\n固定到卡片边缘。',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF253333),
                height: 1.35,
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 118,
            bottom: 28,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x21000000),
                        blurRadius: 24,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDDEFE8), Color(0xFFB7DACE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.watch_rounded,
                              size: 74,
                              color: Color(0xFF295B57),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Layer Watch S',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '新品角标、收藏按钮、价格说明都能压在主内容之上。',
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5D6666),
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '¥ 1,299',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F766E),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  top: 0,
                  child: _CornerBadge(label: '热卖'),
                ),
                const Positioned(
                  right: 12,
                  top: 14,
                  child: _AnchorTag(
                    label: 'top: 14',
                    color: Color(0xFF264653),
                    textColor: Colors.white,
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: -16,
                  child: Material(
                    color: const Color(0xFF0F766E),
                    shape: const CircleBorder(),
                    elevation: 8,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const SizedBox(
                        width: 62,
                        height: 62,
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterStatusScene extends StatelessWidget {
  const _PosterStatusScene();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCF8F1), Color(0xFFF0E4D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            right: 24,
            child: Text(
              '在线状态点经常故意越界一点点。\n那一小步，画面会自然很多。',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            top: 126,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusAvatar(
                  initials: 'LI',
                  name: 'Lina',
                  accent: Color(0xFFE9C46A),
                  online: true,
                ),
                _StatusAvatar(
                  initials: 'MO',
                  name: 'Momo',
                  accent: Color(0xFF84A59D),
                  online: true,
                ),
                _StatusAvatar(
                  initials: 'KE',
                  name: 'Kero',
                  accent: Color(0xFFF28482),
                  online: false,
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x16000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                'clipBehavior: Clip.none\n让状态点不要被头像边缘裁掉。',
                style: textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF4E5B5B),
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Positioned(
            right: 24,
            bottom: 28,
            child: _AnchorTag(
              label: 'right: -1\nbottom: -1',
              color: Color(0xFF17342F),
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterOverlayScene extends StatelessWidget {
  const _PosterOverlayScene();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF9F4EB), Color(0xFFF1E6D8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: List.generate(
                6,
                (int index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    height: index == 0 ? 88 : 28,
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? const Color(0xFFE7EFEA)
                          : const Color(0xFFE5DDD1),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.54)),
        ),
        Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                const SizedBox(height: 18),
                Text(
                  '加载中...',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '蒙层已经覆盖在主内容上方',
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5D6666),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 24,
          top: 24,
          right: 24,
          child: Text(
            '内容层\n蒙层\n反馈层',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
        ),
      ],
    );
  }
}

class _PosterIndexedScene extends StatelessWidget {
  const _PosterIndexedScene();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEEF5F1), Color(0xFFDDEBE3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            right: 24,
            child: Text(
              'IndexedStack 只显示一个页面，\n但其它页面状态不会被重置。',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.35,
                color: const Color(0xFF213131),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            top: 132,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 20,
                  child: Container(
                    width: 236,
                    height: 230,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8C8BE),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Container(
                    width: 252,
                    height: 246,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8DDD5),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                Container(
                  width: 272,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: _PosterTabChip(label: '首页', selected: false),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _PosterTabChip(label: '搜索', selected: true),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _PosterTabChip(label: '我的', selected: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '当前仅展示：搜索页',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '背后的首页与我的页面仍然保留着各自状态，比如滚动位置、输入内容和局部计数。',
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5D6666),
                          height: 1.55,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F1EE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '保留状态，不重新 build 页面树',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F766E),
                          ),
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
}

class _PosterTabChip extends StatelessWidget {
  const _PosterTabChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0F766E) : const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? Colors.white : const Color(0xFF516060),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    required this.title,
    required this.description,
    required this.child,
    this.trailing,
  });

  final String title;
  final String description;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D6666),
              height: 1.5,
            ),
          ),
          if (trailing != null) ...[const SizedBox(height: 14), trailing!],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DemoCanvas extends StatelessWidget {
  const _DemoCanvas({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7DED2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _LayerTile extends StatelessWidget {
  const _LayerTile({
    required this.size,
    required this.color,
    required this.label,
    this.angle = 0,
    this.showLabel = true,
  });

  final double size;
  final Color color;
  final String label;
  final double angle;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: showLabel
            ? Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              )
            : null,
      ),
    );
  }
}

class _AnchorTag extends StatelessWidget {
  const _AnchorTag({
    required this.label,
    required this.color,
    this.textColor = const Color(0xFF1E2A2A),
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

class _StatusAvatar extends StatelessWidget {
  const _StatusAvatar({
    required this.initials,
    required this.name,
    required this.accent,
    required this.online,
  });

  final String initials;
  final String name;
  final Color accent;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.92),
                      accent.withValues(alpha: 0.62),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF1E2A2A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: online
                        ? const Color(0xFF36A86A)
                        : const Color(0xFFB8B2A8),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _CornerBadge extends StatelessWidget {
  const _CornerBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFE76F51),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniFloatingButton extends StatelessWidget {
  const _MiniFloatingButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF0F766E),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x330F766E),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.layers_rounded, color: Colors.white),
    );
  }
}

class _IndexedCounterPane extends StatefulWidget {
  const _IndexedCounterPane({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  @override
  State<_IndexedCounterPane> createState() => _IndexedCounterPaneState();
}

class _IndexedCounterPaneState extends State<_IndexedCounterPane> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: widget.accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: const Color(0xFF1E2A2A)),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF495555),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '本地计数：$_count',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _count++;
              });
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('加 1'),
          ),
        ],
      ),
    );
  }
}

class _AnimatedLayerBlob extends StatelessWidget {
  const _AnimatedLayerBlob({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeInOutCubic,
      width: expanded ? 132 : 80,
      height: expanded ? 132 : 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A9D8F), Color(0xFF1D6F78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(expanded ? 30 : 22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332A9D8F),
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        expanded ? '展开' : '收起',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(strokeWidth: 3),
                  const SizedBox(height: 16),
                  Text(
                    '加载中...',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击任意处关闭',
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D6666),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
