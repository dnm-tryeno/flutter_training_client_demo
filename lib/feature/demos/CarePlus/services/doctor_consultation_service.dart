class DoctorProfile {
  final String id;
  final String name;
  final String specialty;
  final String qualification;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final String clinicHospital;
  final String consultationFee;
  final String availableTime;
  final String avatarInitials;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.clinicHospital,
    required this.consultationFee,
    required this.availableTime,
    required this.avatarInitials,
  });
}

class DoctorConsultationService {
  static final List<DoctorProfile> verifiedDoctors = [
    const DoctorProfile(
      id: 'doc-1',
      name: 'Dr. Ananya Sharma',
      specialty: 'General Physician & Family Medicine',
      qualification: 'MBBS, MD (Internal Medicine)',
      experienceYears: 14,
      rating: 4.9,
      reviewCount: 320,
      clinicHospital: 'City Health Clinic, Metro Hospital',
      consultationFee: '₹500',
      availableTime: 'Today, 4:00 PM – 7:30 PM',
      avatarInitials: 'AS',
    ),
    const DoctorProfile(
      id: 'doc-2',
      name: 'Dr. Vikramaditya Rao',
      specialty: 'Gastroenterologist',
      qualification: 'MBBS, MD, DM (Gastroenterology)',
      experienceYears: 18,
      rating: 4.8,
      reviewCount: 240,
      clinicHospital: 'Digestive & Liver Care Center',
      consultationFee: '₹800',
      availableTime: 'Tomorrow, 10:00 AM – 2:00 PM',
      avatarInitials: 'VR',
    ),
    const DoctorProfile(
      id: 'doc-3',
      name: 'Dr. Priya Nambiar',
      specialty: 'Orthopedic & Spine Specialist',
      qualification: 'MBBS, MS (Orthopedics), Fellowship Spine',
      experienceYears: 12,
      rating: 4.9,
      reviewCount: 195,
      clinicHospital: 'Apollo Ortho & Spine Hospital',
      consultationFee: '₹750',
      availableTime: 'Today, 6:00 PM – 9:00 PM',
      avatarInitials: 'PN',
    ),
    const DoctorProfile(
      id: 'doc-4',
      name: 'Dr. Rajesh Deshmukh',
      specialty: 'Cardiologist',
      qualification: 'MBBS, MD, DM (Cardiology), FACC',
      experienceYears: 22,
      rating: 4.9,
      reviewCount: 510,
      clinicHospital: 'Heart & Vascular Institute',
      consultationFee: '₹1,000',
      availableTime: 'Mon - Fri, 9:00 AM – 1:00 PM',
      avatarInitials: 'RD',
    ),
    const DoctorProfile(
      id: 'doc-5',
      name: 'Dr. Sunita Sen',
      specialty: 'Obstetrician & Gynecologist',
      qualification: 'MBBS, MS (OBG), DNB',
      experienceYears: 16,
      rating: 4.9,
      reviewCount: 380,
      clinicHospital: 'Mother & Child Wellness Care',
      consultationFee: '₹700',
      availableTime: 'Today, 2:00 PM – 6:00 PM',
      avatarInitials: 'SS',
    ),
    const DoctorProfile(
      id: 'doc-6',
      name: 'Dr. Tariq Siddiqui',
      specialty: 'Clinical Nutritionist & Dietitian',
      qualification: 'M.Sc (Clinical Nutrition), RD, CDE',
      experienceYears: 10,
      rating: 4.8,
      reviewCount: 140,
      clinicHospital: 'Lifestyle Nutrition & Wellness Clinic',
      consultationFee: '₹450',
      availableTime: 'Today, 11:00 AM – 5:00 PM',
      avatarInitials: 'TS',
    ),
  ];

  static List<DoctorProfile> getDoctorsForSpecialty(String specialty) {
    final lower = specialty.toLowerCase();
    final matched = verifiedDoctors.where((d) => d.specialty.toLowerCase().contains(lower)).toList();
    if (matched.isNotEmpty) return matched;
    return verifiedDoctors;
  }
}
