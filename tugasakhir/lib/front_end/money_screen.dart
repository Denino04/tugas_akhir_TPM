import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';

enum Currency { IDR, USD, JPY }

class MoneyScreen extends StatefulWidget {
  @override
  _MoneyScreenState createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  Currency _selectedBaseCurrency = Currency.IDR;
  Currency _selectedTargetCurrency = Currency.IDR;
  double _amount = 0.0;

  Map<Currency, double> _conversionRates = {
    Currency.IDR: 1.0, // 1 IDR = 1 IDR
    Currency.USD: 0.000070, // 1 USD = 14,287 IDR
    Currency.JPY: 0.0076, // 1 JPY = 131.58 IDR
  };

  void _convertAmount(double amount, Currency fromCurrency, Currency toCurrency) {
    double convertedAmount = amount * (_conversionRates[toCurrency]! / _conversionRates[fromCurrency]!);
    setState(() {
      _amount = convertedAmount;
    });
  }
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement your logout logic here
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Money Screen',
                style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount: '),
                  SizedBox(width: 10),
                  Container(
                    width: 120,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          double inputAmount = double.parse(value);
                          _convertAmount(inputAmount, _selectedBaseCurrency, _selectedTargetCurrency);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter amount',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('From: '),
                  SizedBox(width: 10),
                  DropdownButton<Currency>(
                    value: _selectedBaseCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedBaseCurrency = value;
                          _convertAmount(_amount, _selectedBaseCurrency, _selectedTargetCurrency);
                        });
                      }
                    },
                    items: Currency.values
                        .map((currency) => DropdownMenuItem<Currency>(
                              value: currency,
                              child: Text(_currencyToString(currency)),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('To: '),
                  SizedBox(width: 10),
                  DropdownButton<Currency>(
                    value: _selectedTargetCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTargetCurrency = value;
                          _convertAmount(_amount, _selectedBaseCurrency, _selectedTargetCurrency);
                        });
                      }
                    },
                    items: Currency.values
                        .map((currency) => DropdownMenuItem<Currency>(
                              value: currency,
                              child: Text(_currencyToString(currency)),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Converted Amount: $_amount ${_currencyToString(_selectedTargetCurrency)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currencyToString(Currency currency) {
    switch (currency) {
      case Currency.IDR:
        return 'IDR';
      case Currency.USD:
        return 'USD';
      case Currency.JPY:
        return 'JPY';
      default:
        return '';
    }
  }
}