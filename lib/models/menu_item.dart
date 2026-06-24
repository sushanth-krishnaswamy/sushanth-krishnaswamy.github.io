enum MenuIcon { paniPuri, filterCoffee, masalaChai }

class MenuItem {
  final String name;
  final String description;
  final String price;
  final MenuIcon icon;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

const List<MenuItem> kMenuItems = [
  MenuItem(
    name: 'Signature Pani Puri',
    description:
        'Hand-crafted crispy spheres filled with spiced potatoes and tangy mint water.',
    price: '\$6.00',
    icon: MenuIcon.paniPuri,
  ),
  MenuItem(
    name: 'Filter Coffee',
    description:
        'Strong, frothy South Indian decoction with hot frothed milk. The classic perk-up.',
    price: '\$4.00',
    icon: MenuIcon.filterCoffee,
  ),
  MenuItem(
    name: 'Masala Chai',
    description:
        'Rich black tea brewed with aromatic spices, ginger, and cardamom.',
    price: '\$3.50',
    icon: MenuIcon.masalaChai,
  ),
];
