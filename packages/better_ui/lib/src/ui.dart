import 'index.dart';

///
/// 注入到此:
///
abstract class BetterUIInterface {}

class BetterUIInterfaceImpl extends BetterUIInterface {}

///
/// for global use
///
final betterUI = BetterUIInterfaceImpl();
final ui = betterUI;
final UI = betterUI;

///
/// 常用默认统一 UI:
///   - 避免重复代码
///
extension BetterUI on BetterUIInterface {
  /// 自定义通用模板页面集: (常用注册/登录/设置/我的/购物车等)
  BetterTemplate get template => BetterTemplate();

  /// 页面 wrap 方法集:
  BetterWrap get wrap => BetterWrap();

  /// 第三方插件 wrap 集合:
  BetterPlugin get plugin => BetterPlugin();

  /// 自定义布局:
  BetterLayout get layout => BetterLayout();

  /// 自定义样式:
  BetterStyle get style => BetterStyle();

  /// 自定义组件集合:
  BetterMaterial get material => BetterMaterial();

  /// 自定义颜色:
  BetterColor get color => BetterColor();

  /// 工具方法:
  BetterUtil get util => BetterUtil();

  /// 空组件 占位符:
  Widget get empty => SizedBox();

  /////////////////////////////////////////////////////////////////////////////////////////////////
  /// shortcuts for api:
  ///   - 各种 API 的快捷调用
  ///
  /////////////////////////////////////////////////////////////////////////////////////////////////

  /// box style:
  BoxFunction get boxStyle => useBox;

  /// 标准页面:
  StdViewFunc get buildStdView => stdView;

  ///
  /// 默认页面布局:
  ///   - 支持 滑动 标题(也支持隐藏: hasHeader = false)
  ///
  ScrollViewFunc get buildScrollView => scrollView;

  /// 内嵌 tab 页面: 压缩标题高度
  Widget buildTabNestedView({
    required List<Widget> titles, // tab 标题
    required List<Widget> pages, // tab body

    ///
    Widget? drawer,
    Widget? leading,
    List<Widget>? actions, // tab actions

    /// 转换适配 sliver 页面:
    bool toSliver = false,
    bool centerTitle = false,
    Widget? bottomNavigationBar,

    /// 避免底部空白, 页面允许滚动(最末控制)
    bool hasScrollBody = true,
  }) {
    return buildTabView(
      titles: titles,
      pages: pages,
      drawer: drawer,
      leading: leading,
      actions: actions,

      /// 内嵌 tab 页面, 控制标题位置: 是否避开系统状态栏
      primary: false,

      /// 内嵌 tab 页面, 压缩标题栏高度
      preferredSize: Size.fromHeight(10.0),
      toSliver: toSliver,
      centerTitle: centerTitle,
      bottomNavigationBar: bottomNavigationBar,

      /// 避免底部空白, 页面允许滚动(最末控制)
      hasScrollBody: hasScrollBody,
    );
  }

  ///
  /// 构造 tab 页面:
  ///
  Widget buildTabView({
    required List<Widget> titles, // tab 标题
    required List<Widget> pages, // tab body

    ///
    Widget? drawer,
    Widget? leading,
    List<Widget>? actions, // tab actions

    /// 控制 bar 标题位置: 是否避开系统状态栏
    bool? primary,
    Size? preferredSize, // 高度压缩
    bool toSliver = false,
    bool? centerTitle,
    Widget? bottomNavigationBar,

    /// 避免底部空白, 页面允许滚动(最末控制)
    bool hasScrollBody = true,
  }) {
    var v = tabView(
      tabTitles: titles,
      tabPages: pages,

      centerTitle: centerTitle,

      ///
      drawer: drawer,
      leading: leading,
      actions: actions,

      bottomNavigationBar: bottomNavigationBar,

      /// 控制 bar 标题位置: 是否避开系统状态栏
      primary: primary,
      preferredSize: preferredSize,
    );

    return toSliver ? SliverFillRemaining(child: v, hasScrollBody: hasScrollBody) : v;
  }

  ///
  /// 可滑动折叠页面:
  ///   - 默认不传参数, 会生成一个 demo 效果页面布局
  ///
  Widget buildScrollTabView({
    ScrollController? controller,
    List<Widget>? tabTitles, // 标题组件
    List<Widget>? tabPages, // 页面内容
    Widget? leading, // 头
    VoidCallback? backFn, // 返回附加函数
    List<Widget>? actions, // 尾

    /// flex part:
    Widget? flexTitle, // 折叠标题
    Widget? flexBackground, // 折叠背景(图片)

    ///
    bool isBottomTitle = false,
    bool isSplitSysBar = false, // 是否与系统状态栏切分, 背景图覆盖 // 沉浸式: 合并系统状态栏
    bool isScrollable = true, // 可滑动
    bool pinned = true,
    bool centerTitle = true, // 标题居中
    IconThemeData? iconTheme, // 图标配色
    Color? labelColor, // tab 选中颜色
    Color? unselectedLabelColor, // tab 未选中颜色
    Color? indicatorColor, // 选择器颜色
    Color? backgroundColor, // 背景色
    double? fontSize,
    double? indicatorWeight, // 选择器
    double? expandedHeight, // 头部可折叠部分高度
    double? elevation, // 底线
    Brightness? brightness, // 状态栏
  }) {
    return scrollTabView(
      controller: controller,
      tabTitles: tabTitles,
      tabPages: tabPages,
      leading: leading,
      backFn: backFn,
      actions: actions,

      ///
      flexTitle: flexTitle,
      flexBackground: flexBackground,

      ///
      isBottomTitle: isBottomTitle,
      isSplitSysBar: isSplitSysBar,
      isScrollable: isScrollable,
      pinned: pinned,
      centerTitle: centerTitle,
      iconTheme: iconTheme,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      indicatorColor: indicatorColor,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      indicatorWeight: indicatorWeight,
      expandedHeight: expandedHeight,
      elevation: elevation,
      brightness: brightness,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////

  /// 构造 list:
  Widget buildList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,

    /// convert:
    bool toSliver = false, // 转换成 SliverList()

    /// for listView:
    bool shrinkWrap = true,
    ScrollPhysics? physics, // 嵌套滑动冲突解决
    EdgeInsetsGeometry? padding,
    Axis scrollDirection = Axis.vertical,
    ScrollController? controller,

    /// for sep:
    bool hasSeparator = true, // 是否分割线
    double? sepIndent, // 有默认0值 !=null, 否则 = null
    double? sepEndIndent, // 有默认0值 !=null, 否则 = null
    double? sepHeight, // 间隔控制, 原默认=16.0(过大)
    Color? sepColor, // 分割线颜色

    /// for container:
    double? width,
    double? height,
    double? radius, // 圆角
    Color? bgColor, // background color
    EdgeInsetsGeometry? bgPadding,
  }) {
    return layout.body.list.build(
      itemCount: itemCount,
      itemBuilder: itemBuilder,

      ///
      toSliver: toSliver,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      scrollDirection: scrollDirection,
      controller: controller,
      hasSeparator: hasSeparator,
      sepIndent: sepIndent,
      sepEndIndent: sepEndIndent,
      sepHeight: sepHeight,
      sepColor: sepColor,
      width: width,
      height: height,
      radius: radius,
      bgPadding: bgPadding,
    );
  }

  /// 构造 SliverList:
  Widget buildSliverList({
    required itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return layout.body.list.buildSliver(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////

  /// 构造 grid:
  Widget buildGrid({
    required int itemCount, // 计数
    required IndexedWidgetBuilder itemBuilder, // 构造

    ///
    bool toSliver = false, // 转换成 SliverList()
    int? crossAxisCount = 4, // 单行个数
    double? mainAxisSpacing = 0.0, // 垂直间隔
    double? crossAxisSpacing = 0.0, // 水平间隔
    double? childAspectRatio = 1.5, // 宽高比 默认1, 控制高度
    Axis scrollDirection = Axis.vertical,
    ScrollController? controller,
    bool shrinkWrap = true,
    EdgeInsetsGeometry? padding,
  }) {
    return layout.body.grid.build(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      toSliver: toSliver,
      controller: controller,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      // required: 否则要指定高度
      padding: padding ?? EdgeInsets.all(0),
      // required: 去掉 list 外部的间隙 + fix 滚动冲突
      crossAxisCount: crossAxisCount ?? 4,
      mainAxisSpacing: mainAxisSpacing!,
      crossAxisSpacing: crossAxisSpacing!,
      childAspectRatio: childAspectRatio!,
    );
  }

  /// 构造 SliverGrid:
  Widget buildSliverGrid({
    required int itemCount, // 计数
    required IndexedWidgetBuilder itemBuilder, // 构造

    ///
    int crossAxisCount = 4, // 一行多少个
    double mainAxisSpacing = 0.0, // 垂直间隔
    double crossAxisSpacing = 0.0, // 水平间隔
    double childAspectRatio = 1.5, // 宽高比 默认1, 控制高度, 如果出现溢出, 可以设置 1.2/1.3
  }) {
    return layout.body.grid.buildSliver(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////

  /// wrap hook:
  /// 输入法键盘自动隐藏
  Widget withInputWrap({required child}) {
    return wrap.inputView(child: child);
  }
}
