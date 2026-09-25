class ProfileConfigModel {
  final String name;
  final String tagline;
  final String phone;
  final String whatsappNumber;
  final String email;
  final String location;
  final String locationShort;
  final String avatarUrl;

  // Hero Section Customizations
  final String heroTitle;
  final String heroSubtitle;
  final String heroBadge1;
  final String heroBadge2;

  // About Section Customizations
  final String aboutHeading;
  final String aboutSubtitle;
  final String aboutBio;
  final String aboutMission;

  // Services Section Customizations
  final String servicesHeading;
  final String servicesSubtitle;

  // Projects Section Customizations
  final String projectsHeading;
  final String projectsSubtitle;

  // Why Work Section Customizations
  final String whyWorkHeading;
  final String whyWorkSubtitle;
  final String consultationTitle;
  final String consultationSubtitle;

  // Contact Section Customizations
  final String contactHeading;
  final String contactSubtitle;
  final String whatsappDefaultMessage;
  final String mapsEmbedQuery;

  // Social & External Links
  final String githubUrl;
  final String linkedinUrl;
  final String instagramUrl;

  // Theme & Appearance Customizations
  final String themePreset;
  final String primaryColorHex;
  final String secondaryColorHex;
  final String accentColorHex;
  final bool isDarkModeDefault;

  // Footer & Security Settings
  final String footerAbout;
  final String copyrightText;
  final String adminPasscode;
  final bool isAdminPinRequired;

  const ProfileConfigModel({
    this.name = 'Manish Maurya',
    this.tagline = 'Digital Marketing | Website & App Development',
    this.phone = '7380492118',
    this.whatsappNumber = '7380492118',
    this.email = 'manishmaurya.digital@gmail.com',
    this.location = 'Harahua, Varanasi, Uttar Pradesh, India',
    this.locationShort = 'Harahua, Varanasi (UP)',
    this.avatarUrl = '',
    this.themePreset = 'indigo_purple',
    this.primaryColorHex = '#6366F1',
    this.secondaryColorHex = '#8B5CF6',
    this.accentColorHex = '#EC4899',
    this.isDarkModeDefault = true,
    this.heroTitle = 'Aapke Business Ko Online Le Jane Ka Complete Solution',
    this.heroSubtitle =
        'Main Manish Maurya, ek passionate Digital Marketer aur Full-Stack Web & App Developer hoon. High-converting Meta/Google Ads campaigns, fast-loading SEO websites, aur modern mobile applications se aapka business tezi se grow karta hoon.',
    this.heroBadge1 = 'Available for Projects',
    this.heroBadge2 = 'ROI Focused',
    this.aboutHeading = 'About Manish Maurya',
    this.aboutSubtitle = 'Digital Marketer & Full-Stack Developer',
    this.aboutBio =
        'Namaste! Main Manish Maurya hoon, Harahua, Varanasi (UP) se. Mera goal local businesses aur digital entrepreneurs ko powerful online presence provide karna hai. Main ROI-driven Digital Marketing, Google & Meta Ads, targeted SEO strategies, aur scalable Website/App Development me specialize karta hoon. Har project ko time par aur highest quality ke sath deliver karna meri pehli priority hai.',
    this.aboutMission = 'Har business ke liye customized digital blueprint aur continuous growth execution.',
    this.servicesHeading = 'My Specialized Services',
    this.servicesSubtitle =
        'Har business ko modern technology aur results-oriented marketing se scale karne ke liye comprehensive solutions.',
    this.projectsHeading = 'Featured Projects Showcase',
    this.projectsSubtitle =
        'Live digital campaigns, modern responsive websites aur dynamic cross-platform mobile apps.',
    this.whyWorkHeading = 'Why Work With Manish Maurya?',
    this.whyWorkSubtitle =
        'Aapke business ke liye dedicated, transparent aur result-driven digital partnership.',
    this.consultationTitle = 'Ready to grow your business online?',
    this.consultationSubtitle = 'Free consultation ke liye aaj hi WhatsApp ya direct call par connect karein.',
    this.contactHeading = 'Let’s Discuss Your Next Big Project',
    this.contactSubtitle =
        'Aapke business requirements ke mutabik customized proposal aur free guidance paayein.',
    this.whatsappDefaultMessage =
        'Namaste Manish ji! Maine aapka portfolio website dekha aur mujhe aapke services ke baare me baat karni hai.',
    this.mapsEmbedQuery = 'Harahua, Varanasi, Uttar Pradesh, India',
    this.githubUrl = 'https://github.com',
    this.linkedinUrl = 'https://linkedin.com',
    this.instagramUrl = '',
    this.footerAbout =
        'Helping businesses establish commanding digital presence through high-ROI Meta & Google Ads, local SEO supremacy, and ultra-fast web/mobile applications.',
    this.copyrightText = 'Manish Maurya. All rights reserved.',
    this.adminPasscode = '1234',
    this.isAdminPinRequired = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagline': tagline,
        'phone': phone,
        'whatsappNumber': whatsappNumber,
        'email': email,
        'location': location,
        'locationShort': locationShort,
        'avatarUrl': avatarUrl,
        'heroTitle': heroTitle,
        'heroSubtitle': heroSubtitle,
        'heroBadge1': heroBadge1,
        'heroBadge2': heroBadge2,
        'aboutHeading': aboutHeading,
        'aboutSubtitle': aboutSubtitle,
        'aboutBio': aboutBio,
        'aboutMission': aboutMission,
        'servicesHeading': servicesHeading,
        'servicesSubtitle': servicesSubtitle,
        'projectsHeading': projectsHeading,
        'projectsSubtitle': projectsSubtitle,
        'whyWorkHeading': whyWorkHeading,
        'whyWorkSubtitle': whyWorkSubtitle,
        'themePreset': themePreset,
        'primaryColorHex': primaryColorHex,
        'secondaryColorHex': secondaryColorHex,
        'accentColorHex': accentColorHex,
        'isDarkModeDefault': isDarkModeDefault,
        'consultationTitle': consultationTitle,
        'consultationSubtitle': consultationSubtitle,
        'contactHeading': contactHeading,
        'contactSubtitle': contactSubtitle,
        'whatsappDefaultMessage': whatsappDefaultMessage,
        'mapsEmbedQuery': mapsEmbedQuery,
        'githubUrl': githubUrl,
        'linkedinUrl': linkedinUrl,
        'instagramUrl': instagramUrl,
        'footerAbout': footerAbout,
        'copyrightText': copyrightText,
        'adminPasscode': adminPasscode,
        'isAdminPinRequired': isAdminPinRequired,
      };

  factory ProfileConfigModel.fromJson(Map<String, dynamic> json) {
    return ProfileConfigModel(
      name: json['name'] as String? ?? 'Manish Maurya',
      tagline: json['tagline'] as String? ?? 'Digital Marketing | Website & App Development',
      phone: json['phone'] as String? ?? '7380492118',
      whatsappNumber: json['whatsappNumber'] as String? ?? '7380492118',
      email: json['email'] as String? ?? 'manishmaurya.digital@gmail.com',
      location: json['location'] as String? ?? 'Harahua, Varanasi, Uttar Pradesh, India',
      locationShort: json['locationShort'] as String? ?? 'Harahua, Varanasi (UP)',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      themePreset: json['themePreset'] as String? ?? 'indigo_purple',
      primaryColorHex: json['primaryColorHex'] as String? ?? '#6366F1',
      secondaryColorHex: json['secondaryColorHex'] as String? ?? '#8B5CF6',
      accentColorHex: json['accentColorHex'] as String? ?? '#EC4899',
      isDarkModeDefault: json['isDarkModeDefault'] as bool? ?? true,
      heroTitle: json['heroTitle'] as String? ?? 'Aapke Business Ko Online Le Jane Ka Complete Solution',
      heroSubtitle: json['heroSubtitle'] as String? ?? '',
      heroBadge1: json['heroBadge1'] as String? ?? 'Available for Projects',
      heroBadge2: json['heroBadge2'] as String? ?? 'ROI Focused',
      aboutHeading: json['aboutHeading'] as String? ?? 'About Manish Maurya',
      aboutSubtitle: json['aboutSubtitle'] as String? ?? 'Digital Marketer & Full-Stack Developer',
      aboutBio: json['aboutBio'] as String? ?? '',
      aboutMission: json['aboutMission'] as String? ?? '',
      servicesHeading: json['servicesHeading'] as String? ?? 'My Specialized Services',
      servicesSubtitle: json['servicesSubtitle'] as String? ?? '',
      projectsHeading: json['projectsHeading'] as String? ?? 'Featured Projects Showcase',
      projectsSubtitle: json['projectsSubtitle'] as String? ?? '',
      whyWorkHeading: json['whyWorkHeading'] as String? ?? 'Why Work With Manish Maurya?',
      whyWorkSubtitle: json['whyWorkSubtitle'] as String? ?? '',
      consultationTitle: json['consultationTitle'] as String? ?? 'Ready to grow your business online?',
      consultationSubtitle: json['consultationSubtitle'] as String? ?? '',
      contactHeading: json['contactHeading'] as String? ?? 'Let’s Discuss Your Next Big Project',
      contactSubtitle: json['contactSubtitle'] as String? ?? '',
      whatsappDefaultMessage: json['whatsappDefaultMessage'] as String? ?? '',
      mapsEmbedQuery: json['mapsEmbedQuery'] as String? ?? 'Harahua, Varanasi, Uttar Pradesh, India',
      githubUrl: json['githubUrl'] as String? ?? 'https://github.com',
      linkedinUrl: json['linkedinUrl'] as String? ?? 'https://linkedin.com',
      instagramUrl: json['instagramUrl'] as String? ?? '',
      footerAbout: json['footerAbout'] as String? ?? '',
      copyrightText: json['copyrightText'] as String? ?? 'Manish Maurya. All rights reserved.',
      adminPasscode: json['adminPasscode'] as String? ?? '1234',
      isAdminPinRequired: json['isAdminPinRequired'] as bool? ?? false,
    );
  }

  ProfileConfigModel copyWith({
    String? name,
    String? tagline,
    String? phone,
    String? whatsappNumber,
    String? email,
    String? location,
    String? locationShort,
    String? avatarUrl,
    String? themePreset,
    String? primaryColorHex,
    String? secondaryColorHex,
    String? accentColorHex,
    bool? isDarkModeDefault,
    String? heroTitle,
    String? heroSubtitle,
    String? heroBadge1,
    String? heroBadge2,
    String? aboutHeading,
    String? aboutSubtitle,
    String? aboutBio,
    String? aboutMission,
    String? servicesHeading,
    String? servicesSubtitle,
    String? projectsHeading,
    String? projectsSubtitle,
    String? whyWorkHeading,
    String? whyWorkSubtitle,
    String? consultationTitle,
    String? consultationSubtitle,
    String? contactHeading,
    String? contactSubtitle,
    String? whatsappDefaultMessage,
    String? mapsEmbedQuery,
    String? githubUrl,
    String? linkedinUrl,
    String? instagramUrl,
    String? footerAbout,
    String? copyrightText,
    String? adminPasscode,
    bool? isAdminPinRequired,
  }) {
    return ProfileConfigModel(
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      location: location ?? this.location,
      locationShort: locationShort ?? this.locationShort,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      themePreset: themePreset ?? this.themePreset,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      secondaryColorHex: secondaryColorHex ?? this.secondaryColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      isDarkModeDefault: isDarkModeDefault ?? this.isDarkModeDefault,
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      heroBadge1: heroBadge1 ?? this.heroBadge1,
      heroBadge2: heroBadge2 ?? this.heroBadge2,
      aboutHeading: aboutHeading ?? this.aboutHeading,
      aboutSubtitle: aboutSubtitle ?? this.aboutSubtitle,
      aboutBio: aboutBio ?? this.aboutBio,
      aboutMission: aboutMission ?? this.aboutMission,
      servicesHeading: servicesHeading ?? this.servicesHeading,
      servicesSubtitle: servicesSubtitle ?? this.servicesSubtitle,
      projectsHeading: projectsHeading ?? this.projectsHeading,
      projectsSubtitle: projectsSubtitle ?? this.projectsSubtitle,
      whyWorkHeading: whyWorkHeading ?? this.whyWorkHeading,
      whyWorkSubtitle: whyWorkSubtitle ?? this.whyWorkSubtitle,
      consultationTitle: consultationTitle ?? this.consultationTitle,
      consultationSubtitle: consultationSubtitle ?? this.consultationSubtitle,
      contactHeading: contactHeading ?? this.contactHeading,
      contactSubtitle: contactSubtitle ?? this.contactSubtitle,
      whatsappDefaultMessage: whatsappDefaultMessage ?? this.whatsappDefaultMessage,
      mapsEmbedQuery: mapsEmbedQuery ?? this.mapsEmbedQuery,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      footerAbout: footerAbout ?? this.footerAbout,
      copyrightText: copyrightText ?? this.copyrightText,
      adminPasscode: adminPasscode ?? this.adminPasscode,
      isAdminPinRequired: isAdminPinRequired ?? this.isAdminPinRequired,
    );
  }
}
