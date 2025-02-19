import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/custom_icon_button.dart';
import 'package:flutter_application_1/src/configs/constants/app_router.dart';

class HomeHeaderAction extends StatefulWidget {
  const HomeHeaderAction({Key? key}) : super(key: key);

  @override
  State<HomeHeaderAction> createState() => _HeaderActionState();
}

class _HeaderActionState extends State<HomeHeaderAction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildSearchIcon(),
        Row(
          children: [
            _buildCartIcon(),
            const SizedBox(width: 5),
            _buildNotificationIcon(),
          ],
        )
      ]),
    );
  }

  Widget _buildSearchIcon() {
    return CustomIconButton(
      icon: Icons.search,
      onPressed: () => Navigator.pushNamed(context, AppRouters.listProduct),
    );
  }

  Widget _buildCartIcon() {
    return CustomIconButton(
      icon: Icons.local_grocery_store_outlined,
      onPressed: () =>
          Navigator.pushNamed(context, AppRouters.createOrderScreen),
    );
  }

  Widget _buildNotificationIcon() {
    return CustomIconButton(
      icon: Icons.notifications_none,
      onPressed: () {},
    );
  }
}
