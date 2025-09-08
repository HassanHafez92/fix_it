import 'package:flutter/material.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import '../../domain/entities/notification_entity.dart';

String getNotificationTypeDisplayName(BuildContext context, NotificationType type) {
  final l10n = AppLocalizations.of(context)!;
  switch (type) {
    case NotificationType.bookingConfirmation:
      return l10n.notificationType_bookingConfirmation;
    case NotificationType.bookingCancelled:
      return l10n.notificationType_bookingCancelled;
    case NotificationType.bookingCompleted:
      return l10n.notificationType_bookingCompleted;
    case NotificationType.paymentSuccess:
      return l10n.notificationType_paymentSuccess;
    case NotificationType.paymentFailed:
      return l10n.notificationType_paymentFailed;
    case NotificationType.specialOffer:
      return l10n.notificationType_specialOffer;
    case NotificationType.appUpdate:
      return l10n.notificationType_appUpdate;
    case NotificationType.reviewRequest:
      return l10n.notificationType_reviewRequest;
    case NotificationType.bookingReminder:
      return l10n.notificationType_bookingReminder;
    case NotificationType.providerAssigned:
      return l10n.notificationType_providerAssigned;
    case NotificationType.general:
      return l10n.notificationType_general;
  }
}
