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
  bool _showEmojiPanel = false;

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

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录')),
      );
      return;
    }

    if (!widget.canSendDanmaku) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('账号无发送权限')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      widget.onSend(text, _currentPosition, _currentColor);
      _controller.clear();
      setState(() => _showEmojiPanel = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _clearInput() {
    _controller.clear();
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + emoji.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            widget.onClose?.call();
          },
          child: Container(
            width: constraints.maxWidth,
            color: Colors.black.withValues(alpha: 0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(),
                      if (!isKeyboardVisible) ...[
                        if (_showEmojiPanel) _buildEmojiPanel(),
                        _buildSettingsPanel(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showEmojiPanel = false;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: Icon(
                  Icons.format_size,
                  color: _labelColor.withValues(alpha: 0.5),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLength: _maxLength,
                  style: const TextStyle(
                    color: _labelColor,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '发个友善的弹幕见证当下',
                    hintStyle: TextStyle(
                      color: _unselectedText.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _clearInput,
                            child: Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCCCCCC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showEmojiPanel = !_showEmojiPanel;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: _showEmojiPanel
                      ? _primaryColor
                      : _labelColor.withValues(alpha: 0.5),
                  size: 22,
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
                child: _isSending
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
                        color: _controller.text.trim().isNotEmpty
                            ? _primaryColor
                            : _unselectedText.withValues(alpha: 0.25),
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          color: isSelected ? _primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _primaryColor : _unselectedText.withValues(alpha: 0.5),
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
          color: isSelected ? _primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _primaryColor : _unselectedText.withValues(alpha: 0.5),
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
            children: _availableColors.asMap().entries.map((entry) {
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
                          color: isSelected
                              ? _primaryColor
                              : Colors.grey.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isSelected
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

  Widget _buildEmojiPanel() {
    final emojis = [
      '😀', '', '🥰', '😎', '🤔', '😱', '🥳', '😴',
      '👍', '👎', '❤️', '💔', '🔥', '⭐', '', '🎊',
      '😍', '🤗', '😏', '', '🤣', '😅', '🙄', '😬',
      '', '🙌', '💪', '🤝', '✌️', '', '🤟', '👀',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: _bgColor,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: emojis.map((emoji) {
          return GestureDetector(
            onTap: () => _insertEmoji(emoji),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
