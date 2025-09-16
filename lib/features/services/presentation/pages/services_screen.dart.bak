import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// ServiceItem
///
/// Represents a service category entry displayed in the services grid.
///
/// Business Rules:
/// - UI-only data holder used for display; actual service catalog comes
///   from backend models.
class ServiceItem {
  final IconData icon;
  final String title;
  final Color bg;
  final Color iconColor;

  const ServiceItem({
    required this.icon,
    required this.title,
    required this.bg,
    required this.iconColor,
  });
}

/// ServicesScreen
///
/// Displays the full list of available services with search/filter
/// capabilities.
///
/// Business Rules:
/// - Supports RTL layout; serves as a UI entry point to service discovery.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 0;
  String _query = '';

  // قائمة الخدمات (يمكن تعديل الأسماء والأيقونات والألوان بسهولة)
  static const List<ServiceItem> _allServices = [
    ServiceItem(
        icon: Icons.plumbing,
        title: 'السباكة',
        bg: Color(0xFFE6FAF3),
        iconColor: Color(0xFF17A398)),
    ServiceItem(
        icon: Icons.electrical_services,
        title: 'الكهرباء',
        bg: Color(0xFFEAF1FF),
        iconColor: Color(0xFF3F51B5)),
    ServiceItem(
        icon: Icons.cleaning_services,
        title: 'التنظيف',
        bg: Color(0xFFF4ECFF),
        iconColor: Color(0xFF7E57C2)),
    ServiceItem(
        icon: Icons.handyman,
        title: 'النجارة',
        bg: Color(0xFFFFF6D9),
        iconColor: Color(0xFFF4A100)),
    ServiceItem(
        icon: Icons.ac_unit,
        title: 'مكيفات الهواء',
        bg: Color(0xFFEFF6FF),
        iconColor: Color(0xFF1E88E5)),
    ServiceItem(
        icon: Icons.format_paint,
        title: 'الطلاء والديكور',
        bg: Color(0xFFFEEFEF),
        iconColor: Color(0xFFE53935)),
    ServiceItem(
        icon: Icons.architecture,
        title: 'التجليد والجبس',
        bg: Color(0xFFF0F7E9),
        iconColor: Color(0xFF7CB342)),
    ServiceItem(
        icon: Icons.grid_on,
        title: 'السيراميك',
        bg: Color(0xFFE8FFF7),
        iconColor: Color(0xFF26A69A)),
    ServiceItem(
        icon: Icons.satellite_alt,
        title: 'أطباق الأقمار',
        bg: Color(0xFFFFF7E6),
        iconColor: Color(0xFFFF8F00)),
    ServiceItem(
        icon: Icons.window,
        title: 'ألوميتال',
        bg: Color(0xFFE8FFFB),
        iconColor: Color(0xFF00ACC1)),
    ServiceItem(
        icon: Icons.kitchen,
        title: 'مطبخ',
        bg: Color(0xFFF7E8FF),
        iconColor: Color(0xFF8E24AA)),
    ServiceItem(
        icon: Icons.videocam,
        title: 'كاميرات مراقبة',
        bg: Color(0xFFFFEEF0),
        iconColor: Color(0xFFD81B60)),
    ServiceItem(
        icon: Icons.payments,
        title: 'الأقساط',
        bg: Color(0xFFEFF8FF),
        iconColor: Color(0xFF1565C0)),
    ServiceItem(
        icon: Icons.delivery_dining,
        title: 'توصيل الطعام',
        bg: Color(0xFFFFF4E5),
        iconColor: Color(0xFFF57C00)),
    ServiceItem(
        icon: Icons.engineering,
        title: 'عمال',
        bg: Color(0xFFEFF7F7),
        iconColor: Color(0xFF00897B)),
    ServiceItem(
        icon: Icons.build,
        title: 'إصلاح الأجهزة',
        bg: Color(0xFFFFEBEE),
        iconColor: Color(0xFFC62828)),
    ServiceItem(
        icon: Icons.local_shipping,
        title: 'النقل',
        bg: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32)),
    ServiceItem(
        icon: Icons.business_center,
        title: 'نقل الأثاث',
        bg: Color(0xFFF3E5F5),
        iconColor: Color(0xFF6A1B9A)),
    ServiceItem(
        icon: Icons.local_laundry_service,
        title: 'التنظيف الجاف',
        bg: Color(0xFFE0F7FA),
        iconColor: Color(0xFF0097A7)),
    ServiceItem(
        icon: Icons.build_circle,
        title: 'تفكيك وتركيب',
        bg: Color(0xFFFFFDE7),
        iconColor: Color(0xFFF9A825)),
    ServiceItem(
        icon: Icons.grass,
        title: 'LandScape',
        bg: Color(0xFFE8F5E9),
        iconColor: Color(0xFF43A047)),
  ];

  @override
  Widget build(BuildContext context) {
    // فرض اتجاه RTL على كامل الشاشة
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(
            tr('allServices'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded), label: tr('home')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search_rounded), label: tr('search')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_rounded),
                label: tr('bookings')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_rounded), label: tr('account')),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // شريط البحث
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      hintText: tr('search'),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // شبكة الخدمات
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                    children: _allServices
                        .where((s) =>
                            _query.trim().isEmpty ||
                            s.title.contains(_query.trim()))
                        .map((s) => _ServiceCard(item: s))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem item;
  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: item.bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 44, color: item.iconColor),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
