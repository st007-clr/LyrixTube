import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../provider/lyrics_provider.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LyricsProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Color(0xffef4445)),
          ),
          title: const Text(
            'LyrixTube',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<LyricsProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "The Ultimate Song Lyrics Generator. Instantly generate song lyrics from any YouTube link with ease.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  /// Input Card
                  Card(
                    elevation: 0,
                    color: Color(0xffF5F6FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _linkController,
                        decoration: InputDecoration(
                          hintText: 'Paste your YouTube music link',
                          prefixIcon: const Icon(Icons.link),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color(0xffef4445),
                      ),
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              provider.generateLyrics(
                                _linkController.text.trim(),
                              );
                            },
                      child: const Text(
                        'Generate Lyrics',
                        style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (provider.isLoading) _shimmerLoader(),

                  if (provider.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        provider.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  if (!provider.isLoading && provider.lyrics != null)
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Color(0xffF5F6FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.song ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.artist ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                                const Divider(height: 24),
                                Text(
                                  provider.lyrics!,
                                  style: const TextStyle(
                                    height: 1.6,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _shimmerLoader() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
