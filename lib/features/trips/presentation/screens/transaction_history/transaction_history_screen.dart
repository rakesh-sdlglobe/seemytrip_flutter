import 'package:flutter/material.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title:
            Text('Transaction History', style: TextStyle(color: Colors.white)),
        // centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redCA0,
        actions: [
          GestureDetector(
            onTap: () {
              print('sorting button clicked');
            },
            child: Icon(Icons.sort),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Replace with the actual number of transactions
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.1),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)
                  )
                ]
              ),
              margin: EdgeInsets.symmetric(vertical: 6.0),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        maxRadius: 30,
                        child: Icon(
                          Icons.train,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mum to Deli Mum to Del...",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text("₹ 678",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.red)),
                          Text("12th Sept",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        ),
      ),
    );
}
