// Mock services data used by the Services feature for local demos and tests.
// Keep this as Maps for now to match existing UI that expects Map<String, dynamic>.
const List<Map<String, dynamic>> mockServices = [
  {
    'id': '1',
    'name': 'Plumbing Repair',
    'description': 'Fix leaks, unclog drains, and repair pipes',
    'price': 80.0,
    'duration': 120,
    'category': 'Plumbing',
    'image': '',
    'is_available': true,
    'rating': 4.3,
  },
  {
    'id': '2',
    'name': 'Electrical Installation',
    'description': 'Install light fixtures, outlets, and switches',
    'price': 100.0,
    'duration': 90,
    'category': 'Electrical',
    'image': '',
    'is_available': true,
    'rating': 4.1,
  },
  {
    'id': '3',
    'name': 'HVAC Maintenance',
    'description': 'Regular maintenance for heating and cooling systems',
    'price': 120.0,
    'duration': 180,
    'category': 'HVAC',
    'image': '',
    'is_available': false,
    'rating': 4.6,
  },
  {
    'id': '4',
    'name': 'Carpentry Work',
    'description': 'Custom furniture, cabinets, and woodwork',
    'price': 150.0,
    'duration': 240,
    'category': 'Carpentry',
    'image': '',
    'is_available': true,
    'rating': 4.7,
  },
  {
    'id': '5',
    'name': 'Painting Services',
    'description': 'Interior and exterior painting',
    'price': 90.0,
    'duration': 180,
    'category': 'Painting',
    'image': '',
    'is_available': true,
    'rating': 4.2,
  },
  {
    'id': '6',
    'name': 'Appliance Repair',
    'description': 'Fix and maintain household appliances',
    'price': 110.0,
    'duration': 120,
    'category': 'Appliance Repair',
    'image': '',
    'is_available': false,
    'rating': 4.0,
  },
];

List<String> extractCategories(List<Map<String, dynamic>> services) {
  return services
      .map((service) => service['category'] as String)
      .toSet()
      .toList();
}
