import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const teamMembers = [
    ('Aufan Damays Marsuki', '21120124140163'),
    ('Faras Fauzan Attaqi', '21120124140119'),
    ('Zikri Arribath Vadila', '21120124130089'),
    ('Hening WIjaya Imanda', '211202124120036'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Kelompok')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 700 ? 2 : 1;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    'assets/images/WhatsApp Image 2026-09-27 at 13.08.14.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    'Anggota Kelompok',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: teamMembers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: 112,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final (name, nim) = teamMembers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            name
                                .split(' ')
                                .take(2)
                                .map((part) => part[0])
                                .join(),
                          ),
                        ),
                        title: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('NIM: $nim'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
