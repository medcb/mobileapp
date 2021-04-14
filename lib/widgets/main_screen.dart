import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  final _withdrawalMethodImages = [
    'assets/images/withdrawal_method_qiwi.png',
    'assets/images/withdrawal_method_webmoney.png',
    'assets/images/withdrawal_method_charity.png',
    'assets/images/withdrawal_method_qiwi.png',
    'assets/images/withdrawal_method_webmoney.png',
    'assets/images/withdrawal_method_charity.png',
    'assets/images/withdrawal_method_qiwi.png',
    'assets/images/withdrawal_method_webmoney.png',
    'assets/images/withdrawal_method_charity.png',
    'assets/images/withdrawal_method_qiwi.png',
    'assets/images/withdrawal_method_webmoney.png',
    'assets/images/withdrawal_method_charity.png',
  ];

  final _discounts = [
    DiscountModel(
      'assets/images/discount_logo_eapteka.png',
      'Скидки до 30%',
      Color(0xff8070ED),
      Color(0xff84E8EF),
    ),
    DiscountModel(
      'assets/images/discount_logo_eapteka.png',
      'Скидки до 20%',
      Color(0xff219653),
      Color(0xff219653),
    ),
    DiscountModel(
      'assets/images/discount_logo_eapteka.png',
      'Скидки до 20%',
      Color(0xffC86670),
      Color(0xffEB9DA5),
    ),
  ];

  final _withdrawals = [
    WithdrawalModel(
      Decimal.fromInt(100),
      DateTime.now(),
      'assets/images/withdrawal_method_circle_qiwi.png',
    ),
    WithdrawalModel(
      Decimal.fromInt(1020),
      DateTime.now(),
      'assets/images/withdrawal_method_circle_qiwi.png',
    ),
    WithdrawalModel(
      Decimal.fromInt(10),
      DateTime.now(),
      'assets/images/withdrawal_method_circle_qiwi.png',
    ),
    WithdrawalModel(
      Decimal.parse('420.69'),
      DateTime.now(),
      'assets/images/withdrawal_method_circle_qiwi.png',
    ),
    WithdrawalModel(
      Decimal.fromInt(228),
      DateTime.now(),
      'assets/images/withdrawal_method_circle_qiwi.png',
    ),
  ];

  //TODO: Make strings localizable

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Доступно к выводу',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                '1 485,94 ₽',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(height: 14),
              Text('Ожидает начисления 23.04.2021 394,03 ₽'),
              SizedBox(height: 24),
              Text(
                'Вывести средства',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 60,
          child: ListView.separated(
            itemCount: _withdrawalMethodImages.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return WithdrawalMethodCell(_withdrawalMethodImages[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 10);
            },
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )),
            child: ListView(
              children: [
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Скидки и акции',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Theme.of(context).dividerColor,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  height: 64,
                  child: ListView.separated(
                    itemCount: _discounts.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return DiscountCell(_discounts[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 8);
                    },
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'История выводов',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Theme.of(context).dividerColor,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return WithdrawalCell(_withdrawals[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 1);
                  },
                  itemCount: _withdrawals.length,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).backgroundColor,
                offset: Offset(0, -16),
                blurRadius: 16,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  print('pressed');
                },
                child: Text(
                  'Добавить рецепт',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class WithdrawalMethodCell extends StatelessWidget {
  final String imagePath;

  WithdrawalMethodCell(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(3)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.asset(imagePath),
      ),
    );
  }
}

class DiscountCell extends StatelessWidget {
  final DiscountModel model;

  DiscountCell(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(3)),
        color: Colors.white,
        gradient: LinearGradient(
            colors: [model.gradientStartColor, model.gradientEndColor]),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(model.logoImagePath),
              SizedBox(height: 8),
              Text(
                model.text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscountModel {
  final String logoImagePath;
  final String text;
  final Color gradientStartColor;
  final Color gradientEndColor;

  const DiscountModel(this.logoImagePath, this.text, this.gradientStartColor,
      this.gradientEndColor);
}

class WithdrawalCell extends StatelessWidget {
  final WithdrawalModel model;

  WithdrawalCell(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(model.logoImagePath),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                NumberFormat.currency(locale: "ru_RU", symbol: "₽")
                    .format(model.sum.toDouble()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              DateFormat('dd.MM.yyyy, HH:mm').format(model.date),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawalModel {
  final Decimal sum;
  final DateTime date;
  final String logoImagePath;

  WithdrawalModel(this.sum, this.date, this.logoImagePath);
}
