import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

/// 播放器状态管理器
/// 封装播放器状态检查、安全控制和生命周期管理
class PlayerStateManager {
  bool _isPlayerInitialized = false;
  bool _isPlayerReleased = false;
  bool _isPageActive = true;

  bool get isPlayerInitialized => _isPlayerInitialized;
  bool get isPlayerReleased => _isPlayerReleased;
  bool get isPageActive => _isPageActive;

  set isPlayerInitialized(bool value) => _isPlayerInitialized = value;
  set isPlayerReleased(bool value) => _isPlayerReleased = value;
  set isPageActive(bool value) => _isPageActive = value;

  /// 立即暂停播放器
  /// 仅在页面活跃时执行暂停操作
  void pausePlayerImmediately(Player player) {
    try {
      if (_isPageActive) {
        player.pause();
        debugPrint('Player paused immediately');
      } else {
        debugPrint('Player not paused - page inactive or player not playable');
      }
    } catch (e) {
      debugPrint('Error pausing player immediately: $e');
    }
  }

  /// 根据需要恢复播放
  /// 检查播放器状态是否准备好恢复播放
  void resumePlayerIfNeeded() {
    try {
      if (_isPlayerInitialized && !_isPlayerReleased) {
        debugPrint('Player ready to resume, but not auto-resuming');
      }
    } catch (e) {
      debugPrint('Error resuming player: $e');
    }
  }

  /// 全局播放器状态安全检查
  /// 1. 如果页面不活跃但播放器在播放，强制暂停
  /// 2. 如果播放器已释放但标记为已初始化，修正状态
  void ensurePlayerSafety(Player player) {
    try {
      if (!_isPageActive && player.state.playing) {
        debugPrint(
          'Safety check: Page inactive but player playing, forcing pause',
        );
        player.pause();
      }

      if (_isPlayerReleased && _isPlayerInitialized) {
        _isPlayerInitialized = false;
        debugPrint('Safety check: Corrected player initialization state');
      }
    } catch (e) {
      debugPrint('Safety check error: $e');
    }
  }

  /// 页面离开时的处理
  /// 用于记录播放行为或其他清理操作
  void onPageLeave(VoidCallback onViewsAdded) {
    onViewsAdded();
    debugPrint('Views recorded on page leave');
  }

  /// 释放播放器资源
  void releasePlayer() {
    _isPlayerReleased = true;
    _isPlayerInitialized = false;
    debugPrint('Player released');
  }

  /// 重置所有状态
  void reset() {
    _isPlayerInitialized = false;
    _isPlayerReleased = false;
    _isPageActive = true;
  }
}
