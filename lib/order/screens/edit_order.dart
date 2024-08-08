import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/cart_page/bloc/cart_bloc.dart';
import 'package:pos_app/cart_page/order_success_screen.dart';
import 'package:pos_app/cart_page/service/data_source.dart';
import 'package:pos_app/cart_page/widgets/cart_product_card.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/variants/model/order_lines.dart';

class EditOrderScreen extends StatefulWidget {
  const EditOrderScreen(
      {super.key,
      required this.orderID,
      required this.orderLines,
      required this.phone,
      required this.billTo,
      required this.note});
  final List<OrderLines> orderLines;
  final String billTo;
  final String phone;
  final String note;
  final int orderID;

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  double grandTotal = 0;
  void calculateGrandTotal() {
    double total = 0;
    for (int i = 0; i < widget.orderLines.length; i++) {
      total +=
          widget.orderLines[i].sellingPrice * widget.orderLines[i].quantity;
    }
    setState(() {
      grandTotal = total;
    });
  }

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deliveryNoteController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    phoneNumberController = TextEditingController(text: widget.phone);
    deliveryNoteController = TextEditingController(text: widget.note);
    userNameController = TextEditingController(text: widget.billTo);
    super.initState();
    calculateGrandTotal();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        width: w,
        height: h / 6,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 13),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   children: [
                //     Text(
                //       "Sub total (${widget.orderLines.length} products)",
                //       style: GoogleFonts.poppins(
                //         color: Colors.black,
                //         fontSize: w / 26,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //     const Spacer(),
                //     Text(
                //       "1200.89",
                //       style: GoogleFonts.poppins(
                //         color: Colors.black,
                //         fontSize: w / 24,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Grand total",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: w / 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      grandTotal.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: w / 24,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                    height: 45,
                    width: w,
                    child: CommonButton(
                      isLoading: isLoading,
                      onTap: () {
                        isLoading = true;
                        setState(() {});
                        CartDataSource()
                            .editOrder(
                                personName: userNameController.text,
                                phoneNumber: phoneNumberController.text,
                                deliveryNote: deliveryNoteController.text,
                                totalPrice: grandTotal,
                                orderId: widget.orderID,
                                orderLines: widget.orderLines)
                            .then((value) {
                          if (value.data1 == true) {
                            Fluttertoast.showToast(msg: value.data2);
                            context.read<CartBloc>().add(GetOrderDetails(
                                inventoryId: authentication.authenticatedUser
                                        .businessData?.businessId ??
                                    0,
                                orderId: widget.orderID));
                            isLoading = false;
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(msg: value.data2);
                          }
                        });
                        // context.read<CartBloc>().add(CreateOrderEvent(
                        //     deliveryNote: deliveryNoteController.text,
                        //     totalPrice: grandTotal,
                        //     phoneNumber: phoneNumberController.text,
                        //     orderLines: widget.orderLines,
                        //     personName: userNameController.text));
                      },
                      title: "Update Order",
                    )),
              ],
            )),
      ),
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: OrderAppBar(title: "Edit Order")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CreateOrderSuccess) {
                isLoading = false;
                setState(() {});
                Fluttertoast.showToast(msg: "Order Edited Successfully!");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  OrderSuccessScreen(orderId: int.parse(state.orderId),),
                    ),
                    (route) => false);
              }
              if (state is CreateOrderFailed) {
                isLoading = false;
                setState(() {});
                Fluttertoast.showToast(msg: state.message);
              }
            },
          )
        ],
        child: SizedBox(
          height: h,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Total ${widget.orderLines.length} products",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: w / 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return CartPageProductCard(
                            fromHistory: true,
                            orderLinesDetails: widget.orderLines[index],
                            onAdd: () {
                              widget.orderLines[index].quantity++;
                              calculateGrandTotal();
                              setState(() {});
                            },
                            onRemove: () {
                              if (widget.orderLines[index].quantity == 1) {
                                widget.orderLines[index].isActive = false;
                              } else {
                                widget.orderLines[index].quantity--;
                              }
                              calculateGrandTotal();
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: widget.orderLines.length),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Bill to",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: w / 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CurvedTextField(
                    controller: userNameController,
                    title: "Enter Person name",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CurvedTextField(
                    controller: phoneNumberController,
                    title: "Enter Phone Number",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Edit note",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: w / 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CurvedTextField(
                    maxLines: 6,
                    controller: deliveryNoteController,
                    title: "Add Note ..",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
