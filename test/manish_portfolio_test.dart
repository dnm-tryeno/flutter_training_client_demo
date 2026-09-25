import 'package:flutter/material.dart';
import 'package:flutter_application_1/manish/data/cms_storage_service.dart';
import 'package:flutter_application_1/manish/manish_app.dart';
import 'package:flutter_application_1/manish/models/project_model.dart';
import 'package:flutter_application_1/manish/models/service_model.dart';
import 'package:flutter_application_1/manish/models/why_work_model.dart';
import 'package:flutter_application_1/manish/pages/admin_panel_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CmsStorageService Unit Tests', () {
    test('Initializes with default data and models', () async {
      final service = CmsStorageService();
      await service.loadData();

      expect(service.config.name, equals('Manish Maurya'));
      expect(service.services.length, equals(6));
      expect(service.projects.length, equals(5));
      expect(service.whyWorkList.length, equals(6));
    });

    test('Updates config dynamically', () async {
      final service = CmsStorageService();
      await service.loadData();

      final updated = service.config.copyWith(
        name: 'Manish Maurya Pro',
        phone: '9999988888',
        tagline: 'Expert Web & App Solutions',
      );
      await service.updateConfig(updated);

      expect(service.config.name, equals('Manish Maurya Pro'));
      expect(service.config.phone, equals('9999988888'));
    });

    test('Services CRUD works properly', () async {
      final service = CmsStorageService();
      await service.loadData();

      const newService = ServiceModel(
        id: 'new_service_1',
        titleHindi: 'Cloud Architecture',
        titleEnglish: 'AWS & Cloud Hosting',
        shortDesc: 'Scalable cloud deployment',
        detailedDesc: 'High availability systems',
        iconCodePoint: 0xe133,
        accentColorValue: 0xFF10B981,
        subOfferings: ['AWS Setup', 'Docker'],
        benefits: ['99.9% Uptime'],
      );

      await service.addService(newService);
      expect(service.services.any((s) => s.id == 'new_service_1'), isTrue);

      final updatedService = newService.copyWith(titleHindi: 'Cloud Architecture 2.0');
      await service.updateService(updatedService);
      expect(service.services.firstWhere((s) => s.id == 'new_service_1').titleHindi, equals('Cloud Architecture 2.0'));

      await service.deleteService('new_service_1');
      expect(service.services.any((s) => s.id == 'new_service_1'), isFalse);
    });

    test('Projects CRUD works properly', () async {
      final service = CmsStorageService();
      await service.loadData();

      const newProj = ProjectModel(
        id: 'new_proj_1',
        title: 'Fintech Dashboard',
        category: 'Website',
        shortDesc: 'Trading and wallet dashboard',
        detailedDesc: 'Full featured real-time fintech web app',
        techStack: ['Flutter', 'Node.js'],
        imageUrl: '',
      );

      await service.addProject(newProj);
      expect(service.projects.any((p) => p.id == 'new_proj_1'), isTrue);

      final updatedProj = newProj.copyWith(title: 'Fintech Dashboard Ultra');
      await service.updateProject(updatedProj);
      expect(service.projects.firstWhere((p) => p.id == 'new_proj_1').title, equals('Fintech Dashboard Ultra'));

      await service.deleteProject('new_proj_1');
      expect(service.projects.any((p) => p.id == 'new_proj_1'), isFalse);
    });

    test('WhyWork CRUD works properly', () async {
      final service = CmsStorageService();
      await service.loadData();

      const newPillar = WhyWorkModel(
        id: 'new_pillar_1',
        title: 'Guaranteed ROI',
        subtitleHindi: '100% Results oriented',
        iconCodePoint: 0xe0b1,
        colorValue: 0xFF10B981,
      );

      await service.addWhyWorkItem(newPillar);
      expect(service.whyWorkList.any((w) => w.id == 'new_pillar_1'), isTrue);

      await service.deleteWhyWorkItem('new_pillar_1');
      expect(service.whyWorkList.any((w) => w.id == 'new_pillar_1'), isFalse);
    });

    test('JSON Export and Import works properly', () async {
      final service = CmsStorageService();
      await service.loadData();

      final jsonBackup = service.exportAllDataAsJson();
      expect(jsonBackup.contains('Manish Maurya'), isTrue);

      final service2 = CmsStorageService();
      final success = await service2.importDataFromJson(jsonBackup);
      expect(success, isTrue);
      expect(service2.config.name, equals('Manish Maurya'));
    });
  });

  group('Widget Tests', () {
    testWidgets('ManishApp loads portfolio page with key elements', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const ManishApp());
      await tester.pumpAndSettle();

      expect(find.text('Manish Maurya'), findsWidgets);
      expect(find.text('My Services'), findsWidgets);
      expect(find.text('My Projects'), findsWidgets);
      expect(find.text('Contact Me'), findsWidgets);
    });

    testWidgets('AdminPanelPage opens and shows tabs', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final service = CmsStorageService();
      await service.loadData();

      await tester.pumpWidget(
        MaterialApp(
          home: AdminPanelPage(cmsService: service),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Master Admin Panel (100% Customizable)'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Profile & Hero'), findsOneWidget);
      expect(find.text('Services Manager'), findsOneWidget);
      expect(find.text('Projects Showcase'), findsOneWidget);
    });
  });
}
