import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Room.dart';
import 'package:pro_hotel_fullapps/app/widget/snackbar.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseDateScreen extends StatefulWidget {
  Hotel? hotel;
  List<Room>? room;
  ChooseDateScreen({this.hotel, this.room});

  @override
  State<ChooseDateScreen> createState() => _ChooseDateScreenState();
}

class _ChooseDateScreenState extends State<ChooseDateScreen> {
  
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  int _rangeCount = 0;
  String? _startDate = '';
  String _endDate = '';
  //  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _currentMonth = DateFormat.yMMM().format( DateTime.now());
  DateTime _focusedDay = DateTime.now();

  int _countRangeDays(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return difference; // Tambahkan 1 karena kita ingin menghitung juga tanggal awal.
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// multi range.
      DateTime today =DateTime.now().subtract(Duration(days: 1));
  DateTime selectedDate;
    setState(() {
      if (args.value is PickerDateRange) {
        DateTime startDate = args.value.startDate;
        DateTime endDate = args.value.endDate ?? args.value.startDate;
  // Check if the start date is before today
      if (startDate.isBefore(today)) {
        // You can show a message or handle it as per your requirements
        // For now, we'll just reset the selection to the current month
        selectedDate = today;
        
          snackbarError(context, message: "Please select the date correctly");
      } else {
        selectedDate = startDate;
        
          // snackbarError(context, message: "Please select the date correctly");
      }
        DateFormat formatter = DateFormat('dd/MM/yyyy');
        _startDate = formatter.format(startDate);
        _endDate = formatter.format(endDate);
        _range =
            '${formatter.format(startDate)} - ${formatter.format(endDate)}';
        int rangeCount = _countRangeDays(startDate, endDate);
        _rangeCount = rangeCount;
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
         selectedDate = args.value;
            // Check if the selected date is before today
      if (selectedDate.isBefore(today)) {
        // You can show a message or handle it as per your requirements
        // For now, we'll just reset the selection to the current month
        selectedDate = today;
        // setState(() {
        //   _rangeCount==0;
        // });
          snackbarError(context, message: "Please select the date correctly");
      }
      
      _selectedDate = selectedDate.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        // _rangeCount = args.value.length.toString();
      }
    });
  }

  String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) {
      return 'No Date'; // or any default value you prefer
    }

    DateTime? date;
    try {
      date = DateFormat('dd/MM').parse(inputDate);
    } catch (e) {
      return 'Invalid Date'; // handle parsing errors, if any
    }

    String formattedDate = DateFormat('dd MMMM').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(('Booking Date'),
              style: TextStyle(
                  fontFamily: "RedHat",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(left: 10.0.w, right: 10.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              //       Text('Selected range: $_range'),
              //       Text('Selected ranges count: $_rangeCount'),
              // //       Text('Selected ranges count: $_startDate'),
              //       Text('Selected ranges count: $_endDate'),
              SizedBox(
                height: 10.0.h,
              ),
              Container(
                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(width: 1.0,color: Colors.black12)
                  ),
                child: Padding(
                  padding:  EdgeInsets.all(15.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-In',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: "RedHat",
                            ),
                          ),
                          Text(
                            formatDate(_startDate ?? ''),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                fontFamily: "RedHat"),
                          )
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: Colors.black45,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-Out',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: "RedHat",
                            ),
                          ),
                          Text(
                            formatDate(_endDate ?? ''),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                fontFamily: "RedHat"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0.h,),
              
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  border: Border.all(width: 1.0,color: Colors.black12)
                ),
                child: Padding(
                  padding:  EdgeInsets.only(left:15.0.w,right: 15.0.w,top: 15.h),
                  child: SfDateRangePicker(
                    startRangeSelectionColor: accentColor,
                    headerStyle: DateRangePickerHeaderStyle(
                      textStyle: TextStyle(
                          fontFamily: "RedHat",
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 0)),
                        DateTime.now().add(const Duration(days: 0))),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Date Booking Hotel",
              //         style: TextStyle(
              //             fontFamily: "RedHat",
              //             fontWeight: FontWeight.w600,
              //             fontSize: 16),
              //       ),
              //       SizedBox(
              //         height: 10.0,
              //       ),
              //       Text('Selected date: $_selectedDate'),
              //       Text('Selected date count: $_dateCount'),
              //     ],
              //   ),
              // ),
          if(_rangeCount== 0)    Padding(
                      padding:  EdgeInsets.only(
                          left: 0.0, right: 0.0, bottom: 10.0,top: MediaQuery.of(context).size.height/5.h),
                      child: InkWell(
                        onTap: () async {
                            
                          // ChooseDateScreen
                        
                        },
                        child: Container(
                          height: 55.0.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              gradient: LinearGradient(
                                  colors: [
                                     Colors.grey,
                                     Colors.grey,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp)),
                          child: Center(
                            child: Text(
                              ('Booking Now'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0.sp,
                                  fontFamily: "RedHat",
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
            if(_rangeCount!>0)        Padding(
                      padding:  EdgeInsets.only(
                          left: 0.0, right: 0.0, bottom: 10.0,top: MediaQuery.of(context).size.height/5.h),
                      child: InkWell(
                        onTap: () async {
                            

                          // ChooseDateScreen
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new RoomScreen(
                                count: _rangeCount,
                                checkin:_startDate,
                                checkout:_endDate,
                                hotel:widget.hotel,
                                 room: widget.hotel?.room,
                                  )));
                        },
                        child: Container(
                          height: 55.0.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF09314F),
                                    Color(0xFF09314F),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp)),
                          child: Center(
                            child: Text(
                              ('Booking Now'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0,
                                  fontFamily: "RedHat",
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
           
            ],
          ),
        ),
      ),
    );
  }
}
