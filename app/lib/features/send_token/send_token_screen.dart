import 'package:app/features/stealth/stealth_service.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendTokenScreen extends ConsumerStatefulWidget {
  const SendTokenScreen(this.name, this.addressAndEphemeralPubKey, {super.key});
  final String name;
  final StealthAddressAndEphemeralPubKey addressAndEphemeralPubKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendTokenScreenState();
}

class _SendTokenScreenState extends ConsumerState<SendTokenScreen> {
  final textEditingController = TextEditingController();

  // initState
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              DefaultButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Text(
                          widget.name[0],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Gaps.w8,
                      Text(
                          "TO：${widget.addressAndEphemeralPubKey.$1.toFormattedAddress()}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/USDC.png",
                          width: 20,
                        ),
                        Gaps.w4,
                        const Text(
                          "USDC",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gaps.h32,
                    TextField(
                      autofocus: true,
                      onChanged: (value) => setState(() {}),
                      controller: textEditingController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                    ),
                    Gaps.h16,
                    const Text(
                      "Enter the amount you want to send",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              DefaultButton(
                isDisable: textEditingController.text.isEmpty,
                showIcon: true,
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (_) {
                        return const SuccessCard();
                      });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessCard extends StatefulWidget {
  const SuccessCard({
    super.key,
  });

  @override
  State<SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<SuccessCard> {
  bool isSuccess = false;
  @override
  void initState() {
    asyncInit();

    super.initState();
  }

  void asyncInit() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSuccess
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    )
                  : Image.asset(
                      'assets/icons/ninja_run.gif',
                      width: 200,
                    ),
              Gaps.h16,
              Text(
                isSuccess ? "🥷：Mission Complete!" : "🥷：We're working on it.",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
