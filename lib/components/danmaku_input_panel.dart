import 'package:flutter/material.dart';

class DanmakuInputPanel extends StatefulWidget {
  final bool isFullScreen;
  final Function(String text, int position, Color color) onSend;
  final VoidCallback? onClose;
  final bool isLoggedIn;
  final bool canSendDanmaku;
  final String? initialText;

  const DanmakuInputPanel({
    super.key,
    this.isFullScreen = false,
    required this.onSend,
    this.onClose,
    this.isLoggedIn = true,
    this.canSendDanmaku = true,
    this.initialText,
  });

  @override
  State<DanmakuInputPanel> createState() => _DanmakuInputPanelState();
}

class _DanmakuInputPanelState extends State<DanmakuInputPanel> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _currentPosition = 0;
  int _fontSize = 0;
  Color _currentColor = Colors.white;
  bool _isSending = false;

  // 新增：用于记录上一帧键盘是否可见
  bool _wasKeyboardVisible = false;

  static const int _maxLength = 100;
  static const Color _primaryColor = Color(0xFFFF6B9E);
  static const Color _unselectedBg = Color(0xFFE0E0E0);
  static const Color _unselectedText = Color(0xFF666666);
  static const Color _labelColor = Color(0xFF333333);
  static const Color _bgColor = Color(0xFFF5F5F5);

  static const List<Map<String, dynamic>> _availableColors = [
    {'color': Colors.white, 'isVip': false},
    {'color': Color(0xFFE8A0BF), 'isVip': true},
    {'color': Colors.red, 'isVip': false},
    {'color': Colors.yellow, 'isVip': false},
    {'color': Colors.green, 'isVip': false},
    {'color': Colors.blue, 'isVip': false},
    {'color': Color(0xFFE91E63), 'isVip': false},
    {'color': Color(0xFF8BC34A), 'isVip': false},
    {'color': Color(0xFF1A237E), 'isVip': false},
    {'color': Color(0xFFFF9800), 'isVip': false},
    {'color': Color(0xFF673AB7), 'isVip': false},
    {'color': Color(0xFF80CBC4), 'isVip': false},
    {'color': Color(0xFF8D6E63), 'isVip': false},
  ];

  bool _hasInitialFocused = false; // 增加一个锁

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialFocused) {
        _focusNode.requestFocus();
        _hasInitialFocused = true; // 执行一次后锁定
      }
    });
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendDanmaku() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    if (!widget.isLoggedIn) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先登录')));
      return;
    }

    if (!widget.canSendDanmaku) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('账号无发送权限')));
      return;
    }

    setState(() => _isSending = true);

    try {
      widget.onSend(text, _currentPosition, _currentColor);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('发送失败: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _clearInput() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          _buildSettingsPanel(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
            },
            child: Text(
              "A",
              style: TextStyle(
                color:
                    _focusNode.hasFocus
                        ? _primaryColor
                        : _unselectedText.withValues(alpha: 0.5),
                fontSize: 20,
                decoration: TextDecoration.underline,
                decorationColor:
                    _focusNode.hasFocus
                        ? _primaryColor
                        : _unselectedText.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: _maxLength,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  color: _labelColor,
                  fontSize: 14,
                  textBaseline: TextBaseline.alphabetic,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 0,
                  ),
                  hintText: '发个友善的弹幕见证当下',
                  hintStyle: TextStyle(
                    color: _unselectedText.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? GestureDetector(
                            onTap: _clearInput,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCCCCCC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                          )
                          : null,
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _controller.text.trim().isNotEmpty ? _sendDanmaku : null,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child:
                  _isSending
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _primaryColor,
                        ),
                      )
                      : Icon(
                        Icons.send,
                        color:
                            _controller.text.trim().isNotEmpty
                                ? _primaryColor
                                : _unselectedText.withValues(alpha: 0.25),
                        size: 20,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 65),
      decoration: const BoxDecoration(color: _bgColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFontSizeSection(),
          const SizedBox(height: 24),
          _buildPositionSection(),
          const SizedBox(height: 24),
          _buildColorSection(),
        ],
      ),
    );
  }

  Widget _buildFontSizeSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '字体大小',
            style: TextStyle(
              color: _labelColor.withValues(alpha: 0.4),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFontSizeButton('默认', 0, true),
        const SizedBox(width: 12),
        _buildFontSizeButton('较小', 1, false),
      ],
    );
  }

  Widget _buildFontSizeButton(String label, int value, bool isLarge) {
    final isSelected = _fontSize == value;
    return GestureDetector(
      onTap: () => setState(() => _fontSize = value),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? _primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? _primaryColor
                    : _unselectedText.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A',
              style: TextStyle(
                color: isSelected ? _primaryColor : _unselectedText,
                fontSize: isLarge ? 18 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _primaryColor : _unselectedText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '弹幕位置',
            style: TextStyle(
              color: _labelColor.withValues(alpha: 0.4),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildPositionButton('滚动', 0, Icons.view_stream),
        const SizedBox(width: 12),
        _buildPositionButton('置顶', 1, Icons.vertical_align_top),
        const SizedBox(width: 12),
        _buildPositionButton('置底', 2, Icons.vertical_align_bottom),
      ],
    );
  }

  Widget _buildPositionButton(String label, int position, IconData icon) {
    final isSelected = _currentPosition == position;
    return GestureDetector(
      onTap: () => setState(() => _currentPosition = position),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? _primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? _primaryColor
                    : _unselectedText.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? _primaryColor : _unselectedText,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _primaryColor : _unselectedText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '弹幕颜色',
              style: TextStyle(
                color: _labelColor.withValues(alpha: 0.4),
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                _availableColors.asMap().entries.map((entry) {
                  final colorData = entry.value;
                  final color = colorData['color'] as Color;
                  final isVip = colorData['isVip'] as bool;
                  final isSelected = _currentColor == color;

                  return GestureDetector(
                    onTap: () {
                      if (isVip) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('开通会员可使用更多颜色')),
                        );
                        return;
                      }
                      setState(() => _currentColor = color);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? _primaryColor
                                      : Colors.grey.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: _primaryColor,
                                    size: 16,
                                  )
                                  : null,
                        ),
                        if (isVip)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '会员',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
