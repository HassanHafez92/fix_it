import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../domain/entities/faq_entity.dart';

class ContactSection extends StatelessWidget {
  final List<ContactInfoEntity> contactMethods;

  const ContactSection({
    super.key,
    required this.contactMethods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طرق التواصل',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),

        ...contactMethods.map((contact) => _ContactMethodItem(
          contactInfo: contact,
          onTap: () => _handleContactTap(context, contact),
        )),
      ],
    );
  }

  void _handleContactTap(BuildContext context, ContactInfoEntity contact) async {
    try {
      Uri uri;

      switch (contact.type) {
        case ContactType.email:
          uri = Uri.parse('mailto:${contact.value}');
          break;
        case ContactType.phone:
          uri = Uri.parse('tel:${contact.value}');
          break;
        case ContactType.whatsapp:
          uri = Uri.parse('https://wa.me/${contact.value}');
          break;
        case ContactType.website:
          uri = Uri.parse(contact.value);
          break;
        case ContactType.social:
          uri = Uri.parse(contact.value);
          break;
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'لا يمكن فتح ${contact.description}',
                style: GoogleFonts.cairo(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ في فتح ${contact.description}',
              style: GoogleFonts.cairo(),
            ),
          ),
        );
      }
    }
  }
}

class _ContactMethodItem extends StatelessWidget {
  final ContactInfoEntity contactInfo;
  final VoidCallback onTap;

  const _ContactMethodItem({
    required this.contactInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: _getContactColor(contactInfo.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getContactIcon(contactInfo.type),
                  color: _getContactColor(contactInfo.type),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactInfo.type.displayName,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contactInfo.description,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: const Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contactInfo.value,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getContactColor(contactInfo.type),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: const Color(0xFF718096),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getContactColor(ContactType type) {
    switch (type) {
      case ContactType.email:
        return Colors.blue;
      case ContactType.phone:
        return Colors.green;
      case ContactType.whatsapp:
        return const Color(0xFF25D366);
      case ContactType.website:
        return Colors.purple;
      case ContactType.social:
        return Colors.orange;
    }
  }

  IconData _getContactIcon(ContactType type) {
    switch (type) {
      case ContactType.email:
        return Icons.email;
      case ContactType.phone:
        return Icons.phone;
      case ContactType.whatsapp:
        return Icons.chat;
      case ContactType.website:
        return Icons.language;
      case ContactType.social:
        return Icons.share;
    }
  }
}