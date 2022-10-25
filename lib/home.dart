import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  List<double> enteredNumbers = [];

  void _addNumber() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
  }

  void _showResultSnackBar(String result) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result),
      duration: const Duration(seconds: 2),
    ));
  }

  void _calcMean() {
    if (enteredNumbers.length <= 1) {
      _showResultSnackBar('Enter atleast 2 numbers');
      return;
    }
    double sum = 0.0;
    for (var n in enteredNumbers) {
      sum += n;
    }
    final mean = sum / enteredNumbers.length;
    _showResultSnackBar('Mean is ${mean.toStringAsFixed(2)}');
  }

  void _calcMedian() {
    if (enteredNumbers.length <= 1) {
      _showResultSnackBar('Enter atleast 2 numbers');
      return;
    }
    final median = getMedian(enteredNumbers);
    _showResultSnackBar('Median is ${median.toStringAsFixed(2)}');
  }

  void _calcMode() {
    if (enteredNumbers.length <= 1) {
      _showResultSnackBar('Enter atleast 2 numbers');
      return;
    }
    String modeVal = '';
    Map<double, int> mode = {};
    for (var n in enteredNumbers) {
      mode.update(n, (value) => value + 1, ifAbsent: () => 1);
    }
    int max = 1;
    for (var e in mode.entries) {
      if (e.value >= max) {
        max = e.value;
      }
    }
    for (var e in mode.entries) {
      if (e.value == max) {
        modeVal += '${e.key}, ';
      }
    }
    _showResultSnackBar('Mode is $modeVal');
  }

  void _calcMidrange() {
    if (enteredNumbers.length <= 1) {
      _showResultSnackBar('Enter atleast 2 numbers');
      return;
    }
    enteredNumbers.sort();
    double midrange = (enteredNumbers.first + enteredNumbers.last) / 2;
    _showResultSnackBar('Midrange is ${midrange.toStringAsFixed(2)}');
  }

  double getMedian(List<double> values) {
    double median = 0.0;
    values.sort();
    if (values.length % 2 == 1) {
      final int middleNo = values.length ~/ 2;
      median = values[middleNo];
    } else {
      final int middleNo = (values.length - 1) ~/ 2;
      median = (values[middleNo] + values[middleNo + 1]) / 2;
    }
    return median;
  }

  void _calcIQR() {
    if (enteredNumbers.length <= 1) {
      _showResultSnackBar('Enter atleast 2 numbers');
      return;
    }
    enteredNumbers.sort();
    final List<double> Q1 = [];
    final List<double> Q3 = [];
    if (enteredNumbers.length % 2 == 1) {
      final int middle = enteredNumbers.length ~/ 2;
      for (int i = 0; i < enteredNumbers.length; i++) {
        if (i < middle) Q1.add(enteredNumbers[i]);
        else if (i > middle) Q3.add(enteredNumbers[i]);
      }
    } else {
      final int middle = (enteredNumbers.length - 1) ~/ 2;
      for (int i = 0; i < enteredNumbers.length; i++) {
        if (i <= middle) Q1.add(enteredNumbers[i]);
        else if (i > middle) Q3.add(enteredNumbers[i]);
      }
    }
    final q1M = getMedian(Q1);
    final q3M = getMedian(Q3);
    // print('q1 $q1M --- q3 $q3M  ===  ${q3M - q1M}');
    final IQR = q3M - q1M;
    _showResultSnackBar('IQR is $IQR');
  }

  void _clear() {
    if (enteredNumbers.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState!.reset();
    setState(() {
      enteredNumbers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Statistics Calc'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 10.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    icon: TextButton(
                        onPressed: _clear,
                        child: const Text(
                          'clear all',
                          style: TextStyle(color: Colors.redAccent),
                        )),
                    suffixIcon:
                        TextButton(onPressed: _addNumber, child: const Text('add')),
                    labelText: 'number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text?.trim().isEmpty ?? true) {
                      return 'enter valid number';
                    }
                    final val = double.tryParse(text!);
                    if (val == null) {
                      return 'enter valid number';
                    }
                    return null;
                  },
                  onSaved: (text) {
                    setState(() {
                      enteredNumbers.add(double.parse(text!));
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Values'),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: enteredNumbers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('empty!'),
                      )
                    : Wrap(
                        children: enteredNumbers
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('$e'),
                                ))
                            .toList(),
                      ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _calcMean,
                    child: const Text('Mean'),
                  ),
                  ElevatedButton(
                    onPressed: _calcMedian,
                    child: const Text('Median'),
                  ),
                  ElevatedButton(
                    onPressed: _calcMode,
                    child: const Text('Mode'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _calcMidrange,
                    child: const Text('Midrange'),
                  ),
                  ElevatedButton(
                    onPressed: _calcIQR,
                    child: const Text('IQR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
