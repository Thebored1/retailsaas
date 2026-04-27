import 'package:flutter/material.dart';
import '../utils/image_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_inventory_view.dart';
import 'dart:io';

class ProductCard extends StatefulWidget {
  final ProductInventoryView item;
  final Function(int quantity) onAdd;
  final bool allowZeroStock;

  const ProductCard({
    super.key,
    required this.item,
    required this.onAdd,
    this.allowZeroStock = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.item.product;
    final stock = widget.item.totalStock;
    final hasStock = stock > 0;

    // Price display logic
    String priceDisplay = 'N/A';
    if (widget.item.batches.isNotEmpty) {
      if (widget.item.minSellingPrice == widget.item.maxSellingPrice) {
        priceDisplay = 'Rs. ${widget.item.minSellingPrice?.toStringAsFixed(0)}';
      } else {
        priceDisplay =
            'Rs. ${widget.item.minSellingPrice?.toStringAsFixed(0)} - ${widget.item.maxSellingPrice?.toStringAsFixed(0)}';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
                image: product.imageUrl != null
                    ? DecorationImage(
                        image: product.imageUrl!.startsWith('http')
                            ? NetworkImage(product.imageUrl!)
                            : FileImage(File(product.imageUrl!))
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null
                  ? const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 40),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            product.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Stock Pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasStock ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hasStock
                      ? 'Stock: ${stock.toStringAsFixed(0)} ${product.uom}'
                      : 'Out of Stock',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: hasStock
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.item.soldQty > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Warranty Avail: ${widget.item.soldQty.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Qty Control
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (hasStock || widget.allowZeroStock)
                          ? _decrement
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('$_quantity', style: GoogleFonts.inter(fontSize: 12)),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: (hasStock || widget.allowZeroStock)
                          ? _increment
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.add, size: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Price & Add
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priceDisplay,
                    style: GoogleFonts.inter(
                      fontSize: 14, // Slightly smaller if range is long
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: (hasStock || widget.allowZeroStock)
                    ? () => widget.onAdd(_quantity)
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (hasStock || widget.allowZeroStock)
                        ? Colors.white
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: (hasStock || widget.allowZeroStock)
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.add,
                    color: (hasStock || widget.allowZeroStock)
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
