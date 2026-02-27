import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// A single notification item model.
class NotificationData {
  const NotificationData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.iconData = Icons.notifications_outlined,
    this.iconBg = const Color(0x1FFBD748),
    this.iconColor = AppColors.brandYellow,
    this.isUnread = true,
    this.group = 'Today',
  });

  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData iconData;
  final Color iconBg;
  final Color iconColor;
  final bool isUnread;
  final String group;
}

/// Multipl Design System v5.0 — Notification panel card.
///
/// ```dart
/// NotificationPanel(
///   notifications: _notifs,
///   onMarkAllRead: () => _markAll(),
///   onTap: (n) => _openNotif(n),
/// )
/// ```
class NotificationPanel extends StatelessWidget {
  const NotificationPanel({
    super.key,
    required this.notifications,
    this.onMarkAllRead,
    this.onTap,
    this.width = 360,
  });

  final List<NotificationData> notifications;
  final VoidCallback? onMarkAllRead;
  final ValueChanged<NotificationData>? onTap;
  final double width;

  int get _unreadCount => notifications.where((n) => n.isUnread).length;

  Map<String, List<NotificationData>> get _grouped {
    final map = <String, List<NotificationData>>{};
    for (final n in notifications) {
      map.putIfAbsent(n.group, () => []).add(n);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgWhite,
      borderRadius: AppRadius.input,
      elevation: 8,
      shadowColor: const Color(0x1A0C1220),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PanelHeader(
              unreadCount: _unreadCount,
              onMarkAllRead: onMarkAllRead,
            ),
            const Divider(height: 1, color: AppColors.neutralDivider),
            if (notifications.isEmpty)
              const _EmptyNotifications()
            else
              ..._grouped.entries.map((entry) => _NotificationGroup(
                    groupLabel: entry.key,
                    items: entry.value,
                    onTap: onTap,
                  )),
          ],
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.unreadCount, this.onMarkAllRead});

  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Text('Notifications', style: AppTextStyles.h4),
          if (unreadCount > 0) ...[
            const SizedBox(width: AppSpacing.s8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.brandYellow,
                borderRadius: AppRadius.fullAll,
              ),
              child: Text(
                '$unreadCount',
                style: AppTextStyles.captionCaps.copyWith(
                  color: AppColors.txDark,
                  fontSize: 10,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (onMarkAllRead != null && unreadCount > 0)
            GestureDetector(
              onTap: onMarkAllRead,
              child: Text(
                'Mark all read',
                style: AppTextStyles.captionBody.copyWith(
                  color: AppColors.brandYellow,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  const _NotificationGroup({
    required this.groupLabel,
    required this.items,
    this.onTap,
  });

  final String groupLabel;
  final List<NotificationData> items;
  final ValueChanged<NotificationData>? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s12,
            AppSpacing.s16,
            AppSpacing.s4,
          ),
          child: Text(
            groupLabel,
            style: AppTextStyles.captionCaps.copyWith(color: AppColors.txLight),
          ),
        ),
        ...items.map((n) => NotificationItem(
              data: n,
              onTap: onTap != null ? () => onTap!(n) : null,
            )),
      ],
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s40,
      ),
      child: Column(
        children: [
          Icon(Icons.notifications_none, size: 48, color: AppColors.neutral300),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'No notifications yet',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.txMid),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'You\'re all caught up!',
            style: AppTextStyles.captionBody,
          ),
        ],
      ),
    );
  }
}

/// Single notification row — can also be used standalone.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.data,
    this.onTap,
  });

  final NotificationData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(data.iconData, size: 18, color: data.iconColor),
            ),
            const SizedBox(width: AppSpacing.s12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight:
                          data.isUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: AppTextStyles.captionBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    data.time,
                    style: AppTextStyles.captionBody.copyWith(
                      color: AppColors.txLight,
                    ),
                  ),
                ],
              ),
            ),
            // Unread dot
            if (data.isUnread) ...[
              const SizedBox(width: AppSpacing.s8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.brandYellow,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
