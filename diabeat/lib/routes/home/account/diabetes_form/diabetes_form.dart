import 'package:diabeat/keys.dart';
import 'package:diabeat/routes/home/account/diabetes_form/fields.dart';
import 'package:diabeat/routes/home/account/diabetes_form/page0.dart';
import 'package:diabeat/routes/home/account/diabetes_form/page1.dart';
import 'package:diabeat/routes/home/account/diabetes_form/page2.dart';
import 'package:diabeat/routes/home/account/diabetes_form/page3.dart';
import 'package:diabeat/core/request.dart' as request;
import 'package:diabeat/util.dart' as util;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DiabetesFormPage extends StatefulWidget {
  const DiabetesFormPage({super.key});

  @override
  State<DiabetesFormPage> createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final _page3Key = GlobalKey<Page3State>();
  int _index = 0;

  FormState get _formState => _formKeys[_index].currentState!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: util.backIconButton(context),
        title: const Text('AI 糖尿病風險檢測'),
        centerTitle: true,
        actions: [
          if (_index == 3 && _page3Key.currentState!.waiting == false)
            IconButton(
              onPressed: _share,
              icon: const Icon(Icons.ios_share_rounded),
            ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPop,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: IndexedStack(
            index: _index,
            children: [
              Form(
                key: _formKeys[0],
                child: Column(
                  children: [
                    Page0(),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        const SizedBox(width: 20),
                        _nextPageButton(),
                      ],
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKeys[1],
                child: Column(
                  children: [
                    const Page1(),
                    const Spacer(),
                    Row(
                      children: [
                        _prevPageButton(),
                        const SizedBox(width: 20),
                        _nextPageButton(),
                      ],
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKeys[2],
                child: Column(
                  children: [
                    Page2(),
                    const Spacer(),
                    Row(
                      children: [
                        _prevPageButton(),
                        const SizedBox(width: 20),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _send,
                            style: util.filledPageButtonStyle(),
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('送出'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Page3(key: _page3Key),
            ],
          ),
        ),
      ),
    );
  }

  void _onPop(bool didPop, Object? result) {
    if (didPop) {
      return;
    }

    if (_index > 0 && _index < 3) {
      _goPrevPage();
    } else {
      globalContext.pop();
    }
  }

  void _goPrevPage() {
    primaryFocus?.unfocus();
    setState(() => _index--);
  }

  void _goNextPage() {
    if (_formState.validate()) {
      _formState.save();
      primaryFocus?.unfocus();
      setState(() => _index++);
    }
  }

  Widget _prevPageButton() {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: _goPrevPage,
        style: util.outlinedPageButtonStyle(),
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text('上一頁'),
      ),
    );
  }

  Widget _nextPageButton() {
    return Expanded(
      child: FilledButton.icon(
        onPressed: _goNextPage,
        style: util.filledPageButtonStyle(),
        icon: const Icon(Icons.arrow_forward_rounded),
        iconAlignment: IconAlignment.end,
        label: const Text('下一頁'),
      ),
    );
  }

  Future<void> _send() async {
    if (!_formState.validate()) return;
    _formState.save();
    primaryFocus?.unfocus();
    setState(() => _index++);

    final heightInMeter = DiabetesFormFields.height / 100;
    final bmi = DiabetesFormFields.weight / (heightInMeter * heightInMeter);

    DiabetesFormFields.bmi = double.parse(bmi.toStringAsFixed(1));

    final (ok, data) = await request.predictDiabetes(
      gender: DiabetesFormFields.gender,
      age: DiabetesFormFields.age,
      bmi: DiabetesFormFields.bmi,
      hypertension: DiabetesFormFields.hypertension,
      heartDisease: DiabetesFormFields.heartDisease,
      smokingHistory: DiabetesFormFields.smokingHistory,
      glucose: DiabetesFormFields.glucose,
      hba1c: DiabetesFormFields.hba1c,
    );
    if (!_page3Key.currentState!.mounted) return;

    if (ok) {
      _page3Key.currentState!.setState(() {
        _page3Key.currentState!.waiting = false;
        DiabetesFormFields.prediction = data['prediction'] == 1;
      });
    } else {
      _page3Key.currentState!.setState(() {
        _page3Key.currentState!.waiting = null;
      });
    }
    setState(() {});
  }

  void _share() {
    final text =
        '''
[[ Diabeat - AI糖尿病風險檢測 ]]

[基本資料]
性別: ${DiabetesFormFields.genderString}
年齡: ${DiabetesFormFields.age} 歲
身高: ${DiabetesFormFields.height} cm
體重: ${DiabetesFormFields.weight} kg
BMI: ${DiabetesFormFields.bmi} kg/m^2

[疾病史/吸菸史]
高血壓: ${DiabetesFormFields.hypertension ? '有' : '無'}
心臟病: ${DiabetesFormFields.heartDisease ? '有' : '無'}
吸菸史: ${DiabetesFormFields.smokingHistoryText}

[血糖值/糖化血色素]
血糖值: ${DiabetesFormFields.glucose} mg/dL
糖化血色素: ${DiabetesFormFields.hba1c} %

[檢測結果]
${DiabetesFormFields.prediction ? '有' : '無'}
''';

    SharePlus.instance.share(ShareParams(text: text));
  }
}
