import 'package:flutter/material.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import '../../domain/entities/faq_entity.dart';

String getContactTypeDisplayName(BuildContext context, ContactType type) {
  final l10n = AppLocalizations.of(context)!;
  switch (type) {
    case ContactType.email:
      return l10n.contactType_email;
    case ContactType.phone:
      return l10n.contactType_phone;
    case ContactType.whatsapp:
      return l10n.contactType_whatsapp;
    case ContactType.website:
      return l10n.contactType_website;
    case ContactType.social:
      return l10n.contactType_social;
  }
}
