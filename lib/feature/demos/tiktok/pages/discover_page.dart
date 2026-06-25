import 'package:flutter/material.dart';

class _Trend {
  final String tag;
  final String views;
  final Color color;
  const _Trend(this.tag, this.views, this.color);
}

const _trends = <_Trend>[
  _Trend('#flutter', '12.4M views', Color(0xFF4E4E97)),
  _Trend('#startik', '8.9M views', Color(0xFFFE2C55)),
  _Trend('#dancechallenge', '24.1M views', Color(0xFFFFB300)),
  _Trend('#cooking', '5.2M views', Color(0xFF43A047)),
  _Trend('#comedy', '18.6M views', Color(0xFF8E24AA)),
  _Trend('#tech', '3.8M views', Color(0xFF1E88E5)),
];

const _videoTiles = <Color>[
  Color(0xFF1E1E2E),
  Color(0xFF2D1B3D),
  Color(0xFF3D1B2D),
  Color(0xFF1B3D2D),
  Color(0xFF3D2D1B),
  Color(0xFF1B2D3D),
  Color(0xFF2D3D1B),
  Color(0xFF3D1B1B),
  Color(0xFF1B1B3D),
];

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white54, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Search users, videos, sounds',
                    hintStyle:
                        TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: const Text('Trending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _trends.length,
                itemBuilder: (context, i) {
                  final t = _trends[i];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: t.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.trending_up,
                            color: Colors.white, size: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(t.views,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('For You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final color = _videoTiles[i % _videoTiles.length];
                  return Container(
                    color: color,
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(Icons.play_arrow,
                              color: Colors.white24, size: 40),
                        ),
                        Positioned(
                          left: 4,
                          bottom: 4,
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 2),
                              Text('${(i + 1) * 12}K',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
