import 'package:flutter/material.dart';

import 'theme.dart';

/// Static sample data for the LMS demo. No backend — everything is in-memory
/// so the demo runs offline.

class LiveClass {
  final String title;
  final String teacher;
  final String time;
  final String subject;
  final bool isLive;
  const LiveClass({
    required this.title,
    required this.teacher,
    required this.time,
    required this.subject,
    this.isLive = false,
  });
}

class Batch {
  final String name;
  final String description;
  final int students;
  final double progress;
  final Color color;
  final IconData icon;
  const Batch({
    required this.name,
    required this.description,
    required this.students,
    required this.progress,
    required this.color,
    required this.icon,
  });
}

class StudyMaterial {
  final String title;
  final String subject;
  final String size;
  final String type; // PDF, DOC, PPT
  const StudyMaterial({
    required this.title,
    required this.subject,
    required this.size,
    required this.type,
  });
}

class VideoLesson {
  final String title;
  final String teacher;
  final String duration;
  final String views;
  final Color thumb;
  const VideoLesson({
    required this.title,
    required this.teacher,
    required this.duration,
    required this.views,
    required this.thumb,
  });
}

class Course {
  final String title;
  final String subtitle;
  final String price;
  final String oldPrice;
  final double rating;
  final int lessons;
  final Color color;
  const Course({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.lessons,
    required this.color,
  });
}

class TestAttempt {
  final String name;
  final String subject;
  final String date;
  final int score;
  final int total;
  final String duration;
  const TestAttempt({
    required this.name,
    required this.subject,
    required this.date,
    required this.score,
    required this.total,
    required this.duration,
  });
}

class Assignment {
  final String title;
  final String subject;
  final String due;
  final AssignmentStatus status;
  const Assignment({
    required this.title,
    required this.subject,
    required this.due,
    required this.status,
  });
}

enum AssignmentStatus { pending, submitted, graded }

class AppNotification {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color color;
  final bool unread;
  const AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.color,
    this.unread = false,
  });
}

class ChatThread {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isGroup;
  final Color color;
  const ChatThread({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.isGroup,
    required this.color,
  });
}

/// ----- Sample collections -----

const sampleLiveClasses = <LiveClass>[
  LiveClass(
    title: 'Polity — Fundamental Rights',
    teacher: 'Anita Sharma',
    time: 'Now • 10:00 AM',
    subject: 'Polity',
    isLive: true,
  ),
  LiveClass(
    title: 'Modern History Revision',
    teacher: 'R. Verma',
    time: '12:30 PM',
    subject: 'History',
  ),
  LiveClass(
    title: 'English Grammar Sprint',
    teacher: 'P. Nair',
    time: '4:00 PM',
    subject: 'English',
  ),
];

const sampleBatches = <Batch>[
  Batch(
    name: 'UPSC Foundation 2026',
    description: 'Full GS + CSAT • Live + Recorded',
    students: 1240,
    progress: 0.62,
    color: LmsColors.primary,
    icon: Icons.school,
  ),
  Batch(
    name: 'SSC CGL Crash Course',
    description: 'Tier 1 + Tier 2 • 90 days',
    students: 860,
    progress: 0.41,
    color: LmsColors.accent,
    icon: Icons.workspace_premium,
  ),
  Batch(
    name: 'Class 12 Humanities',
    description: 'Board + Entrance combo',
    students: 430,
    progress: 0.78,
    color: LmsColors.purple,
    icon: Icons.menu_book,
  ),
];

const sampleMaterials = <StudyMaterial>[
  StudyMaterial(
      title: 'Indian Polity Notes', subject: 'Polity', size: '2.4 MB', type: 'PDF'),
  StudyMaterial(
      title: 'History Timeline Sheet',
      subject: 'History',
      size: '1.1 MB',
      type: 'PDF'),
  StudyMaterial(
      title: 'English Vocabulary 500',
      subject: 'English',
      size: '780 KB',
      type: 'DOC'),
  StudyMaterial(
      title: 'Geography Map Pack', subject: 'Geography', size: '3.8 MB', type: 'PPT'),
  StudyMaterial(
      title: 'Current Affairs — May', subject: 'GK', size: '900 KB', type: 'PDF'),
];

const sampleVideos = <VideoLesson>[
  VideoLesson(
    title: 'Preamble of the Constitution',
    teacher: 'Anita Sharma',
    duration: '18:42',
    views: '12.4k',
    thumb: LmsColors.primary,
  ),
  VideoLesson(
    title: 'Revolt of 1857 explained',
    teacher: 'R. Verma',
    duration: '24:10',
    views: '8.9k',
    thumb: LmsColors.accent,
  ),
  VideoLesson(
    title: 'Tenses made easy',
    teacher: 'P. Nair',
    duration: '15:30',
    views: '21.2k',
    thumb: LmsColors.purple,
  ),
];

const sampleCourses = <Course>[
  Course(
    title: 'Complete UPSC GS',
    subtitle: 'Prelims + Mains foundation',
    price: '₹4,999',
    oldPrice: '₹9,999',
    rating: 4.8,
    lessons: 320,
    color: LmsColors.primary,
  ),
  Course(
    title: 'English for Competitive Exams',
    subtitle: 'Grammar • Comprehension • Vocab',
    price: '₹1,499',
    oldPrice: '₹2,999',
    rating: 4.6,
    lessons: 96,
    color: LmsColors.accent,
  ),
  Course(
    title: 'Humanities All-in-One',
    subtitle: 'Class 11 & 12 complete',
    price: '₹3,499',
    oldPrice: '₹5,999',
    rating: 4.9,
    lessons: 210,
    color: LmsColors.purple,
  ),
];

/// Student Score Trend — values from the reference screenshot (peaks ~170,
/// dips to ~43, recovers to ~160).
const scoreTrend = <double>[100, 172, 60, 43, 68, 90, 102, 120, 160];
const scoreTrendLabels = <String>[
  'May 2',
  'May 6',
  '',
  '',
  '',
  'May 23',
  '',
  '',
  'May 29'
];

/// Subject-wise performance (out of 100).
const subjectScores = <MapEntry<String, double>>[
  MapEntry('English', 88),
  MapEntry('Polity', 72),
  MapEntry('History', 65),
  MapEntry('GK', 80),
  MapEntry('CSAT', 54),
];

const sampleAttempts = <TestAttempt>[
  TestAttempt(
    name: 'English 7',
    subject: 'English',
    date: 'May 29, 10:24 PM',
    score: 161,
    total: 250,
    duration: '33 min',
  ),
  TestAttempt(
    name: 'General Test 6',
    subject: 'General Test',
    date: 'May 27, 2:22 AM',
    score: 119,
    total: 250,
    duration: '49 min',
  ),
  TestAttempt(
    name: 'English 4',
    subject: 'English',
    date: 'May 26, 1:59 AM',
    score: 102,
    total: 250,
    duration: '48 min',
  ),
  TestAttempt(
    name: 'English 5',
    subject: 'English',
    date: 'May 24, 9:10 PM',
    score: 138,
    total: 250,
    duration: '41 min',
  ),
];

const sampleAssignments = <Assignment>[
  Assignment(
    title: 'Essay: Federalism in India',
    subject: 'Polity',
    due: 'Due tomorrow',
    status: AssignmentStatus.pending,
  ),
  Assignment(
    title: 'Map work: River systems',
    subject: 'Geography',
    due: 'Due in 3 days',
    status: AssignmentStatus.pending,
  ),
  Assignment(
    title: 'Comprehension worksheet 4',
    subject: 'English',
    due: 'Submitted May 28',
    status: AssignmentStatus.submitted,
  ),
  Assignment(
    title: 'History MCQ set 2',
    subject: 'History',
    due: 'Graded • 18/20',
    status: AssignmentStatus.graded,
  ),
];

const sampleNotifications = <AppNotification>[
  AppNotification(
    title: 'Live class starting',
    body: 'Polity — Fundamental Rights begins in 10 minutes.',
    time: '2m ago',
    icon: Icons.podcasts,
    color: LmsColors.danger,
    unread: true,
  ),
  AppNotification(
    title: 'Test result published',
    body: 'Your English 7 score: 161/250. Tap to review.',
    time: '1h ago',
    icon: Icons.assignment_turned_in,
    color: LmsColors.primary,
    unread: true,
  ),
  AppNotification(
    title: 'New study material',
    body: 'Current Affairs — May PDF added to your batch.',
    time: '5h ago',
    icon: Icons.picture_as_pdf,
    color: LmsColors.accent,
  ),
  AppNotification(
    title: 'Payment successful',
    body: 'Receipt for UPSC Foundation 2026 is ready.',
    time: 'Yesterday',
    icon: Icons.check_circle,
    color: LmsColors.success,
  ),
];

const sampleChats = <ChatThread>[
  ChatThread(
    name: 'UPSC Foundation 2026',
    lastMessage: 'Anita: Don\'t miss today\'s live at 10!',
    time: '9:42 AM',
    unread: 3,
    isGroup: true,
    color: LmsColors.primary,
  ),
  ChatThread(
    name: 'Anita Sharma (Mentor)',
    lastMessage: 'Great improvement in your last test 👏',
    time: '8:15 AM',
    unread: 1,
    isGroup: false,
    color: LmsColors.accent,
  ),
  ChatThread(
    name: 'Doubts — General Studies',
    lastMessage: 'Rohit: Can someone explain Article 32?',
    time: 'Yesterday',
    unread: 0,
    isGroup: true,
    color: LmsColors.purple,
  ),
  ChatThread(
    name: 'Support Team',
    lastMessage: 'Your query has been resolved.',
    time: 'Mon',
    unread: 0,
    isGroup: false,
    color: LmsColors.warning,
  ),
];
