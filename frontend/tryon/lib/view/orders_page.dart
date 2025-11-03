import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tryon/controller/app_provider.dart';  
import 'package:tryon/models/order.dart';


class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        title: Text("My Orders", style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildOrdersList(appProvider),
    );
  }

  Widget _buildOrdersList(AppProvider appProvider) {
    if (appProvider.ordersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.ordersError != null) {
      return Center(child: Text("Error: ${appProvider.ordersError}"));
    }

    if (appProvider.userOrders.isEmpty) {
      return const Center(child: Text("You have not placed any orders yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: appProvider.userOrders.length,
      itemBuilder: (context, index) {
        final order = appProvider.userOrders[index];
        return OrderCard(order: order);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.createdAt != null
        ? DateFormat('MMM d, yyyy - h:mm a').format(order.createdAt!)
        : 'Date unknown';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ...${order.id.substring(order.id.length - 6)}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${order.totalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[700]),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.status.name,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800]),
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address: ${order.address}',
                  style: GoogleFonts.poppins(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Text(
                  'Items:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const Divider(),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ItemID: ...${item.itemId.substring(item.itemId.length - 6)}'),
                        Text('Qty: ${item.qty}'),
                        Text('Price: \$${item.priceAtTime.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
