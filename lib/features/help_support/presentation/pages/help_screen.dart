// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fix_it/l10n/app_localizations.dart';


import '../widgets/faq_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/help_search_bar.dart';
import '../../domain/entities/faq_entity.dart';
/// HelpScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// HelpScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
/// dispose
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
/// dispose
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          l10n.helpAndSupport,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(text: l10n.faq),
            Tab(text: l10n.contactUs),
            Tab(text: l10n.aboutApp),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: theme.primaryColor,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: HelpSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onClear: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // FAQ Tab
                _buildFAQTab(context),

                // Contact Tab
                _buildContactTab(context),

                // About Tab
                _buildAboutTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchQuery.isEmpty) ...[
            // FAQ Categories
            Text(
              l10n.categories,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CategoryChip(
                  label: l10n.bookings,
                  icon: Icons.book_online,
                  onTap: () => _filterByCategory('bookings'),
                ),
                _CategoryChip(
                  label: l10n.payments,
                  icon: Icons.payment,
                  onTap: () => _filterByCategory('payments'),
                ),
                _CategoryChip(
                  label: l10n.account,
                  icon: Icons.account_circle,
                  onTap: () => _filterByCategory('account'),
                ),
                _CategoryChip(
                  label: l10n.services,
                  icon: Icons.build,
                  onTap: () => _filterByCategory('services'),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],

          // FAQ List
          FAQSection(
            faqs: _getFilteredFAQs(context),
            searchQuery: _searchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.headset_mic,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.weAreHereToHelp,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.customerSupportHint,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Contact Methods
          ContactSection(
            contactMethods: _getContactMethods(context),
          ),

          const SizedBox(height: 24),

          // Send Message Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openEmailClient(context),
              icon: const Icon(Icons.email),
              label: Text(
                l10n.sendDirectMessage,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // App Logo and Info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.build_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fix It',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.appVersion,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appDescription,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: const Color(0xFF718096),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Features
          _AboutSection(
            title: l10n.appFeatures,
            items: [
              l10n.feature_certifiedTechnicians,
              l10n.feature_247Support,
              l10n.feature_transparentPricing,
              l10n.feature_serviceWarranty,
              l10n.feature_liveTracking,
              l10n.feature_realReviews,
            ],
          ),

          const SizedBox(height: 16),

          // Legal Links
          _AboutSection(
            title: l10n.legalInformation,
            items: [
              l10n.termsAndConditions,
              l10n.privacyPolicy,
              l10n.refundPolicy,
              l10n.termsOfUse,
            ],
            isClickable: true,
          ),

          const SizedBox(height: 24),

          // Copyright
          Text(
            l10n.copyright,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: const Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<FAQEntity> _getFilteredFAQs(BuildContext context) {
    List<FAQEntity> allFaqs = _getMockFAQs(context);

    if (_searchQuery.isEmpty) {
      return allFaqs;
    }

    return allFaqs.where((faq) {
      return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<ContactInfoEntity> _getContactMethods(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      ContactInfoEntity(
        id: '1',
        type: ContactType.phone,
        value: '+966 50 123 4567',
        description: l10n.contact_callUs,
      ),
      ContactInfoEntity(
        id: '2',
        type: ContactType.whatsapp,
        value: '+966 50 123 4567',
        description: l10n.contact_whatsapp,
      ),
      ContactInfoEntity(
        id: '3',
        type: ContactType.email,
        value: 'support@fixit.com',
        description: l10n.contact_email,
      ),
    ];
  }

  List<FAQEntity> _getMockFAQs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      FAQEntity(
        id: '1',
        question: l10n.faq_q1,
        answer: l10n.faq_a1,
        category: 'bookings',
      ),
      FAQEntity(
        id: '2',
        question: l10n.faq_q2,
        answer: l10n.faq_a2,
        category: 'payments',
      ),
      FAQEntity(
        id: '3',
        question: l10n.faq_q3,
        answer: l10n.faq_a3,
        category: 'bookings',
      ),
      FAQEntity(
        id: '4',
        question: l10n.faq_q4,
        answer: l10n.faq_a4,
        category: 'services',
      ),
    ];
  }

  void _filterByCategory(String category) {
    setState(() {
      _searchController.text = 'category:$category';
      _searchQuery = 'category:$category';
    });
  }

  void _openEmailClient(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@fixit.com',
      queryParameters: {
        'subject': l10n.emailSubject_inquiry,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isClickable;

  const _AboutSection({
    required this.title,
    required this.items,
    this.isClickable = false,
  });
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  isClickable ? Icons.link : Icons.check_circle,
                  size: 16,
                  color: isClickable
                      ? Theme.of(context).primaryColor
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: isClickable
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF718096),
                      decoration: isClickable
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
