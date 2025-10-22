import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';

part 'icon_picker_packs/line_icons.g.dart';

class AppIcons {

  // line icons
  static const Map<String, IconPickerIcon> lineIcons = _lineAwesomeIcons;

  // Food related
  static const Map<String, IconData> foodIcons = {
    'apple': Icons.apple,
    'banana': Icons.emoji_food_beverage,
    'bread': Icons.bakery_dining,
    'cheese': Icons.emoji_food_beverage,
    'meat': Icons.set_meal,
    'fish': Icons.set_meal,
    'egg': Icons.egg,
    'carrot': Icons.emoji_food_beverage,
    'broccoli': Icons.emoji_food_beverage,
    'grape': Icons.emoji_food_beverage,
    'watermelon': Icons.emoji_food_beverage,
    'pizza': Icons.local_pizza,
    'burger': Icons.fastfood,
    'fries': Icons.fastfood,
    'iceCream': Icons.icecream,
    'cake': Icons.cake,
    'coffee': Icons.coffee,
    'tea': Icons.emoji_food_beverage,
    'soup': Icons.ramen_dining,
  };

  // Shopping related
  static const Map<String, IconData> shoppingIcons = {
    'cart': Icons.shopping_cart,
    'bag': Icons.shopping_bag,
    'basket': Icons.shopping_basket,
    'store': Icons.store,
    'storefront': Icons.storefront,
    'localGroceryStore': Icons.local_grocery_store,
    'receipt': Icons.receipt_long,
    'localOffer': Icons.local_offer,
    'barcode': Icons.qr_code_scanner,
    'discount': Icons.discount,
    'priceCheck': Icons.price_check,
    'localMall': Icons.local_mall,
    'sell': Icons.sell,
    'payment': Icons.payment,
    'credit': Icons.credit_card,
    'wallet': Icons.account_balance_wallet,
  };

  // Household items
  static const Map<String, IconData> householdIcons = {
    'cleaning': Icons.cleaning_services,
    'laundry': Icons.local_laundry_service,
    'bathroom': Icons.bathroom,
    'kitchen': Icons.kitchen,
    'bed': Icons.bed,
    'chair': Icons.chair,
    'lamp': Icons.light,
    'furniture': Icons.weekend,
    'tv': Icons.tv,
    'ac': Icons.ac_unit,
    'blender': Icons.blender,
    'microwave': Icons.microwave,
  };

  // Personal care
  static const Map<String, IconData> personalCareIcons = {
    'face': Icons.face_retouching_natural,
    'spa': Icons.spa,
    'sanitizer': Icons.sanitizer,
    'baby': Icons.baby_changing_station,
    'childFriendly': Icons.child_friendly,
    'toys': Icons.toys,
    'brush': Icons.brush,
    'healing': Icons.healing,
    'medication': Icons.medication,
    'vaccine': Icons.vaccines,
  };

  // Nature & Produce
  static const Map<String, IconData> natureIcons = {
    'eco': Icons.eco,
    'compost': Icons.compost,
    'recycling': Icons.recycling,
    'organic': Icons.grass,
    'flowerPot': Icons.yard,
    'water': Icons.water_drop,
    'garden': Icons.nature,
    'park': Icons.park,
  };

  // Navigation & UI
  static const Map<String, IconData> navigationIcons = {
    'add': Icons.add_circle,
    'remove': Icons.remove_circle,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'save': Icons.save,
    'cancel': Icons.cancel,
    'close': Icons.close,
    'check': Icons.check_circle,
    'search': Icons.search,
    'filter': Icons.filter_list,
    'sort': Icons.sort,
    'menu': Icons.menu,
    'more': Icons.more_vert,
    'refresh': Icons.refresh,
    'share': Icons.share,
    'favorite': Icons.favorite,
    'bookmark': Icons.bookmark,
    'star': Icons.star,
    'info': Icons.info,
    'help': Icons.help,
    'warning': Icons.warning,
    'error': Icons.error,
  };

  // App sections
  static const Map<String, IconData> appSectionIcons = {
    'home': Icons.home,
    'list': Icons.list,
    'checklist': Icons.checklist,
    'calendar': Icons.calendar_today,
    'settings': Icons.settings,
    'person': Icons.person,
    'history': Icons.history,
    'notification': Icons.notifications,
    'dashboard': Icons.dashboard,
    'analytics': Icons.analytics,
    'budget': Icons.attach_money,
    'trending': Icons.trending_up,
    'inventory': Icons.inventory,
    'category': Icons.category,
    'label': Icons.label,
    'folder': Icons.folder,
  };

  // General utility icons
  static const Map<String, IconData> utilityIcons = {
    'camera': Icons.camera_alt,
    'image': Icons.image,
    'attachment': Icons.attach_file,
    'location': Icons.location_on,
    'directions': Icons.directions,
    'time': Icons.access_time,
    'date': Icons.date_range,
    'cloud': Icons.cloud,
    'download': Icons.download,
    'upload': Icons.upload,
    'link': Icons.link,
    'print': Icons.print,
    'bluetooth': Icons.bluetooth,
    'wifi': Icons.wifi,
  };
}
