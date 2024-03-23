import 'package:app/features/collect_token/collect_token_screen.dart';
import 'package:app/features/home/controllers/user_addresses_controller.dart';
import 'package:app/features/home/controllers/user_controller.dart';
import 'package:app/features/home/domain/jumping_dot.dart';
import 'package:app/features/home/domain/userdata.dart';
import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:app/features/send_token/scan_address_screen.dart';
import 'package:app/utils/app_tap.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/stealth_private_key.dart';
import 'package:app/utils/string_utils.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double expandedHeight = 300;
    double appBarHeight = kToolbarHeight;
    double offset = _scrollController.offset;
    if (offset < 200) {
      _opacity = 0;
      setState(() {});
      return;
    }
    double newOpacity = (offset / (expandedHeight - appBarHeight)).clamp(0, 1);
    // 更新透明度
    setState(() {
      _opacity = newOpacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataControllerProvider);
    final userUtxoAddress = ref.watch(userUtxoAddressProvider);
    debugPrint('======={userUtxoAddress} : $userUtxoAddress=========');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(userUtxoAddressProvider.notifier).updateState();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true, // 固定AppBar在顶部
                  surfaceTintColor: Colors.transparent,
                  expandedHeight: 300.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    title: Opacity(
                      opacity: _opacity,
                      child: AppBarSmall(userData: userData),
                    ),
                    background: Column(
                      children: [
                        Gaps.h32,
                        TotalBalanceWidget(
                          userData: userData,
                        ),
                        Gaps.h32,
                        // AppTap(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const SendTokenScreen(
                        //             "dora",
                        //             "0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B"),
                        //       ),
                        //     );
                        //   },
                        //   child: const Text("test"),
                        // ),
                        SendReceieveBtn(
                          name: userData.name,
                        ),
                        Gaps.h32,
                      ],
                    ),
                  ),
                ),
                userUtxoAddress.when(
                  data: (value) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 150.0,
                              child: TxHistoryItem(
                                value: value[index],
                              ),
                            ),
                          );
                        },
                        childCount: value.length,
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  error: (error, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TxHistoryItem extends StatelessWidget {
  TxHistoryItem({
    super.key,
    required this.value,
  });

  final UtxoAddress value;

  final emojis = [
    '🥷',
    '👨‍🚀',
    '👨‍🚒',
    '👨‍🎨',
    '👨‍🎤',
    '👨‍🏫',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AppTap(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: value.address,
            ),
          );
          customToast(
            'Copied to clipboard!',
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  emojis[value.address.hashCode % emojis.length],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              Gaps.w16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Received",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value.address.toFormattedAddress(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${value.balance / BigInt.from(10).pow(6)}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.w4,
                    Image.asset('assets/icons/USDC.png', width: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarSmall extends StatelessWidget {
  const AppBarSmall({super.key, required this.userData});

  final UserData userData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Text(
            '🥷',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Gaps.w8,
          Text(
            userData.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Text(
            userData.totalBalance,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Gaps.w12,
          Image.asset('assets/icons/USDC.png', width: 24),
        ],
      ),
    );
  }
}

class SendReceieveBtn extends StatelessWidget {
  const SendReceieveBtn({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return QrcodeCard(
                      name: name,
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/receieve.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Receive"),
          ],
        ),
        Gaps.w24,
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanAddressScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/send.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Send"),
          ],
        ),
        Gaps.w24,
        Column(
          children: [
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CollectTokenScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/icons/collect.png',
                  width: 32,
                ),
              ),
            ),
            const Text("Collect"),
          ],
        ),
      ],
    );
  }
}

class QrcodeCard extends StatelessWidget {
  const QrcodeCard({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrettyQrView.data(
              data: StealthPrivateKey.alice.toEncodeStr(name),
              decoration: const PrettyQrDecoration(
                image: PrettyQrDecorationImage(
                  image: AssetImage('assets/icons/USDC.png'),
                ),
              ),
            ),
          ),
          Gaps.h24,
          DefaultButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: StealthPrivateKey.alice.toEncodeStr(name),
                ),
              );
              customToast(
                'Copied to clipboard!',
              );
            },
            text: "Copy Data",
            showIcon: true,
          ),
        ],
      ),
    );
  }
}

class TotalBalanceWidget extends ConsumerWidget {
  const TotalBalanceWidget({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUtxoAddress = ref.watch(userUtxoAddressProvider);

    return Column(
      children: [
        Text(
          '🥷 Total Balance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Gaps.h24,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/USDC.png',
              width: 28,
            ),
            Gaps.w8,

            //richText with decimal
            userUtxoAddress.when(
              data: (value) {
                final totalBalance = getBalance(value);
                return RichText(
                  text: TextSpan(
                    text: totalBalance.split('.')[0],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: totalBalance.split('.').length > 1
                            ? '.${totalBalance.split('.')[1]}'
                            : '.00',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                      ),
                      TextSpan(
                        text: 'USDC',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const SizedBox(
                  width: 32.0,
                  height: 52.0,
                  child: JumpingDotIndicator(
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              error: (error, _) => Text('Error: $error'),
            ),
          ],
        ),
      ],
    );
  }
}
