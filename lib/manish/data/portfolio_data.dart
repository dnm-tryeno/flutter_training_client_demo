import '../models/profile_config_model.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';
import '../models/why_work_model.dart';

class PortfolioData {
  static const ProfileConfigModel defaultConfig = ProfileConfigModel();

  // 6 Core Default Services
  static final List<ServiceModel> defaultServices = [
    const ServiceModel(
      id: 'digital_marketing',
      titleHindi: 'Digital Marketing',
      titleEnglish: 'Digital Marketing & Social Growth',
      shortDesc: 'Social media branding, audience targeting aur online business promotion se continuous leads paayein.',
      detailedDesc:
          'Comprehensive digital marketing strategy jisme social media management, brand visibility campaigns, customer engagement aur targeted lead generation shamil hai taaki aapka brand top par rahe.',
      iconCodePoint: 0xf0174, // Icons.trending_up_rounded
      accentColorValue: 0xFF6366F1,
      subOfferings: [
        'Social Media Marketing (SMM)',
        'High-Converting Lead Generation',
        'Online Business Promotion & Branding',
        'Audience Research & Growth Strategies',
        'Brand Awareness & Content Planning',
      ],
      benefits: [
        'Zyada genuine inquiries aur high-intent leads',
        'Brand credibility aur trust me badhotari',
        'Targeted local aur national audience reach',
        'Weekly performance reports aur transparent analytics',
      ],
    ),
    const ServiceModel(
      id: 'meta_ads',
      titleHindi: 'Meta Ads',
      titleEnglish: 'Facebook & Instagram Advertising',
      shortDesc: 'Facebook & Instagram par targeted ads chala kar lowest cost me maximum qualified leads generate karein.',
      detailedDesc:
          'Meta Ads Manager ke through advanced audience demographic, interest-based targeting aur custom retargeting funnel setup jo seedhe aapke WhatsApp ya CRM me customers bhejta hai.',
      iconCodePoint: 0xe133, // Icons.campaign_rounded
      accentColorValue: 0xFFEC4899,
      subOfferings: [
        'Facebook Ads Campaign Setup & Management',
        'Instagram Reels & Feed Sponsored Ads',
        'Direct WhatsApp Message Lead Ads',
        'Retargeting & Lookalike Audience Building',
        'High-Converting Ad Copy & Creative Strategy',
      ],
      benefits: [
        'Low cost-per-lead (CPL) optimization',
        'Direct customer chats on WhatsApp',
        'A/B testing for maximum Return on Ad Spend (ROAS)',
        'Immediate customer engagement',
      ],
    ),
    const ServiceModel(
      id: 'seo',
      titleHindi: 'Search Engine Optimization (SEO)',
      titleEnglish: 'SEO & Google Ranking',
      shortDesc: 'Google ke 1st page par rank karein aur regular free organic traffic aur calls paayein.',
      detailedDesc:
          'Complete end-to-end SEO process jisme On-page SEO, Technical audit, Google Business Profile (Local Map SEO), aur high-ranking keyword research shamil hai.',
      iconCodePoint: 0xe567, // Icons.search_rounded
      accentColorValue: 0xFF10B981,
      subOfferings: [
        'On-Page SEO & Content Optimization',
        'Technical SEO & Core Web Vitals Fixes',
        'Local SEO & Google Business Profile (Map Pack)',
        'High-Intent Keyword Research & Competitor Analysis',
        'Google Search Console & Analytics Setup',
      ],
      benefits: [
        'Bina ad spend ke organic Google traffic',
        'Varanasi aur nearby areas me local map supremacy',
        'Long-term sustainable business growth',
        'High search visibility & brand authority',
      ],
    ),
    const ServiceModel(
      id: 'google_ads',
      titleHindi: 'Google Ads (PPC)',
      titleEnglish: 'Google Search, Display & YouTube Ads',
      shortDesc: 'Jab customer Google par aapki service search kare, to sabse pehle aapka ad dikhe.',
      detailedDesc:
          'High-intent Google Search Ads, Display Banners aur YouTube video promotions jo un customers ko target karte hain jo turant service purchase karne ke liye tayyar hain.',
      iconCodePoint: 0xf525, // Icons.ads_click_rounded
      accentColorValue: 0xFFF59E0B,
      subOfferings: [
        'Google Search Pay-Per-Click (PPC) Ads',
        'High-Impact Display Network Banner Ads',
        'YouTube Video Advertisement Campaigns',
        'Call-Only Ads for Instant Direct Phone Inquiries',
        'Negative Keyword Optimization & Budget Control',
      ],
      benefits: [
        'Day 1 se instant calls aur inquiries',
        'Sirf actual clicks par payment (Pay per click)',
        'High buyer-intent traffic',
        'Precise geo-fencing (Varanasi/UP/All India)',
      ],
    ),
    const ServiceModel(
      id: 'web_dev',
      titleHindi: 'Website Development',
      titleEnglish: 'Fast & Modern Responsive Websites',
      shortDesc: 'Mobile, tablet aur desktop par ultra-fast khulne wali sleek, SEO-friendly websites with admin panel.',
      detailedDesc:
          'Custom modern business websites, e-commerce stores, portfolio sites aur custom landing pages jo conversion-focused aur fast-loading hoti hain.',
      iconCodePoint: 0xe370, // Icons.laptop_mac_rounded
      accentColorValue: 0xFF38BDF8,
      subOfferings: [
        'Professional Business & Corporate Websites',
        'Full E-Commerce Stores with Payment Gateway',
        'Personal Portfolio & Freelancer Showcase',
        '100% Mobile Responsive & Fast Loading Speed',
        'Easy-to-use Admin Panel for Content Updates',
      ],
      benefits: [
        '24/7 online storefront for your business',
        'Modern aesthetics jo clients ko impress kare',
        'SSL secure, fast hosting & clean code',
        'SEO-friendly structure for high Google rank',
      ],
    ),
    const ServiceModel(
      id: 'app_dev',
      titleHindi: 'App Development',
      titleEnglish: 'Android & iOS Mobile Applications',
      shortDesc: 'Feature-rich, smooth aur interactive mobile apps for Android & iOS with backend admin dashboard.',
      detailedDesc:
          'Cross-platform Flutter & native architecture apps jo lightweight, fast, secure aur intuitive user experience provide karti hain.',
      iconCodePoint: 0xe4a2, // Icons.phone_android_rounded
      accentColorValue: 0xFF8B5CF6,
      subOfferings: [
        'Custom Android & iOS Cross-Platform Apps',
        'Business Management & Customer Service Apps',
        'E-Commerce & Delivery Mobile Applications',
        'Real-time Firebase Backend & Push Notifications',
        'Play Store & App Store Deployment Support',
      ],
      benefits: [
        'Direct connection to customers via mobile screen',
        'Instant push notifications for offers and updates',
        'Offline capabilities & smooth UI transitions',
        'Scalable cloud infrastructure',
      ],
    ),
  ];

  // Default Showcase Projects
  static final List<ProjectModel> defaultProjects = [
    const ProjectModel(
      id: 'p1',
      title: 'E-Commerce Store & Order Management',
      category: 'Website',
      shortDesc: 'Modern shopping web app with cart, online payments, live order tracking and admin dashboard.',
      detailedDesc:
          'A complete digital store built with responsive UI, instant product search, category filters, Razorpay/Stripe checkout, and real-time order status tracking with WhatsApp notifications for business owners.',
      techStack: ['React', 'Next.js', 'Node.js', 'Firebase', 'Tailwind/CSS'],
      liveDemoUrl: 'https://ecommerce-store-demo.vercel.app',
      imageUrl: 'https://images.unsplash.com/photo-1557821552-17105176677c?w=800&auto=format&fit=crop&q=60',
      keyFeatures: [
        'Fast product catalog with instant search',
        'Cart & wishlist persistence',
        'Secure multi-gateway payment integration',
        'Admin inventory management panel',
      ],
      resultsMetric: '2.4x Conversion Increase',
      isFeatured: true,
    ),
    const ProjectModel(
      id: 'p2',
      title: 'Local Varanasi Business Lead Engine',
      category: 'Meta Ads',
      shortDesc: 'Targeted Meta ads and automated WhatsApp funnel generating high-intent client inquiries.',
      detailedDesc:
          'Designed high-converting video and carousel ads targeting Varanasi and Purvanchal region. Integrated automated WhatsApp chat responses that qualify leads instantly within 60 seconds.',
      techStack: ['Meta Ads Manager', 'WhatsApp API', 'Canva Pro', 'Zapier Automation'],
      liveDemoUrl: '',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&auto=format&fit=crop&q=60',
      keyFeatures: [
        'Geo-targeted radius ads for Varanasi & surrounding cities',
        'Direct WhatsApp click-to-chat funnel',
        'Automated instant message response',
        'Weekly CPL reduction strategy',
      ],
      resultsMetric: '450+ Qualified Leads at ₹18/Lead',
      isFeatured: true,
    ),
    const ProjectModel(
      id: 'p3',
      title: 'Service & Booking Mobile App',
      category: 'App',
      shortDesc: 'Cross-platform Flutter application for booking local services, real-time slots and reviews.',
      detailedDesc:
          'A smooth, responsive Flutter mobile app with dark/light themes, Google Sign-in, slot reservation calendar, push notifications, and customer rating system.',
      techStack: ['Flutter', 'Dart', 'Firebase Auth', 'Cloud Firestore', 'Cloud Functions'],
      liveDemoUrl: 'https://github.com',
      imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&auto=format&fit=crop&q=60',
      keyFeatures: [
        'Interactive slot booking calendar',
        'Push notifications for appointment reminders',
        'Customer reviews & star ratings',
        'User profile and order history',
      ],
      resultsMetric: '4.8 Star Rating & 1.2k+ Users',
      isFeatured: true,
    ),
    const ProjectModel(
      id: 'p4',
      title: 'Local SEO & Google Map Pack Domination',
      category: 'SEO',
      shortDesc: 'Optimized Google Business Profile and local keywords to rank in top 3 Google local results.',
      detailedDesc:
          'Conducted full on-page keyword optimization, technical site speed tuning, Google Map citations, local schema markup, and authentic review acquisition strategy.',
      techStack: ['Google Search Console', 'Google My Business', 'Ahrefs', 'Technical SEO'],
      liveDemoUrl: '',
      imageUrl: 'https://images.unsplash.com/photo-1571786256017-aee7a0c009b6?w=800&auto=format&fit=crop&q=60',
      keyFeatures: [
        'Ranked #1 for local high-intent keyword searches',
        'Google Business Profile 100% verified & optimized',
        '300% boost in direct phone call clicks',
        'Clean metadata and JSON-LD schema',
      ],
      resultsMetric: 'Top 3 Google Rank & 3x Calls',
      isFeatured: false,
    ),
    const ProjectModel(
      id: 'p5',
      title: 'Real Estate & Property Showcase Portal',
      category: 'Website',
      shortDesc: 'Elegant property listing portal with virtual tour embeds, filter by budget and direct agent chat.',
      detailedDesc:
          'High-performance property catalog featuring interactive location maps, image galleries, EMI calculators, and instant WhatsApp inquiry connectors.',
      techStack: ['Next.js', 'React', 'Node.js', 'Google Maps API', 'Vercel'],
      liveDemoUrl: 'https://property-demo.vercel.app',
      imageUrl: 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800&auto=format&fit=crop&q=60',
      keyFeatures: [
        'Location & price range dynamic filtering',
        'Property image galleries with lightbox',
        'Instant WhatsApp chat with property consultant',
        'Mobile-first responsive speed score 95+',
      ],
      resultsMetric: '150+ Direct Property Enquiries',
      isFeatured: false,
    ),
  ];

  // Default Why Work With Me (6 Value Pillars)
  static final List<WhyWorkModel> defaultWhyWorkList = [
    const WhyWorkModel(
      id: 'w1',
      title: 'User-Friendly Solutions',
      subtitleHindi: 'Aasan aur powerful design jo customers ko turant samajh aaye.',
      iconCodePoint: 0xe59c, // Icons.sentiment_very_satisfied_rounded
      colorValue: 0xFF6366F1,
    ),
    const WhyWorkModel(
      id: 'w2',
      title: 'Modern Technology',
      subtitleHindi: 'Latest frameworks (Next.js, Flutter, Firebase) se banayi gayi superfast applications.',
      iconCodePoint: 0xe0e9, // Icons.bolt_rounded
      colorValue: 0xFF38BDF8,
    ),
    const WhyWorkModel(
      id: 'w3',
      title: 'Responsive Design',
      subtitleHindi: 'Mobile, tablet aur desktop har screen size par flawless performance.',
      iconCodePoint: 0xe1e0, // Icons.devices_rounded
      colorValue: 0xFF10B981,
    ),
    const WhyWorkModel(
      id: 'w4',
      title: 'Business-Focused Approach',
      subtitleHindi: 'Sirf show nahi, real sales, leads aur ROI generate karne wala structure.',
      iconCodePoint: 0xe4b6, // Icons.pie_chart_outline_rounded
      colorValue: 0xFFF59E0B,
    ),
    const WhyWorkModel(
      id: 'w5',
      title: 'Fast Communication',
      subtitleHindi: 'Direct call aur WhatsApp support, time par updates aur instant query resolution.',
      iconCodePoint: 0xe3ce, // Icons.mark_chat_read_rounded
      colorValue: 0xFFEC4899,
    ),
    const WhyWorkModel(
      id: 'w6',
      title: 'Customized Solutions',
      subtitleHindi: 'Aapke business aur budget ke mutabik customized tailor-made packages.',
      iconCodePoint: 0xe0b1, // Icons.auto_awesome_rounded
      colorValue: 0xFF8B5CF6,
    ),
  ];
}
