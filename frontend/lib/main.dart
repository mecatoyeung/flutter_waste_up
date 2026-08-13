import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:waste_up/l10n/app_localizations.dart';

const yellow = Color(0xFFF6C945);
const ink = Color(0xFF172019);
const muted = Color(0xFF69726B);
const page = Color(0xFFF7F7F2);

void main() => runApp(const WasteUpApp());

class WasteUpApp extends StatefulWidget {
  const WasteUpApp({super.key, this.locale});

  final Locale? locale;

  @override
  State<WasteUpApp> createState() => _WasteUpAppState();
}

class _WasteUpAppState extends State<WasteUpApp> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.locale ?? const Locale('zh', 'TW');
  }

  @override
  void didUpdateWidget(covariant WasteUpApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locale != oldWidget.locale && widget.locale != null) {
      selectedLocale = widget.locale!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: selectedLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) return supportedLocale;
          }
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) return supportedLocale;
          }
        }
        return const Locale('zh', 'TW');
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: yellow,
          primary: yellow,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: page,
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFDDE0DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFDDE0DA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: ink, width: 1.5),
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      home: HomeScreen(
        locale: selectedLocale,
        onLocaleChanged: (locale) => setState(() => selectedLocale = locale),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  int selectedNav = 0;
  bool showNearby = false;
  bool isAuthenticated = false;
  final savedJobs = <String>{'communityGarden'};

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Job> visibleJobs(AppLocalizations l10n) {
    final term = searchController.text.trim().toLowerCase();
    final jobs = [
      Job('communityGarden', l10n.communityGardenAssistant, l10n.greenRootsCollective, l10n.riversideLocation, l10n.partTime, l10n.pay14, Icons.spa_outlined, const Color(0xFFD9EAC9)),
      Job('recyclingSorter', l10n.recyclingSorter, l10n.secondCycle, l10n.centralDistrictLocation, l10n.flexibleShifts, l10n.pay16, Icons.recycling_outlined, const Color(0xFFCBE5E3)),
      Job('kitchenSupport', l10n.kitchenSupportWorker, l10n.goodTable, l10n.marketSquareLocation, l10n.fullTime, l10n.pay15, Icons.soup_kitchen_outlined, const Color(0xFFF8DEB1)),
    ];
    if (term.isEmpty) return jobs;
    return jobs
        .where((job) => job.title.toLowerCase().contains(term) || job.organisation.toLowerCase().contains(term))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final matches = visibleJobs(l10n);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        titleSpacing: 24,
        title: Row(children: [
          Text(l10n.appTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          PopupMenuButton<Locale>(
            tooltip: 'Language',
            icon: const Icon(Icons.language),
            initialValue: widget.locale,
            onSelected: widget.onLocaleChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('zh', 'TW'), child: Text('繁體中文')),
              PopupMenuItem(value: Locale('zh', 'CN'), child: Text('简体中文')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () => message(l10n.allCaughtUp),
            icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_none)),
          ),
          PopupMenuButton<_AccountAction>(
            tooltip: l10n.account,
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: handleAccountAction,
            itemBuilder: (context) => isAuthenticated
                ? [
                    PopupMenuItem(
                      value: _AccountAction.profile,
                      child: ListTile(leading: const Icon(Icons.person_outline), title: Text(l10n.profile)),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: _AccountAction.signOut,
                      child: ListTile(leading: const Icon(Icons.logout), title: Text(l10n.signOut)),
                    ),
                  ]
                : [
                    PopupMenuItem(
                      value: _AccountAction.signIn,
                      child: ListTile(leading: const Icon(Icons.login), title: Text(l10n.signIn)),
                    ),
                    PopupMenuItem(
                      value: _AccountAction.signUp,
                      child: ListTile(leading: const Icon(Icons.person_add_outlined), title: Text(l10n.signUp)),
                    ),
                  ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 116),
          children: [
            Text(l10n.greeting, style: const TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 6),
            Text(l10n.heroTitle, style: const TextStyle(fontSize: 32, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.1)),
            const SizedBox(height: 24),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.clearSearch,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Row(children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => showNearby = !showNearby),
                icon: Icon(showNearby ? Icons.check : Icons.near_me_outlined, size: 18),
                label: Text(showNearby ? l10n.nearby : l10n.nearMe),
                style: outlinedStyle(showNearby ? yellow : Colors.white, ink),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => message(l10n.filtersMessage),
                icon: const Icon(Icons.tune, size: 18),
                label: Text(l10n.filters),
                style: outlinedStyle(Colors.white, const Color(0xFFDDE0DA)),
              ),
            ]),
            const SizedBox(height: 32),
            ImpactBanner(onPressed: () => message(l10n.profileComplete)),
            const SizedBox(height: 34),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l10n.recommended, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              TextButton(onPressed: () => message(l10n.showingAll), child: Text(l10n.seeAll)),
            ]),
            const SizedBox(height: 12),
            if (matches.isEmpty)
              const EmptyJobs()
            else
              ...matches.map((job) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: JobCard(
                      job: job,
                      isSaved: savedJobs.contains(job.id),
                      onTap: () => showJobDetails(job),
                      onSave: () => setState(() {
                        savedJobs.contains(job.id) ? savedJobs.remove(job.id) : savedJobs.add(job.id);
                      }),
                    ),
                  )),
            const SizedBox(height: 26),
            Text(l10n.progress, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const ProgressCard(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedNav,
        onDestinationSelected: (index) {
          setState(() => selectedNav = index);
          if (index != 0) message([l10n.discover, l10n.savedRoles, l10n.yourApplications, l10n.yourProfile][index]);
        },
        backgroundColor: Colors.white,
        indicatorColor: yellow,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.explore_outlined), selectedIcon: const Icon(Icons.explore), label: l10n.discover),
          NavigationDestination(icon: const Icon(Icons.bookmark_border), selectedIcon: const Icon(Icons.bookmark), label: l10n.saved),
          NavigationDestination(icon: const Icon(Icons.work_outline), selectedIcon: const Icon(Icons.work), label: l10n.applied),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.profile),
        ],
      ),
    );
  }

  ButtonStyle outlinedStyle(Color background, Color border) => OutlinedButton.styleFrom(
        foregroundColor: ink,
        backgroundColor: background,
        side: BorderSide(color: border),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      );

  void handleAccountAction(_AccountAction action) {
    switch (action) {
      case _AccountAction.signIn:
      case _AccountAction.signUp:
        setState(() => isAuthenticated = true);
      case _AccountAction.profile:
        setState(() => selectedNav = 3);
      case _AccountAction.signOut:
        setState(() => isAuthenticated = false);
    }
  }

  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void showJobDetails(Job job) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(job.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(job.organisation, style: const TextStyle(color: muted)),
          const SizedBox(height: 20),
          Text('${job.type}  ·  ${job.pay}  ·  ${job.location}'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                message(AppLocalizations.of(context)!.applicationStarted(job.title));
              },
              style: FilledButton.styleFrom(backgroundColor: yellow, foregroundColor: ink, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              child: Text(AppLocalizations.of(context)!.applyNow),
            ),
          ),
        ]),
      ),
    );
  }
}

enum _AccountAction { signIn, signUp, profile, signOut }

class Job {
  const Job(this.id, this.title, this.organisation, this.location, this.type, this.pay, this.icon, this.color);
  final String id;
  final String title;
  final String organisation;
  final String location;
  final String type;
  final String pay;
  final IconData icon;
  final Color color;
}

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, required this.isSaved, required this.onSave, required this.onTap});
  final Job job;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 48, height: 48, color: job.color, child: Icon(job.icon, color: ink)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(job.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(job.organisation, style: const TextStyle(color: muted)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 6, children: [Tag(job.type), Tag(job.pay)]),
                const SizedBox(height: 11),
                Row(children: [const Icon(Icons.location_on_outlined, size: 15, color: muted), const SizedBox(width: 3), Expanded(child: Text(job.location, style: const TextStyle(fontSize: 12, color: muted), overflow: TextOverflow.ellipsis))]),
              ])),
              IconButton(onPressed: onSave, tooltip: isSaved ? AppLocalizations.of(context)!.removeSavedJob : AppLocalizations.of(context)!.saveJob, icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border)),
            ]),
          ),
        ),
      );
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), color: const Color(0xFFF0F2ED), child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)));
}

class ImpactBanner extends StatelessWidget {
  const ImpactBanner({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Container(
        color: ink,
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppLocalizations.of(context)!.impactTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(AppLocalizations.of(context)!.impactDescription, style: const TextStyle(color: Color(0xFFCAD0C9), height: 1.35))])),
          const SizedBox(width: 12),
          IconButton(onPressed: onPressed, color: ink, style: IconButton.styleFrom(backgroundColor: yellow, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), icon: const Icon(Icons.arrow_forward)),
        ]),
      );
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.auto_awesome_outlined), const SizedBox(width: 8), Text(l10n.profileStrength, style: const TextStyle(fontWeight: FontWeight.w800)), const Spacer(), Text(l10n.profileStrengthValue, style: const TextStyle(fontWeight: FontWeight.w800))]), const SizedBox(height: 16), const LinearProgressIndicator(value: .8, minHeight: 9, color: yellow, backgroundColor: Color(0xFFE7E9E4), borderRadius: BorderRadius.zero), const SizedBox(height: 12), Text(l10n.availabilityPrompt, style: const TextStyle(color: muted))])));
  }
}

class EmptyJobs extends StatelessWidget {
  const EmptyJobs({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(padding: const EdgeInsets.all(28), color: Colors.white, child: Column(children: [const Icon(Icons.search_off_outlined, size: 34), const SizedBox(height: 10), Text(l10n.noOpportunities, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(l10n.tryDifferentSearch, style: const TextStyle(color: muted))]));
  }
}
