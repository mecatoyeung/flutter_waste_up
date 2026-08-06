import 'package:flutter/material.dart';

const yellow = Color(0xFFF6C945);
const ink = Color(0xFF172019);
const muted = Color(0xFF69726B);
const page = Color(0xFFF7F7F2);

void main() => runApp(const WasteUpApp());

class WasteUpApp extends StatelessWidget {
  const WasteUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Up',
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
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  int selectedNav = 0;
  bool showNearby = false;
  final savedJobs = <String>{'Community Garden Assistant'};

  final jobs = const [
    Job('Community Garden Assistant', 'Green Roots Collective',
        'Riverside · 1.4 km away', 'Part-time', '£14/hr', Icons.spa_outlined,
        Color(0xFFD9EAC9)),
    Job('Recycling Sorter', 'Second Cycle Co.', 'Central District · 2.1 km away',
        'Flexible shifts', '£16/hr', Icons.recycling_outlined, Color(0xFFCBE5E3)),
    Job('Kitchen Support Worker', 'The Good Table', 'Market Square · 3.0 km away',
        'Full-time', '£15/hr', Icons.soup_kitchen_outlined, Color(0xFFF8DEB1)),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Job> get visibleJobs {
    final term = searchController.text.trim().toLowerCase();
    if (term.isEmpty) return jobs;
    return jobs
        .where((job) => job.title.toLowerCase().contains(term) || job.organisation.toLowerCase().contains(term))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final matches = visibleJobs;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 192,
        titleSpacing: 24,
        title: Row(children: [
          Image.asset('web/logo_transparent_bg_192x192.png', width: 192, height: 192),
          const SizedBox(width: 32),
          const Text('Waste Up', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => message('You are all caught up.'),
            icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_none)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 116),
          children: [
            const Text('Good morning, Amara', style: TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 6),
            const Text('Find work that\nworks for you.', style: TextStyle(fontSize: 32, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.1)),
            const SizedBox(height: 24),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Job title, skill, or organisation',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
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
                label: Text(showNearby ? 'Nearby' : 'Near me'),
                style: outlinedStyle(showNearby ? yellow : Colors.white, ink),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => message('Filters will help tailor your search.'),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Filters'),
                style: outlinedStyle(Colors.white, const Color(0xFFDDE0DA)),
              ),
            ]),
            const SizedBox(height: 32),
            ImpactBanner(onPressed: () => message('Your profile is 80% complete.')),
            const SizedBox(height: 34),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Recommended for you', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              TextButton(onPressed: () => message('Showing all opportunities.'), child: const Text('See all')),
            ]),
            const SizedBox(height: 12),
            if (matches.isEmpty)
              const EmptyJobs()
            else
              ...matches.map((job) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: JobCard(
                      job: job,
                      isSaved: savedJobs.contains(job.title),
                      onTap: () => showJobDetails(job),
                      onSave: () => setState(() {
                        savedJobs.contains(job.title) ? savedJobs.remove(job.title) : savedJobs.add(job.title);
                      }),
                    ),
                  )),
            const SizedBox(height: 26),
            const Text('Your progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const ProgressCard(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedNav,
        onDestinationSelected: (index) {
          setState(() => selectedNav = index);
          if (index != 0) message(['Discover', 'Saved roles', 'Your applications', 'Your profile'][index]);
        },
        backgroundColor: Colors.white,
        indicatorColor: yellow,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'Applied'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
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
                message('Application started for ${job.title}.');
              },
              style: FilledButton.styleFrom(backgroundColor: yellow, foregroundColor: ink, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              child: const Text('Apply now'),
            ),
          ),
        ]),
      ),
    );
  }
}

class Job {
  const Job(this.title, this.organisation, this.location, this.type, this.pay, this.icon, this.color);
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
              IconButton(onPressed: onSave, tooltip: isSaved ? 'Remove saved job' : 'Save job', icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border)),
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
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Small steps, real momentum.', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 6), Text('Complete your profile to unlock better matches.', style: TextStyle(color: Color(0xFFCAD0C9), height: 1.35))])),
          const SizedBox(width: 12),
          IconButton(onPressed: onPressed, color: ink, style: IconButton.styleFrom(backgroundColor: yellow, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), icon: const Icon(Icons.arrow_forward)),
        ]),
      );
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.auto_awesome_outlined), SizedBox(width: 8), Text('Profile strength', style: TextStyle(fontWeight: FontWeight.w800)), Spacer(), Text('80%', style: TextStyle(fontWeight: FontWeight.w800))]), const SizedBox(height: 16), const LinearProgressIndicator(value: .8, minHeight: 9, color: yellow, backgroundColor: Color(0xFFE7E9E4), borderRadius: BorderRadius.zero), const SizedBox(height: 12), const Text('Add your availability to make your profile stand out.', style: TextStyle(color: muted))])));
}

class EmptyJobs extends StatelessWidget {
  const EmptyJobs({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(28), color: Colors.white, child: const Column(children: [Icon(Icons.search_off_outlined, size: 34), SizedBox(height: 10), Text('No opportunities found', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Try a different title or skill.', style: TextStyle(color: muted))]));
}
