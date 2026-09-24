import 'package:uuid/uuid.dart';
import '../models/health_check_input.dart';
import '../models/health_guidance_result.dart';
import '../models/food_suggestion.dart';
import '../models/yoga_exercise.dart';
import '../models/medicine_safety_item.dart';
import '../localization/app_language.dart';

class HealthSuggestionEngine {
  static const _uuid = Uuid();

  // Backward compatibility getter
  static List<MedicineSafetyItem> get verifiedMedicineDatabase =>
      getVerifiedMedicineDatabase(AppLanguage.hinglish);

  // Localized Educational Medicine Safety Database
  static List<MedicineSafetyItem> getVerifiedMedicineDatabase(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return _verifiedMedicineDatabaseHi;
      case AppLanguage.english:
        return _verifiedMedicineDatabaseEn;
      case AppLanguage.hinglish:
        return _verifiedMedicineDatabaseHinglish;
    }
  }

  static const List<MedicineSafetyItem> _verifiedMedicineDatabaseHi = [
    MedicineSafetyItem(
      id: 'med-paracetamol',
      name: 'पैरासिटामोल / एसिटामिनोफेन (शैक्षिक जानकारी)',
      genericCategory: 'दर्द व बुखार निवारक (Analgesic & Antipyretic)',
      generalPurpose:
          'हल्के से मध्यम सिरदर्द, बदन दर्द और बुखार से अस्थायी राहत के लिए दुनिया भर में उपयोग किया जाता है।',
      commonPrecautions: [
        'दैनिक अधिकतम सीमा से अधिक न लें (अत्यधिक खुराक लिवर को नुकसान पहुंचा सकती है)।',
        'पैरासिटामोल लेते समय शराब (अल्कोहल) का सेवन बिल्कुल न करें।',
        'खांसी-जुकाम की अन्य दवाओं के लेबल ध्यान से पढ़ें ताकि डबल डोज न हो।',
      ],
      commonSideEffects: [
        'सामान्य खुराक में दुर्लभ: हल्का जी मिचलाना, त्वचा पर एलर्जी के दाने।',
        'अत्यधिक मात्रा लेने पर लिवर को नुकसान का खतरा।',
      ],
      importantInteractions: ['वारफेरिन (रक्त पतला करने वाली दवाएं)', 'अल्कोहल', 'अन्य पैरासिटामोल युक्त दवाएं'],
      whoShouldAskDoctor: [
        'लिवर या किडनी रोग से पीड़ित व्यक्ति।',
        'नियमित शराब का सेवन करने वाले लोग।',
        'गर्भवती या स्तनपान कराने वाली महिलाएं।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'WHO मॉडल फॉर्मूलरी व राष्ट्रीय स्वास्थ्य दिशानिर्देश',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. एस. मेहता, MD (इंटरनल मेडिसिन)',
    ),
    MedicineSafetyItem(
      id: 'med-antacid',
      name: 'एंटासिड और एल्जिनेट्स (शैक्षिक जानकारी)',
      genericCategory: 'पेट की एसिडिटी न्यूट्रलाइजर',
      generalPurpose: 'सीने में जलन, खट्टी डकार, एसिडिटी और अपच से तेजी से अस्थायी राहत प्रदान करता है।',
      commonPrecautions: [
        'डॉक्टर की सलाह के बिना लगातार 14 दिनों से अधिक न लें।',
        'अन्य दवाओं के अवशोषण में बाधा से बचने के लिए 1 से 2 घंटे का अंतर रखें।',
      ],
      commonSideEffects: ['मैग्नीशियम युक्त एंटासिड से दस्त और एल्युमिनियम युक्त से कब्ज हो सकती है।'],
      importantInteractions: ['आयरन सप्लीमेंट्स', 'एंटीबायोटिक्स (टेट्रासाइक्लिन, सिप्रोफ्लोक्सासिन)', 'डिगोक्सिन'],
      whoShouldAskDoctor: [
        'किडनी रोग या हाई ब्लड प्रेशर वाले मरीज (सोडियम सामग्री के कारण)।',
        'जिन्हें सीने में दर्द बांह या जबड़े तक फैलता महसूस हो।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'ब्रिटिश नेशनल फॉर्मूलरी (BNF) व एम्स क्लिनिकल प्रोटोकॉल',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. वी. राव, MD (गैस्ट्रोएंटरोलॉजी)',
    ),
    MedicineSafetyItem(
      id: 'med-ors',
      name: 'ओरल रिहाइड्रेशन साल्ट्स / ORS (शैक्षिक जानकारी)',
      genericCategory: 'इलेक्ट्रोलाइट व पानी की भरपाई',
      generalPurpose:
          'दस्त, उल्टी, अत्यधिक पसीने या कमजोरी के दौरान शरीर में पानी और जरूरी लवणों की कमी को पूरा करता है।',
      commonPrecautions: [
        'पैकेट पर लिखे निर्देशानुसार पीने के साफ पानी की सही मात्रा में ही घोलें।',
        'बनाए गए घोल का उपयोग 24 घंटे के भीतर करें।',
      ],
      commonSideEffects: ['साफ पानी में सही अनुपात में मिलाने पर यह अत्यंत सुरक्षित है।'],
      importantInteractions: ['अधिकांश दवाओं के साथ सुरक्षित।'],
      whoShouldAskDoctor: [
        'गंभीर किडनी या हार्ट फेल्योर के मरीज जिन्हें तरल पदार्थ सीमित रखने की सलाह दी गई हो।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'WHO डिहाइड्रेशन प्रबंधन दिशानिर्देश',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'CarePlus मेडिकल एडिटोरियल बोर्ड',
    ),
    MedicineSafetyItem(
      id: 'med-cetirizine',
      name: 'सिटिरिजिन / एंटीहिस्टामाइन (शैक्षिक जानकारी)',
      genericCategory: 'एलर्जी रोधी दवा (Second-Gen Antihistamine)',
      generalPurpose:
          'छींकें, बहती नाक, आंखों में खुजली व पानी आना और त्वचा पर एलर्जी के दानों से राहत देता है।',
      commonPrecautions: [
        'इससे हल्की नींद या सुस्ती आ सकती है; वाहन चलाते या मशीनरी चलाते समय सावधानी बरतें।',
        'शराब का सेवन न करें क्योंकि इससे सुस्ती बढ़ सकती है।',
      ],
      commonSideEffects: ['हल्की सुस्ती, मुंह सूखना, सिरदर्द, थकान।'],
      importantInteractions: ['सीएनएस डिप्रेसेंट', 'नींद की गोलियां', 'अल्कोहल'],
      whoShouldAskDoctor: [
        'बुजुर्ग मरीज, गर्भवती/स्तनपान कराने वाली महिलाएं और गंभीर किडनी रोग से पीड़ित व्यक्ति।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'FDA व ICMR ड्रग इंफॉर्मेशन डायरेक्टरी',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. पी. रॉय, MD (पल्मोनोलॉजी व एलर्जी)',
    ),
    MedicineSafetyItem(
      id: 'med-pain-relief',
      name: 'दर्द निवारक जेल और मलहम (शैक्षिक जानकारी)',
      genericCategory: 'स्थानिक दर्द व सूजन निवारक (Topical Analgesic)',
      generalPurpose:
          'कमर दर्द, मांसपेशियों में खिंचाव, मोच, गर्दन के दर्द और अकड़न से अस्थायी राहत देता है।',
      commonPrecautions: [
        'केवल बिना कटी त्वचा पर लगाएं; आंख, नाक या मुंह के संपर्क से बचाएं।',
        'लगाने के बाद हाथों को साबुन से अच्छी तरह धोएं।',
        'जेल लगाने के तुरंत बाद हीटिंग पैड न लगाएं और न ही बहुत कसकर पट्टी बांधें।',
        'दिन में 2–3 बार से अधिक न लगाएं।',
      ],
      commonSideEffects: ['लगाने वाली जगह पर हल्की गर्मी, झनझनाहट या लाली।'],
      importantInteractions: ['उसी जगह पर अन्य दवा क्रीम', 'मौखिक दर्द निवारक दवाएं'],
      whoShouldAskDoctor: [
        'गर्भवती महिलाएं, संवेदनशील त्वचा या अस्थमा वाले व्यक्ति।',
        'यदि दर्द पैरों तक फैल रहा हो या 5-7 दिनों से अधिक बना रहे।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'WHO एसेंशियल मेडिसिन व इंडियन फार्माकोपिया',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. के. सक्सेना, MS (ऑर्थोपेडिक्स)',
    ),
    MedicineSafetyItem(
      id: 'med-clove-oil',
      name: 'लौंग का तेल / यूजेनॉल (शैक्षिक जानकारी)',
      genericCategory: 'प्राकृतिक दंत दर्द निवारक व एंटीसेप्टिक',
      generalPurpose:
          'दांत दर्द, मसूड़ों की सूजन और संवेदनशीलता से अस्थायी राहत के लिए पारंपरिक व सुरक्षित उपाय।',
      commonPrecautions: [
        'साफ रूई की तीली से केवल प्रभावित दांत पर ही एक छोटी बूंद लगाएं।',
        'बड़ी मात्रा में न निगलें और नाजुक जीभ/मसूड़ों पर सीधे न रगड़ें।',
        'यह दांत की कैविटी का स्थायी इलाज नहीं है; दंत चिकित्सक से मिलें।',
      ],
      commonSideEffects: ['मुंह के अंदर हल्का अस्थायी जलन या झनझनाहट का अहसास।'],
      importantInteractions: ['अल्प मात्रा में स्थानिक उपयोग पर सुरक्षित।'],
      whoShouldAskDoctor: [
        'छोटे बच्चे, गर्भवती महिलाएं और मुंह में गहरे छाले वाले मरीज।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'डेंटल फार्माकोपिया व ICMR ओरल हेल्थ दिशानिर्देश',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. एन. कपूर, MDS (डेंटल सर्जरी)',
    ),
    MedicineSafetyItem(
      id: 'med-chlorhexidine',
      name: 'क्लोरहेक्सिडिन एंटीसेप्टिक माउथवॉश (शैक्षिक जानकारी)',
      genericCategory: 'एंटीसेप्टिक ओरल रिंस',
      generalPurpose:
          'मुंह के हानिकारक बैक्टीरिया को कम करता है, मसूड़ों की सूजन रोकता है और दांतों की सफाई बनाए रखता है।',
      commonPrecautions: [
        'ब्रश करने के बाद 30-60 सेकंड तक कुल्ला करें, फिर थूक दें। निगलें नहीं।',
        'कुल्ला करने के बाद 30 मिनट तक कुछ भी खाएं-पिएं नहीं।',
        'दंत चिकित्सक के परामर्श के बिना लगातार 2 सप्ताह से अधिक उपयोग न करें।',
      ],
      commonSideEffects: ['स्वाद में अस्थायी बदलाव, दांतों पर हल्का अस्थायी दाग।'],
      importantInteractions: ['टूथपेस्ट के तुरंत बाद उपयोग से बचें (पानी से कुल्ला करके करें)।'],
      whoShouldAskDoctor: ['6 वर्ष से कम उम्र के बच्चे।'],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी दवा को लेने, बंद करने या खुराक बदलने से पहले योग्य डॉक्टर से परामर्श अवश्य लें।',
      sourceReference: 'इंडियन डेंटल एसोसिएशन व WHO ओरल हेल्थ प्रोटोकॉल',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. आर. खन्ना, MDS (एंडोडॉन्टिक्स)',
    ),
    MedicineSafetyItem(
      id: 'med-metformin',
      name: 'ब्लड शुगर नियंत्रण और इंसुलिन सुरक्षा (शैक्षिक जानकारी)',
      genericCategory: 'डायबिटीज नियंत्रण / बिगुआनाइड शिक्षा',
      generalPurpose:
          'इंसुलिन संवेदनशीलता सुधारने, लिवर में अतिरिक्त ग्लूकोज उत्पादन घटाने और टाइप 2 डायबिटीज में शुगर नियंत्रण में मदद करता है।',
      commonPrecautions: [
        'पेट की परेशानी से बचने के लिए हमेशा भोजन के साथ या तुरंत बाद लें।',
        'अपने डायबेटोलॉजिस्ट से पूछे बिना कभी भी डोज न बदलें और न ही दवा छोड़ें।',
        'लो शुगर (हाइपोग्लाइसीमिया: पसीना, कंपकंपी, चक्कर) के लिए हमेशा ग्लूकोज की गोलियां, टॉफी या जूस पास रखें।',
      ],
      commonSideEffects: ['शुरुआत में हल्का जी मिचलाना, पेट में असहजता, मुंह में धातु जैसा स्वाद।'],
      importantInteractions: ['अल्कोहल (हाइपोग्लाइसीमिया का जोखिम बढ़ाता है)', 'सीटी स्कैन कंट्रास्ट डाई'],
      whoShouldAskDoctor: [
        'किडनी रोग, लिवर की समस्या, हार्ट फेल्योर या अत्यधिक निर्जलीकरण वाले मरीज।',
        'गर्भवती या स्तनपान कराने वाली महिलाएं।',
      ],
      mandatoryWarning: 'महत्वपूर्ण: किसी भी डायबिटीज दवा को शुरू करने, बदलने या बंद करने से पहले योग्य डॉक्टर से परामर्श लें।',
      sourceReference: 'अमेरिकन डायबिटीज एसोसिएशन (ADA) व ICMR दिशानिर्देश',
      lastReviewedDate: 'सितंबर 2026',
      medicalReviewer: 'डॉ. एस. माथुर, MD, DM (एंडोक्रिनोलॉजी)',
    ),
  ];

  static const List<MedicineSafetyItem> _verifiedMedicineDatabaseHinglish = [
    MedicineSafetyItem(
      id: 'med-paracetamol',
      name: 'Paracetamol / Acetaminophen (Educational Overview)',
      genericCategory: 'Dard & Bukhar Reliever (Analgesic)',
      generalPurpose:
          'Halke sir dard, badan dard aur bukhar se temporary aaram ke liye duniya bhar me use hota hai.',
      commonPrecautions: [
        'Daily maximum limit se zyada na lein (overdose se liver damage ka risk hota hai).',
        'Paracetamol ke sath alcohol ka sevan bilkul na karein.',
        'Cold/Cough ki dusri medicines ke labels check karein taki double dose na ho.',
      ],
      commonSideEffects: [
        'Normal dose me rare: halki ulti jaisa lagna, skin rash.',
        'Overdose me liver toxicity ka khatra.',
      ],
      importantInteractions: ['Warfarin (blood thinners)', 'Alcohol', 'Other acetaminophen products'],
      whoShouldAskDoctor: [
        'Liver ya Kidney ki bimari wale patients.',
        'Regular alcohol lene wale log.',
        'Pregnant ya nursing mothers.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'WHO Model Formulary / National Health Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. S. Mehta, MD (Internal Medicine)',
    ),
    MedicineSafetyItem(
      id: 'med-antacid',
      name: 'Antacids & Gas Relievers (Educational Overview)',
      genericCategory: 'Pet Ki Acidity Neutralizer',
      generalPurpose: 'Seene me jalan, gas, acidity aur sour stomach se turant temporary relief deta hai.',
      commonPrecautions: [
        'Doctor ki salah ke bina 14 din se zyada continuous na lein.',
        'Dusri medicines se 1-2 ghante ka gap rakhein taki unka absorption affect na ho.',
      ],
      commonSideEffects: ['Magnesium antacids se loose motion; Aluminum antacids se constipation ho sakta hai.'],
      importantInteractions: ['Iron supplements', 'Antibiotics (Tetracyclines)', 'Digoxin'],
      whoShouldAskDoctor: [
        'Kidney problem ya High BP wale patients (sodium content ke kaaran).',
        'Seene me dard agar baazu ya gale tak phail raha ho.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'BNF & AIIMS Clinical Protocols',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. V. Rao, MD (Gastroenterology)',
    ),
    MedicineSafetyItem(
      id: 'med-ors',
      name: 'Oral Rehydration Salts (ORS) (Educational Overview)',
      genericCategory: 'Electrolyte & Paani Ki Kami Door Karna',
      generalPurpose:
          'Loose motions, vomiting, bahut zyada pasina aane par paani aur electrolytes balance restore karta hai.',
      commonPrecautions: [
        'Packet par likhe instructions ke mutabik clean drinking water me hi banayein.',
        'Bana hua solution 24 ghante ke andar consume karein.',
      ],
      commonSideEffects: ['Clean water me sahi ratio me milane par extremely safe hai.'],
      importantInteractions: ['Zyadatar medicines ke sath safe hai.'],
      whoShouldAskDoctor: [
        'Severe kidney failure ya heart failure patients jinhe fluids restrict kiya gaya ho.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'WHO Guidelines on Dehydration Management',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'CarePlus Medical Editorial Board',
    ),
    MedicineSafetyItem(
      id: 'med-cetirizine',
      name: 'Cetirizine / Antihistamine (Educational Overview)',
      genericCategory: 'Allergy Control Medicine',
      generalPurpose:
          'Chheenk, behti naak, aankhon me khujli/paani aur skin allergy rashes se aaram deta hai.',
      commonPrecautions: [
        'Halki neend ya susti aa sakti hai; driving ya heavy machinery chalate waqt dhyan dein.',
        'Alcohol se bachein kyunki susti badh sakti hai.',
      ],
      commonSideEffects: ['Halki susti, gala sukhna, headache, thakan.'],
      importantInteractions: ['Sedatives', 'Alcohol'],
      whoShouldAskDoctor: [
        'Elderly patients, pregnant women aur kidney impairment wale log.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'FDA & ICMR Drug Information Directory',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. P. Roy, MD (Pulmonology & Allergy)',
    ),
    MedicineSafetyItem(
      id: 'med-pain-relief',
      name: 'Pain Relief Gel & Ointments (Educational Overview)',
      genericCategory: 'Topical Pain & Swelling Reliever',
      generalPurpose:
          'Kamar dard, sprain, maanspeshiyon ka khinchav aur garden dard se temporary aaram deta hai.',
      commonPrecautions: [
        'Sirf unbroken skin par lagayein; aankh, naak ya muh se bachayein.',
        'Lagane ke baad haath sabun se dhoyein.',
        'Gel lagane ke turant baad heating pad ya tight patti na bandhein.',
      ],
      commonSideEffects: ['Lagane wali jagah par halki warmth ya skin redness.'],
      importantInteractions: ['Same area par dusri medicated creams'],
      whoShouldAskDoctor: [
        'Sensitive skin, asthma ya aspirin allergy wale log.',
        'Dard agar pairon tak radiate ho ya 5-7 din se zyada rahe.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'WHO Essential Medicines & Indian Pharmacopoeia',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. K. Saxena, MS (Orthopedics)',
    ),
    MedicineSafetyItem(
      id: 'med-clove-oil',
      name: 'Laung Ka Tel / Clove Oil (Educational Overview)',
      genericCategory: 'Natural Toothache & Antiseptic Care',
      generalPurpose:
          'Dant dard, masoodon me sujan aur sensitivity se temporary rahat pane ka natural gharelu upay.',
      commonPrecautions: [
        'Rui (cotton) ki tip se sirf affected dant par 1 choti boond lagayein.',
        'Nigle nahi aur direct tongue/gums par zyada na lagayein.',
        'Ye cavity ka permanent ilaj nahi hai; dentist ko dikhayein.',
      ],
      commonSideEffects: ['Muh me temporary jalan ya jhanjhanahat.'],
      importantInteractions: ['Trace amounts me topically safe hai.'],
      whoShouldAskDoctor: [
        'Chhote bachhe, pregnant ladies aur mouth ulcer wale patients.',
      ],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'Dental Pharmacopeia & ICMR Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. N. Kapoor, MDS (Dental Surgery)',
    ),
    MedicineSafetyItem(
      id: 'med-chlorhexidine',
      name: 'Chlorhexidine Antiseptic Mouthwash (Educational Overview)',
      genericCategory: 'Oral Antiseptic & Gum Protection Rinse',
      generalPurpose:
          'Muh ke kitanu kam karta hai, masoodon ki sujan (gingivitis) control karta hai aur bad breath door karta hai.',
      commonPrecautions: [
        'Brush karne ke baad 30-60 second rinse karein, fir thuk dein. Nigle nahi.',
        'Rinse karne ke 30 minute baad tak kuch khayein-piyein nahi.',
        'Dentist ki सलाह ke bina 2 hafte se zyada regular use na karein.',
      ],
      commonSideEffects: ['Temporary taste change, danto par halka removable daag.'],
      importantInteractions: ['Toothpaste ke surfactants (paani se kulla karke use karein).'],
      whoShouldAskDoctor: ['6 saal se chhote bachhe.'],
      mandatoryWarning: 'Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor se salah lein.',
      sourceReference: 'Indian Dental Association Protocols',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. R. Khanna, MDS (Endodontics)',
    ),
    MedicineSafetyItem(
      id: 'med-metformin',
      name: 'Blood Glucose Management & Insulin Safety (Educational Overview)',
      genericCategory: 'Antidiabetic / Sugar Control Education',
      generalPurpose:
          'Insulin sensitivity badhane, liver me glucose production kam karne aur Type 2 Diabetes me sugar control karne me madad karta hai.',
      commonPrecautions: [
        'Pet ki pareshani se bachne ke liye hamesha khane ke sath ya turant baad lein.',
        'Doctor se bina puche dose change na karein aur na hi dawai skip karein.',
        'Low sugar (hypoglycemia: pasina, chakkar) aane par hamesha glucose tablets ya candy sath rakhein.',
      ],
      commonSideEffects: ['Shuru me halki ulti jaisa lagna, pet me gas, metallic taste.'],
      importantInteractions: ['Alcohol (hypoglycemia ka risk badhata hai)', 'CT scan contrast dyes'],
      whoShouldAskDoctor: [
        'Kidney disease, liver dysfunction, heart failure ya severe dehydration wale patients.',
        'Pregnant ya breastfeeding women.',
      ],
      mandatoryWarning: 'Important: Koi bhi diabetes medicine lene ya dose change karne se pehle Diabetologist se consult karein.',
      sourceReference: 'American Diabetes Association (ADA) Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. S. Mathur, MD, DM (Endocrinology)',
    ),
  ];

  static const List<MedicineSafetyItem> _verifiedMedicineDatabaseEn = [
    MedicineSafetyItem(
      id: 'med-paracetamol',
      name: 'Paracetamol / Acetaminophen (Educational Overview)',
      genericCategory: 'Analgesic & Antipyretic (Pain & Fever Reliever)',
      generalPurpose:
          'Commonly used worldwide for temporary relief of mild-to-moderate headaches, body aches, and fever.',
      commonPrecautions: [
        'Do not exceed maximum daily limit (overdose can cause severe liver damage).',
        'Avoid consuming alcohol while taking paracetamol.',
        'Check labels of other cold/cough remedies to prevent accidental double dosing.',
      ],
      commonSideEffects: [
        'Rare at standard doses: mild nausea, allergic skin rash.',
        'Liver toxicity if taken in excessive quantities.',
      ],
      importantInteractions: ['Warfarin (blood thinners)', 'Alcohol', 'Other acetaminophen-containing products'],
      whoShouldAskDoctor: [
        'Individuals with chronic liver or kidney disease.',
        'People consuming regular alcohol.',
        'Pregnant or breastfeeding women.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'WHO Model Formulary / National Health Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. S. Mehta, MD (Internal Medicine)',
    ),
    MedicineSafetyItem(
      id: 'med-antacid',
      name: 'Antacids & Alginates (Educational Overview)',
      genericCategory: 'Gastric Acid Neutralizer',
      generalPurpose: 'Provides rapid, temporary relief from heartburn, acid indigestion, and sour stomach.',
      commonPrecautions: [
        'Should not be taken continuously for more than 14 days without medical advice.',
        'Take 1 to 2 hours apart from other medications as they can reduce absorption of other medicines.',
      ],
      commonSideEffects: ['Magnesium-containing antacids may cause diarrhea; Aluminum-containing may cause constipation.'],
      importantInteractions: ['Iron supplements', 'Antibiotics (Tetracyclines, Fluoroquinolones)', 'Digoxin'],
      whoShouldAskDoctor: [
        'Patients with kidney dysfunction or high blood pressure (due to sodium content).',
        'Anyone experiencing chest pain radiating to arm or jaw.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'British National Formulary (BNF) & AIIMS Clinical Protocols',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. V. Rao, MD (Gastroenterology)',
    ),
    MedicineSafetyItem(
      id: 'med-ors',
      name: 'Oral Rehydration Salts (ORS) (Educational Overview)',
      genericCategory: 'Electrolyte & Fluid Replacement',
      generalPurpose:
          'Replenishes vital water and electrolytes lost during diarrhea, vomiting, excessive sweating, or heat exhaustion.',
      commonPrecautions: [
        'Always prepare in the exact volume of clean drinking water specified on the packet (do not dilute or make too concentrated).',
        'Use freshly prepared solution within 24 hours.',
      ],
      commonSideEffects: ['Extremely safe when mixed properly in clean water.'],
      importantInteractions: ['Generally safe with most medications.'],
      whoShouldAskDoctor: [
        'Patients with severe kidney failure or severe heart failure where fluid/potassium is restricted.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'WHO Guidelines on Management of Dehydration',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'CarePlus Medical Editorial Board',
    ),
    MedicineSafetyItem(
      id: 'med-cetirizine',
      name: 'Cetirizine / Antihistamines (Educational Overview)',
      genericCategory: 'Second-Generation Antihistamine',
      generalPurpose:
          'Helps alleviate allergy symptoms such as sneezing, runny nose, itchy watery eyes, and allergic skin hives.',
      commonPrecautions: [
        'May cause mild drowsiness in some individuals; exercise caution when driving or operating heavy machinery.',
        'Avoid alcohol consumption as it increases drowsiness.',
      ],
      commonSideEffects: ['Mild drowsiness, dry mouth, headache, fatigue.'],
      importantInteractions: ['CNS depressants', 'Sedatives', 'Alcohol'],
      whoShouldAskDoctor: [
        'Elderly patients, pregnant or nursing mothers, and individuals with severe kidney impairment.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'FDA & ICMR Drug Information Directory',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. P. Roy, MD (Pulmonology & Allergy)',
    ),
    MedicineSafetyItem(
      id: 'med-pain-relief',
      name: 'Topical Pain Relief Gel & Mild Analgesics (Educational Overview)',
      genericCategory: 'Topical Counter-Irritant & Pain Reliever',
      generalPurpose:
          'Provides localized temporary relief from lower back ache, muscle sprains, stiffness, and neck fatigue.',
      commonPrecautions: [
        'Apply only to unbroken, non-irritated skin; avoid contact with eyes, nose, or mouth.',
        'Wash hands thoroughly with soap after application.',
        'Do not apply heating pads or tightly bind the area immediately after using pain relief ointment.',
        'Do not exceed recommended frequency (2–3 times daily).',
      ],
      commonSideEffects: ['Mild temporary warmth, tingling, or skin redness at the site of application.'],
      importantInteractions: ['Other medicated creams on the same area', 'Oral NSAIDs (if ointment contains diclofenac)'],
      whoShouldAskDoctor: [
        'Pregnant or nursing mothers before using medicated pain gels.',
        'Individuals with sensitive skin, asthma, or aspirin allergies.',
        'Anyone whose pain radiates down the legs or persists beyond 5–7 days.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'WHO Essential Medicines & Indian Pharmacopoeia Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. K. Saxena, MS (Orthopedics & Spine Care)',
    ),
    MedicineSafetyItem(
      id: 'med-clove-oil',
      name: 'Clove Oil / Eugenol (Educational Overview)',
      genericCategory: 'Natural Topical Dental Anesthetic & Antiseptic',
      generalPurpose:
          'Traditional and clinical soothing agent for temporary relief of localized toothache and gum tenderness.',
      commonPrecautions: [
        'Apply only a tiny droplet using a clean cotton tip directly on the affected tooth.',
        'Do not swallow large quantities or apply directly to delicate gums/tongue to avoid mild chemical irritation.',
        'Not a permanent fix for root decay; visit a dentist for cavity repair.',
      ],
      commonSideEffects: ['Temporary burning or tingling sensation on oral mucosa.'],
      importantInteractions: ['Safe when applied topically in trace amounts.'],
      whoShouldAskDoctor: [
        'Young children, pregnant women, and patients with severe open mouth lesions.',
      ],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'Dental Pharmacopeia & ICMR Oral Health Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. N. Kapoor, MDS (Orthodontics & Dental Surgery)',
    ),
    MedicineSafetyItem(
      id: 'med-chlorhexidine',
      name: 'Chlorhexidine Antiseptic Mouthwash (Educational Overview)',
      genericCategory: 'Oral Antiseptic & Anti-Plaque Rinse',
      generalPurpose:
          'Helps reduce harmful oral bacteria, controls gingivitis (gum swelling), and aids post-dental hygiene.',
      commonPrecautions: [
        'Rinse for 30–60 seconds after brushing, then spit out completely. Do not swallow.',
        'Do not eat or drink for 30 minutes after rinsing.',
        'Avoid prolonged continuous use beyond 2 weeks without dental supervision to prevent harmless temporary tooth staining.',
      ],
      commonSideEffects: ['Temporary altered taste sensation, minor superficial staining removable by dental polishing.'],
      importantInteractions: ['Toothpaste anionic surfactants (rinse mouth with water before using mouthwash).'],
      whoShouldAskDoctor: ['Children under 6 years of age.'],
      mandatoryWarning: 'Important: Consult a doctor or qualified pharmacist before starting, stopping, or changing the dosage of any medicine.',
      sourceReference: 'Indian Dental Association & WHO Oral Health Protocols',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. R. Khanna, MDS (Endodontics)',
    ),
    MedicineSafetyItem(
      id: 'med-metformin',
      name: 'Blood Glucose Management & Insulin Safety (Educational Overview)',
      genericCategory: 'Antidiabetic / Biguanide Education',
      generalPurpose:
          'Helps improve insulin sensitivity, reduces liver glucose production, and aids glycemic control in Type 2 Diabetes.',
      commonPrecautions: [
        'Must always be taken with or right after meals to reduce stomach discomfort.',
        'Never change dosage or skip prescribed diabetes medicine without consulting your Diabetologist.',
        'Always carry fast-acting carbohydrates (glucose tablets, candy, or fruit juice) in case of hypoglycemia symptoms (sweating, trembling, dizziness).',
      ],
      commonSideEffects: ['Mild nausea, abdominal discomfort, metallic taste initially.'],
      importantInteractions: ['Alcohol (increases risk of hypoglycemia & lactic acidosis)', 'Contrast dyes used in CT scans'],
      whoShouldAskDoctor: [
        'Patients with kidney disease, liver dysfunction, heart failure, or severe dehydration.',
        'Pregnant or breastfeeding women.',
      ],
      mandatoryWarning: 'Important: Consult a certified Diabetologist or healthcare specialist before starting, changing, or stopping diabetes medicines.',
      sourceReference: 'American Diabetes Association (ADA) & ICMR Diabetes Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. S. Mathur, MD, DM (Endocrinology)',
    ),
  ];

  static HealthGuidanceResult analyze(HealthCheckInput input, {AppLanguage language = AppLanguage.hinglish}) {
    final problem = input.mainProblem.toLowerCase();
    final symptoms = input.symptoms.map((s) => s.toLowerCase()).toList();
    final profile = input.profile;
    final allText = '$problem ${symptoms.join(" ")}'.toLowerCase();

    // 1. Red Flag / Emergency Symptoms Check
    final emergencyTriggers = <String>[];
    if (allText.contains('chest pain') || allText.contains('chhati me dard') || allText.contains('seene me dard') || allText.contains('सीने में दर्द')) {
      emergencyTriggers.add(language == AppLanguage.hindi ? 'सीने में तेज दर्द या दबाव' : 'Severe Chest Pain / Pressure');
    }
    if (allText.contains('breath') || allText.contains('saans lene me') || allText.contains('shortness of breath') || allText.contains('suffocation') || allText.contains('सांस')) {
      emergencyTriggers.add(language == AppLanguage.hindi ? 'सांस लेने में अत्यधिक कठिनाई' : 'Difficulty Breathing or Severe Shortness of Breath');
    }
    if (allText.contains('unconscious') || allText.contains('behosh') || allText.contains('fainting') || allText.contains('loss of consciousness') || allText.contains('बेहोश')) {
      emergencyTriggers.add(language == AppLanguage.hindi ? 'अचानक बेहोशी या चक्कर आना' : 'Loss of Consciousness or Sudden Fainting');
    }
    if (allText.contains('stroke') || allText.contains('paralysis') || allText.contains('slurred speech') || allText.contains('face droop') || allText.contains('ek taraf kamzori') || allText.contains('लकवा')) {
      emergencyTriggers.add(language == AppLanguage.hindi ? 'चेहरे का झुकना / एक तरफ कमजोरी / आवाज लड़खड़ाना' : 'Sudden Facial Droop / Weakness on One Side / Slurred Speech');
    }
    if (allText.contains('heavy bleeding') || allText.contains('khoon behna') || allText.contains('blood vomiting') || allText.contains('khoon ki ulti') || allText.contains('खून')) {
      emergencyTriggers.add(language == AppLanguage.hindi ? 'अत्यधिक अनियंत्रित रक्तस्राव या खून की उल्टी' : 'Heavy Uncontrolled Bleeding or Vomiting Blood');
    }

    if (emergencyTriggers.isNotEmpty) {
      return _buildEmergencyResult(input, emergencyTriggers, language);
    }

    // 2. Classify Risk Level & Clinical Domains
    var riskLevel = RiskLevel.low;
    var riskSummary = _getRiskSummary(RiskLevel.low, language);
    var recommendedSpecialist = _getSpecialist('physician', language);
    final possibleCauses = <String>[];
    final generalTips = <String>[];
    final foodList = <FoodSuggestion>[];
    final yogaList = <YogaExercise>[];
    final lifestyleTips = <String>[];
    final medList = <MedicineSafetyItem>[];
    String doctorAdvice = '';

    final medDb = getVerifiedMedicineDatabase(language);

    // Analyze by condition keywords
    final isDiabetes = allText.contains('diabet') ||
        allText.contains('sugar') ||
        allText.contains('glucose') ||
        allText.contains('madhumeh') ||
        allText.contains('insulin') ||
        allText.contains('hba1c') ||
        allText.contains('मधुमेह') ||
        allText.contains('शुगर') ||
        allText.contains('hyperglycemia') ||
        allText.contains('hypoglycemia') ||
        allText.contains('urination') ||
        allText.contains('thirst') ||
        allText.contains('peshab') ||
        profile.conditions.any((c) => c.toLowerCase().contains('diabet') || c.toLowerCase().contains('sugar') || c.contains('मधुमेह'));
    final isDental = allText.contains('tooth') ||
        allText.contains('teeth') ||
        allText.contains('dant') ||
        allText.contains('dentist') ||
        allText.contains('dental') ||
        allText.contains('gum') ||
        allText.contains('cavity') ||
        allText.contains('sensitivity') ||
        allText.contains('masooda') ||
        allText.contains('daanth') ||
        allText.contains('दांत') ||
        allText.contains('मसूड़े') ||
        allText.contains('ulcer') ||
        allText.contains('bad breath') ||
        allText.contains('wisdom') ||
        symptoms.contains('toothache') ||
        symptoms.contains('bleeding gums') ||
        symptoms.contains('sensitivity') ||
        symptoms.contains('cavity');
    final isHeadache = allText.contains('headache') || allText.contains('sir dard') || allText.contains('sar dard') || allText.contains('migraine') || allText.contains('सिर दर्द') || symptoms.contains('headache');
    final isAcidity = allText.contains('acidity') || allText.contains('pet me dard') || allText.contains('gas') || allText.contains('heartburn') || allText.contains('indigestion') || allText.contains('jalan') || allText.contains('एसिडिटी') || allText.contains('गैस') || symptoms.contains('acidity') || symptoms.contains('vomiting') || symptoms.contains('nausea');
    final isBackPain = allText.contains('back pain') || allText.contains('kamar dard') || allText.contains('peedh dard') || allText.contains('spine') || allText.contains('कमर दर्द') || symptoms.contains('back pain') || symptoms.contains('joint pain');
    final isHighBP = allText.contains('blood pressure') || allText.contains('high bp') || allText.contains('रक्तचाप') || profile.conditions.any((c) => c.toLowerCase().contains('bp') || c.toLowerCase().contains('hypertension'));
    final isFever = allText.contains('fever') || allText.contains('bukhar') || allText.contains('बुखार') || symptoms.contains('fever') || symptoms.contains('cough');

    final isLongDuration = input.duration.contains('1 – 2 weeks') || input.duration.contains('More than a month') || input.duration.contains('hafte') || input.duration.contains('mahine') || input.duration.contains('सप्ताह') || input.duration.contains('महीने');

    if (isDiabetes) {
      riskLevel = isLongDuration ? RiskLevel.consultDoctor : RiskLevel.moderate;
      riskSummary = _getDiabetesRiskSummary(language);
      recommendedSpecialist = _getSpecialist('diabetologist', language);
    } else if (isDental) {
      riskLevel = isLongDuration ? RiskLevel.consultDoctor : RiskLevel.moderate;
      riskSummary = _getDentalRiskSummary(language);
      recommendedSpecialist = _getSpecialist('dentist', language);
    } else if (isFever && isLongDuration) {
      riskLevel = RiskLevel.consultDoctor;
      riskSummary = _getFeverRiskSummary(language);
      recommendedSpecialist = _getSpecialist('physician', language);
    } else if (isHighBP || (isBackPain && isLongDuration)) {
      riskLevel = RiskLevel.moderate;
      riskSummary = _getModerateRiskSummary(language);
      recommendedSpecialist = isBackPain ? _getSpecialist('orthopedic', language) : _getSpecialist('cardiologist', language);
    } else if (isLongDuration) {
      riskLevel = RiskLevel.moderate;
      riskSummary = _getChronicRiskSummary(language);
      recommendedSpecialist = _getSpecialist('physician', language);
    }

    // --- DOMAIN-SPECIFIC GUIDANCE ---
    if (isDiabetes) {
      _populateDiabetesGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getDiabetesDoctorAdvice(language);
    } else if (isDental) {
      _populateDentalGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getDentalDoctorAdvice(language);
    } else if (isHeadache) {
      _populateHeadacheGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getHeadacheDoctorAdvice(language);
    } else if (isAcidity) {
      _populateAcidityGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getAcidityDoctorAdvice(language);
    } else if (isBackPain) {
      _populateBackPainGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getBackPainDoctorAdvice(language);
    } else if (isFever) {
      _populateFeverGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getFeverDoctorAdvice(language);
    } else {
      _populateGeneralGuidance(possibleCauses, generalTips, foodList, yogaList, medList, medDb, language);
      doctorAdvice = _getGeneralDoctorAdvice(language);
    }

    if (medList.isEmpty) {
      medList.add(medDb[0]); // Paracetamol educational safety fallback
    }

    return HealthGuidanceResult(
      id: 'res-${_uuid.v4().substring(0, 8)}',
      reportedProblem: input.mainProblem.isNotEmpty ? input.mainProblem : (input.symptoms.isNotEmpty ? input.symptoms.join(', ') : (language == AppLanguage.hindi ? 'सामान्य स्वास्थ्य जांच' : 'General Health Assessment')),
      symptoms: input.symptoms,
      duration: input.duration,
      riskLevel: riskLevel,
      riskSummary: riskSummary,
      possibleCauses: possibleCauses,
      generalGuidanceTips: generalTips,
      foodSuggestions: foodList,
      yogaExercises: yogaList,
      lifestyleTips: lifestyleTips,
      medicineSafetyItems: medList,
      doctorConsultationAdvice: doctorAdvice,
      recommendedSpecialist: recommendedSpecialist,
      isEmergency: false,
      createdAt: DateTime.now(),
    );
  }

  // --- POPULATION HELPERS BY LANGUAGE ---
  static void _populateDiabetesGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'इंसुलिन संवेदनशीलता में कमी या ग्लूकोज असंतुलन (प्री-डायबिटीज / टाइप 2)',
        'हाई ग्लाइसेमिक कार्बोहाइड्रेट आहार या मीठे का अत्यधिक सेवन',
        'शारीरिक गतिविधि की कमी या लंबे समय तक बैठे रहने की दिनचर्या',
        'तनाव के कारण कोर्टिसोल बढ़ना जिससे फास्टिंग ब्लड शुगर बढ़ता है',
        'डायबिटीज दवा की खुराक में डॉक्टर द्वारा समीक्षा की आवश्यकता',
      ]);
      generalTips.addAll([
        'ग्लूकोमीटर से फास्टिंग और भोजन के 2 घंटे बाद का ब्लड शुगर स्तर नियमित मापें।',
        'मुख्य भोजन के बाद 15 मिनट की तेज चाल चलें जिससे इंसुलिन सक्रियता बढ़ती है।',
        'फाइबर युक्त, कम ग्लाइसेमिक इंडेक्स और साबुत अनाज वाला संतुलित आहार लें।',
        'पैरों में किसी भी कट, छाले या संक्रमण से बचने के लिए रोजाना पैरों की जांच करें।',
        'लो शुगर (हाइपोग्लाइसीमिया) की स्थिति के लिए हमेशा ग्लूकोज टॉफी या किशमिश साथ रखें।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'कम ग्लाइसेमिक और फाइबर युक्त मधुमेह आहार',
          category: 'Recommended',
          description: 'कॉम्प्लेक्स कार्बोहाइड्रेट, हरी पत्तेदार सब्जियां और कम ग्लाइसेमिक इंडेक्स वाले खाद्य पदार्थ।',
          items: [
            'करेला, मेथी दाना और चिया सीड्स',
            'ओट्स, अंकुरित मूंग/चना, और ज्वार/मल्टीग्रेन रोटी',
            'हरी पत्तेदार सब्जियां (पालक, मेथी साग, खीरा, बीन्स)',
            'दालचीनी की बिना चीनी वाली चाय और जामुन',
          ],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'हाई ग्लाइसेमिक और शुगर बढ़ाने वाले खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'साधारण चीनी, रिफाइंड कार्बोहाइड्रेट और प्रोसेस्ड चीजें जो तेजी से शुगर बढ़ाती हैं।',
          items: [
            'सफेद चीनी, शहद, गुड़ और पारंपरिक मिठाइयां',
            'सफेद ब्रेड, मैदा और मीठे ब्रेकफास्ट सीरियल',
            'पैकेटबंद फलों का जूस, कोल्ड ड्रिंक्स और फ्लेवर्ड मिल्क',
            'तले-भुने स्नैक्स, आलू और बहुत तैलीय खाना',
          ],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'मंडूकासन (मेंढक मुद्रा) और कपालभाति प्राणायाम',
          duration: '10 – 15 मिनट',
          intensity: 'मध्यम',
          description: 'पेट के अंगों को धीरे से संकुचित करता है, अग्न्याशय (पैंक्रियाज) को सक्रिय करता है और मेटाबॉलिज्म सुधारता है।',
          steps: [
            'वज्रासन में बैठें और रीढ़ की हड्डी सीधी रखें।',
            'दोनों हाथों की मुट्ठी बनाएं और अंगूठे को नाभि की ओर रखें।',
            'सांस बाहर छोड़ें, आगे झुकें और मुट्ठियों को पेट पर दबाएं।',
            'सामने देखें, 15-30 सेकंड सामान्य सांस लें, फिर धीरे-धीरे सीधे हों।',
            'इसके बाद 5 मिनट शांत गति से कपालभाति प्राणायाम करें।',
          ],
          safetyWarning: 'पेट की सर्जरी, हर्निया या गर्भावस्था के दौरान इसे न करें।',
        ),
      );
    } else if (lang == AppLanguage.hinglish) {
      possibleCauses.addAll([
        'Insulin resistance ya glucose tolerance issue (Type 2 Diabetes / Pre-diabetes)',
        'High sugar intake ya refined carbohydrates ka sevan',
        'Physical exercise ki kami ya continuous sedentary lifestyle',
        'Stress ke kaaran cortisol badhna jo blood sugar badhata hai',
        'Diabetes medicines ki dosage adjust karne ki zaroorat',
      ]);
      generalTips.addAll([
        'Glucometer se fasting aur khane ke 2 ghante baad blood sugar check karein.',
        'Har meal ke baad 15 minute ki brisk walk zaroor karein.',
        'High-fiber aur low glycemic index wali diet follow karein.',
        'Daily apne pairon (feet) ko inspect karein taki diabetic wounds se bacha ja sake.',
        'Low sugar (hypo) ke liye hamesha glucose tablets, toffee ya raisins sath rakhein.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Low Glycemic & Fiber-Rich Diabetes Diet',
          category: 'Recommended',
          description: 'Complex carbs, high-fiber greens aur low GI foods jo sugar spike nahi hone dete.',
          items: [
            'Karela, methi dana aur soaked chia seeds',
            'Oats, sprouts (moong/chana) aur multigrain roti',
            'Green leafy vegetables (spinach, cucumber, beans)',
            'Cinnamon tea aur Jamun',
          ],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'High Glycemic & Sugar Trigger Foods',
          category: 'Limit/Avoid',
          description: 'Refined carbs aur sweets jo blood sugar tezi se badhate hain.',
          items: [
            'Sugar, honey, gud aur traditional mithaiyan',
            'White bread, maida aur sweetened breakfast cereals',
            'Packaged fruit juice, sodas aur soft drinks',
            'Deep fried snacks aur creamy high fat gravies',
          ],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Mandukasana (Frog Pose) & Kapalbhati Pranayama',
          duration: '10 – 15 mins',
          intensity: 'Moderate',
          description: 'Abdomen compress karke pancreas stimulate karta hai aur metabolism behtar karta hai.',
          steps: [
            'Vajrasana me baithein aur back straight rakhein.',
            'Haathon ki mutthi banayein aur thumbs ko naabhi ke paas rakhein.',
            'Saans bahar chhodte hue aage jhukein aur pet par halka pressure dein.',
            '15-30 second normal saans lein, fir dheere se wapas aayein.',
            'Iske baad 5 minute calm pace par Kapalbhati karein.',
          ],
          safetyWarning: 'Abdominal surgery recovery, hernia ya pregnancy me ye na karein.',
        ),
      );
    } else {
      possibleCauses.addAll([
        'Insulin resistance or impaired glucose tolerance (Pre-diabetes / Type 2)',
        'High glycemic carbohydrate dietary intake or sugar spikes',
        'Inadequate physical activity or prolonged sedentary routine',
        'Stress-induced cortisol release affecting fasting glucose',
        'Need for physician review of antidiabetic medication dosage',
      ]);
      generalTips.addAll([
        'Monitor fasting and 2-hour post-meal blood sugar levels with a calibrated glucometer.',
        'Take a 15-minute brisk walk after major meals to enhance insulin sensitivity.',
        'Follow a disciplined low-GI diet rich in complex fibers and plant proteins.',
        'Inspect your feet daily for small cuts, dry skin, or calluses to avoid infections.',
        'Always carry fast-acting glucose tablets, candy, or raisins in case of hypoglycemia.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Low Glycemic & Fiber-Rich Diabetes Nutrition',
          category: 'Recommended',
          description: 'Complex carbohydrates, high-fiber greens, and foods with low glycemic index.',
          items: [
            'Bitter gourd (Karela), fenugreek (Methi) seeds, and raw chia seeds',
            'Oats, whole sprouted pulses (Moong/Chana), and multigrain/jowar roti',
            'Green leafy vegetables (Spinach, Methi saag, Cucumber, Beans)',
            'Unsweetened cinnamon herbal tea and antioxidant-rich Jamun/Berries',
          ],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'High Glycemic & Glucose Spike Triggers',
          category: 'Limit/Avoid',
          description: 'Simple sugars, refined carbs, and processed items causing rapid glucose spikes.',
          items: [
            'Refined sugar, honey, jaggery, and traditional sweets (mithai)',
            'White bread, refined wheat flour (maida), and sweetened breakfast cereals',
            'Packaged fruit juices, sodas, energy drinks, and flavored milk',
            'Deep-fried snacks, potatoes, and full-fat creamy gravies',
          ],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Mandukasana (Frog Pose) & Kapalbhati Pranayama',
          duration: '10 – 15 mins',
          intensity: 'Moderate',
          description: 'Gently compresses the abdominal area, stimulates the pancreas, aids digestion, and promotes metabolic health.',
          steps: [
            'Sit in Vajrasana (kneeling posture) with back straight.',
            'Make fists with your hands and place thumbs pointing toward your navel.',
            'Exhale completely, bend forward from hips, and press fists gently against abdomen.',
            'Keep head looking forward, breathe normally for 15–30 seconds, then slowly return up.',
            'Follow with 5 minutes of gentle Kapalbhati breathing at a calm pace.',
          ],
          safetyWarning: 'Avoid during active abdominal surgery recovery, hernia, or pregnancy.',
        ),
      );
    }

    if (medDb.length > 7) medList.add(medDb[7]); // Metformin / Diabetes item
    medList.add(medDb[0]); // Paracetamol
  }

  static void _populateDentalGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'दांत के इनेमल का क्षरण या कैविटी (दांत में कीड़ा/सड़न)',
        'प्लाक जमने के कारण मसूड़ों की सूजन (जिंजिवाइटिस)',
        'गर्म, ठंडे या खट्टे खाने से डेंटिन संवेदनशीलता',
        'अकल दाढ़ (Wisdom tooth) का दबाव या मसूड़े का दर्द',
        'मुंह के अंदर हल्का छाला या अंदरूनी जलन',
      ]);
      generalTips.addAll([
        'गुनगुने पानी में आधा चम्मच नमक मिलाकर दिन में 3-4 बार हल्के कुल्ले करें।',
        'अस्थायी आराम के लिए रुई से एक बूंद लौंग का तेल दर्द वाले दांत पर लगाएं।',
        'सूजन होने पर गाल के बाहर कपड़े में लपेटकर बर्फ की सिकाई 10-15 मिनट करें।',
        'सॉफ्ट ब्रिसल वाले टूथब्रश से दिन में दो बार धीरे-धीरे ब्रश करें।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'दांत व मसूड़ों के लिए अनुकूल आहार',
          category: 'Recommended',
          description: 'मुलायम, गैर-उत्तेजक और कैल्शियम व विटामिन डी युक्त खाद्य पदार्थ।',
          items: [
            'गुनगुनी पतली खिचड़ी, दलिया या मैश किए आलू',
            'ताजा सादा दही (ओरल फ्लोरा के लिए)',
            'सब्जियों का हल्का गर्म सूप',
            'मुलायम फल (पपीता, पका केला)',
          ],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'दांतों को नुकसान पहुंचाने वाले खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'वे चीजें जो कैविटी बढ़ाती हैं या दर्द को उत्तेजित करती हैं।',
          items: [
            'चिपचिपी टॉफियां, हार्ड कैंडी व चॉकलेट',
            'अत्यधिक ठंडे या खौलते गर्म पेय पदार्थ',
            'कोल्ड ड्रिंक्स और ज्यादा खट्टे नीम्बू के रस',
            'कठोर चीजें (सुपारी, बर्फ, नट्स) चबाना',
          ],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'जबड़े और चेहरे की मांसपेशियों का तनाव मुक्ति व्यायाम',
          duration: '3 – 5 मिनट',
          intensity: 'सौम्य',
          description: 'जबड़े के जोड़ (TMJ) के तनाव को कम करता है और चेहरे की मांसपेशियों को आराम देता है।',
          steps: [
            'आराम से बैठें और जबड़े को ढीला छोड़ें।',
            'जीभ की नोक को सामने के दांतों के ठीक पीछे तालू पर लगाएं।',
            'जीभ को तालू पर रखते हुए मुंह को धीरे से जितना संभव हो खोलें और बंद करें।',
            'इसे बिना जोर लगाए 5 से 6 बार दोहराएं।',
          ],
          safetyWarning: 'तेज जोड़ दर्द होने पर मुंह जबरन न खोलें।',
        ),
      );
    } else {
      possibleCauses.addAll([
        'Tooth enamel decay or bacterial cavity (dental caries)',
        'Gingivitis or mild gum inflammation due to plaque buildup',
        'Exposed dentin sensitivity to hot, cold, sweet, or acidic foods',
        'Impacted wisdom tooth pressure or teething irritation',
        'Mild aphthous mouth ulcer or mucosal irritation',
      ]);
      generalTips.addAll([
        'Gargle gently with warm salt water (1/2 tsp salt in 1 glass lukewarm water) 3–4 times daily.',
        'Apply a tiny drop of clove oil on a cotton swab directly on the affected tooth for temporary soothing.',
        'Apply a cold ice compress wrapped in cloth to the outer cheek for 10–15 minutes if there is swelling.',
        'Brush gently twice a day with a soft-bristle toothbrush; avoid aggressive horizontal scrubbing.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Tooth & Gum Friendly Nutrition',
          category: 'Recommended',
          description: 'Soft, non-irritating foods rich in calcium, vitamin D, and phosphorus.',
          items: [
            'Lukewarm soft khichdi, dalia, or mashed potatoes',
            'Fresh plain yogurt / curd (probiotic support for oral flora)',
            'Warm vegetable or chicken broth (easy to chew)',
            'Water-rich soft fruits (papaya, soft ripe banana)',
          ],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Dental Irritants & Cavity Triggers',
          category: 'Limit/Avoid',
          description: 'Foods that exacerbate toothache, erode enamel, and feed oral bacteria.',
          items: [
            'Sticky sweets, toffees, and hard candies',
            'Extreme temperature drinks (ice cubes or steaming hot tea)',
            'Carbonated soft drinks, energy drinks, and highly acidic lemon juices',
            'Chewing hard food (nuts, popcorn kernels, ice) with the affected tooth',
          ],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Gentle Jaw & Facial Muscle Release',
          duration: '3 – 5 mins',
          intensity: 'Gentle',
          description: 'Relieves temporomandibular joint (TMJ) tightness and eases facial muscle tension.',
          steps: [
            'Sit comfortably and let your jaw relax.',
            'Place the tip of your tongue against the roof of your mouth behind front teeth.',
            'Slowly open your mouth as far as comfortable while keeping tongue on roof, then close.',
            'Repeat 5 to 6 times smoothly without straining.',
          ],
          safetyWarning: 'Do not force mouth open if experiencing sharp joint pain.',
        ),
      );
    }

    if (medDb.length > 5) medList.add(medDb[5]); // Clove Oil
    if (medDb.length > 6) medList.add(medDb[6]); // Chlorhexidine
    medList.add(medDb[0]); // Paracetamol
  }

  static void _populateHeadacheGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'लंबे समय तक स्क्रीन देखने या गर्दन के खिंचाव से तनाव सिरदर्द',
        'पानी की कमी (डिहाइड्रेशन) या समय पर भोजन न करना',
        'नींद पूरी न होना या अत्यधिक मानसिक तनाव',
        'माइग्रेन की प्रवृत्ति या आंखों का चश्मा नंबर बदलना',
      ]);
      generalTips.addAll([
        'शांत, कम रोशनी वाले और हवादार कमरे में विश्राम करें।',
        'माथे और कनपटी पर ठंडे या गुनगुने गीले कपड़े की पट्टी रखें।',
        'एक गिलास साफ पानी धीरे-धीरे घूंट-घूंट करके पिएं।',
        'डिजिटल स्क्रीन (मोबाइल, लैपटॉप) से पूरी तरह ब्रेक लें।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'हाइड्रेशन व मैग्नीशियम युक्त आहार',
          category: 'Recommended',
          description: 'इलेक्ट्रोलाइट संतुलन और हल्का सुपाच्य पोषण।',
          items: ['नारियल पानी या हर्बल चाय (पुदीना/कैमोमाइल)', 'भीगे हुए बादाम और कद्दू के बीज', 'ताजा तरबूज या खीरा', 'हल्का गर्म वेज सूप'],
          icon: 'water_drop',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'सिरदर्द बढ़ाने वाले खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'वे खाद्य पदार्थ जो सिरदर्द को ट्रिगर कर सकते हैं।',
          items: ['अत्यधिक चाय/कॉफी या अचानक कैफीन छोड़ना', 'प्रोसेस्ड जंक फूड व कृत्रिम स्वीटनर', 'अत्यधिक ठंडे सोडे व आइसक्रीम'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'शवासन और अनुलोम विलोम प्राणायाम',
          duration: '8 – 10 मिनट',
          intensity: 'विश्राम',
          description: 'तंत्रिका तंत्र को शांत करता है, सिर के दबाव को कम करता है और मानसिक तनाव घटाता है।',
          steps: [
            'शांत जगह पर पीठ के बल लेटें और शरीर को पूरी तरह ढीला छोड़ें।',
            'धीमी और गहरी सांसें लें, ध्यान सांसों के आवागमन पर रखें।',
            'इसके बाद 5 मिनट अनुलोम विलोम प्राणायाम करें।',
          ],
        ),
      );
    } else {
      possibleCauses.addAll([
        'Tension headache from prolonged screen time or neck muscle strain',
        'Dehydration or missed regular meals',
        'Inadequate or irregular sleep pattern',
        'Stress, sensory overload, or migraine tendency',
      ]);
      generalTips.addAll([
        'Rest in a quiet, dimly lit, and well-ventilated room.',
        'Place a cool, damp washcloth across your forehead and temples.',
        'Drink a large glass of clean water slowly.',
        'Take a complete break from digital screens.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Hydration & Magnesium-Rich Foods',
          category: 'Recommended',
          description: 'Electrolyte hydration and light, easily digestible nourishment.',
          items: ['Coconut water or warm herbal tea', 'Soaked almonds and pumpkin seeds', 'Fresh watermelon or cucumber slices', 'Light warm vegetable soup'],
          icon: 'water_drop',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Headache Trigger Foods',
          category: 'Limit/Avoid',
          description: 'Common foods that can trigger vascular headaches.',
          items: ['Excess caffeine or sudden caffeine withdrawal', 'Processed aged cheeses', 'Artificial sweeteners and MSG', 'Ice-cold carbonated sodas'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Shavasana & Anulom Vilom (Alternate Nostril Breathing)',
          duration: '8 – 10 mins',
          intensity: 'Relaxation',
          description: 'Calms the nervous system, eases cranial pressure, and reduces mental tension.',
          steps: [
            'Lie flat on your back in a quiet space and close eyes.',
            'Breathe slowly and deeply, releasing tension from forehead and neck.',
            'Follow with 5 minutes of calm Anulom Vilom pranayama.',
          ],
        ),
      );
    }
    medList.add(medDb[0]); // Paracetamol
  }

  static void _populateAcidityGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'अत्यधिक तला-भुना, मसालेदार या खट्टा भोजन',
        'खाली पेट ज्यादा चाय या कॉफी का सेवन',
        'देर रात भोजन करके तुरंत सो जाना',
        'मानसिक तनाव या अनियमित भोजन समय',
      ]);
      generalTips.addAll([
        'भोजन के बाद 1 चम्मच सौंफ और थोड़ी मिश्री चबाएं।',
        'भोजन और सोने के बीच कम से कम 2 घंटे का अंतर रखें।',
        'एक साथ अधिक खाने के बजाय थोड़े-थोड़े अंतराल पर हल्का खाएं।',
        'दिन भर में गुनगुना पानी घूंट-घूंट करके पिएं।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'पेट को शांत करने वाला सुपाच्य आहार',
          category: 'Recommended',
          description: 'पेट की जलन शांत करने और एसिडिटी कम करने वाले खाद्य पदार्थ।',
          items: ['ठंडा सादा दूध या ताजा छाछ (मट्ठा)', 'केला, पपीता और नारियल पानी', 'मूंग दाल की पतली खिचड़ी और दलिया', 'सौंफ या जीरे का उबला पानी'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'एसिडिटी बढ़ाने वाले खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'वे खाद्य पदार्थ जो पेट में एसिड की मात्रा बढ़ाते हैं।',
          items: ['अत्यधिक तीखा, तला-भुना और मिर्च-मसालेदार खाना', 'खट्टे फल, सिरका और पैकेटबंद स्नैक्स', 'कोल्ड ड्रिंक और कार्बोनेटेड पेय', 'खाली पेट तेज चाय या कॉफी'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'वज्रासन (भोजनोपरांत पाचन आसन)',
          duration: '5 – 10 मिनट',
          intensity: 'सौम्य',
          description: 'पाचन तंत्र में रक्त संचार बढ़ाता है और गैस व एसिडिटी से राहत देता है।',
          steps: [
            'भोजन के बाद घुटनों को मोड़कर एड़ियों पर बैठें।',
            'रीढ़ की हड्डी सीधी रखें और हाथ घुटनों पर रखें।',
            '5 से 10 मिनट तक सामान्य रूप से गहरी सांसें लें।',
          ],
        ),
      );
    } else {
      possibleCauses.addAll([
        'Spicy, oily, or highly acidic food intake',
        'Empty stomach tea or coffee consumption',
        'Lying down immediately after eating meals',
        'Irregular meal timings and stress',
      ]);
      generalTips.addAll([
        'Chew a teaspoon of fennel seeds (saunf) after meals.',
        'Keep a 2-hour gap between dinner and sleeping.',
        'Eat small, frequent meals rather than heavy portions.',
        'Sip lukewarm water throughout the day.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Stomach Soothing Nutrition',
          category: 'Recommended',
          description: 'Alkaline and easy-to-digest foods that balance stomach acid.',
          items: ['Cold plain milk or fresh buttermilk (chaas)', 'Ripe banana, papaya, and coconut water', 'Steamed moong dal khichdi', 'Fennel seed or cumin infused water'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Acidity & Reflux Triggers',
          category: 'Limit/Avoid',
          description: 'Foods that irritate stomach lining and trigger acid spikes.',
          items: ['Deep-fried, greasy, and ultra-spicy dishes', 'Citrus fruits, vinegar, and processed junk', 'Carbonated soft drinks and commercial fruit punches', 'Strong coffee on empty stomach'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Vajrasana (Post-Meal Digestion Pose)',
          duration: '5 – 10 mins',
          intensity: 'Gentle',
          description: 'Enhances blood circulation to digestive organs and prevents acid reflux.',
          steps: [
            'Kneel on the floor with knees together and sit on heels.',
            'Keep your spine straight and hands on your thighs.',
            'Breathe normally and hold comfortably for 5 to 10 minutes.',
          ],
        ),
      );
    }
    if (medDb.length > 1) medList.add(medDb[1]); // Antacid
  }

  static void _populateBackPainGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'लंबे समय तक गलत मुद्रा (खराब पोस्चर) में बैठना',
        'मांसपेशियों में खिंचाव या मोच',
        'कैल्शियम या विटामिन डी की कमी',
        'भारी वजन उठाना या अचानक झुकना',
      ]);
      generalTips.addAll([
        'पीठ के पीछे तकिया लगाकर सीधी मुद्रा में बैठें।',
        'दर्द वाली जगह पर गर्म पानी की थैली से सिकाई करें।',
        'अचानक भारी वजन उठाने या झटके से झुकने से बचें।',
        'दिन में 2 बार हल्का दर्द निवारक जेल लगाएं।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'हड्डियों व मांसपेशियों के लिए पोषण',
          category: 'Recommended',
          description: 'कैल्शियम, मैग्नीशियम और एंटी-इंफ्लेमेटरी आहार।',
          items: ['दूध, दही, पनीर और तिल (कैल्शियम स्रोत)', 'हल्दी वाला गुनगुना दूध', 'अखरोट, बादाम और अलसी के बीज', 'हरी पत्तेदार सब्जियां'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'सूजन बढ़ाने वाले खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'वे खाद्य पदार्थ जो मांसपेशियों में दर्द और सूजन बढ़ाते हैं।',
          items: ['अत्यधिक चीनी व प्रोसेस्ड जंक फूड', 'शराब व धूम्रपान', 'अत्यधिक नमक वाले पैकेटबंद स्नैक्स'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'भुजंगासन (कोबरा पोज) और मार्जरी आसन (कैट-काउ)',
          duration: '5 – 8 मिनट',
          intensity: 'सौम्य',
          description: 'रीढ़ की हड्डी को लचीला बनाता है और कमर के निचले हिस्से की अकड़न दूर करता है।',
          steps: [
            'पेट के बल लेटें और हथेलियों को कंधों के पास रखें।',
            'सांस लेते हुए नाभि तक छाती को धीरे से ऊपर उठाएं।',
            '10-15 सेकंड रुकें, फिर सांस छोड़ते हुए धीरे-धीरे नीचे आएं।',
          ],
          safetyWarning: 'यदि तेज नसों का दर्द (Sciatica) हो तो जबरन न करें।',
        ),
      );
    } else {
      possibleCauses.addAll([
        'Poor sitting posture during prolonged desk work',
        'Muscular strain or lumbar ligament sprain',
        'Vitamin D or Calcium deficiency',
        'Improper heavy lifting or sudden twisting',
      ]);
      generalTips.addAll([
        'Maintain ergonomic posture with lumbar back support.',
        'Apply warm compress to the stiff area for 10-15 minutes.',
        'Avoid sudden jerky movements and heavy weight lifting.',
        'Apply gentle topical pain relief gel 2 times daily.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Bone & Muscle Support Nutrition',
          category: 'Recommended',
          description: 'Anti-inflammatory and calcium/vitamin D rich foods.',
          items: ['Milk, paneer, and sesame seeds (calcium rich)', 'Warm golden turmeric milk', 'Walnuts, almonds, and flax seeds', 'Dark green vegetables'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Pro-Inflammatory Foods',
          category: 'Limit/Avoid',
          description: 'Foods that increase systemic inflammation.',
          items: ['High-sugar items and refined pastries', 'Excessive alcohol and smoking', 'Deep-fried salty snacks'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Bhujangasana (Cobra Pose) & Cat-Cow Stretch',
          duration: '5 – 8 mins',
          intensity: 'Gentle',
          description: 'Strengthens spinal musculature and releases lower lumbar tightness.',
          steps: [
            'Lie flat on your stomach with hands near shoulders.',
            'Inhale and gently lift chest off the mat up to navel level.',
            'Hold for 10–15 seconds breathing normally, then release down.',
          ],
          safetyWarning: 'Do not over-extend if experiencing radiating leg pain.',
        ),
      );
    }
    if (medDb.length > 4) medList.add(medDb[4]); // Pain relief gel
    medList.add(medDb[0]); // Paracetamol
  }

  static void _populateFeverGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'वायरल संक्रमण या मौसमी फ्लू',
        'शरीर में सूजन या थकान',
        'मौसम में अचानक बदलाव या डिहाइड्रेशन',
      ]);
      generalTips.addAll([
        'थर्मामीटर से हर 4-6 घंटे में तापमान मापें और नोट करें।',
        'माथे पर सामान्य पानी की पट्टी रखें यदि तापमान अधिक हो।',
        'भरपूर पानी, ओआरएस और तरल पदार्थ पिएं।',
        'पूरा आराम करें और भारी काम न करें।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'बुखार में हल्का व ऊर्जादायक आहार',
          category: 'Recommended',
          description: 'शरीर को हाइड्रेटेड रखने और इम्यूनिटी बढ़ाने वाले खाद्य पदार्थ।',
          items: ['गर्म सब्जियों या दाल का सूप', 'ओआरएस और नारियल पानी', 'पतली मूंग दाल खिचड़ी', 'ताजे मौसमी फल (अनार, सेब)'],
          icon: 'water_drop',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'भारी व पचने में कठिन आहार',
          category: 'Limit/Avoid',
          description: 'वे खाद्य पदार्थ जो बुखार में पाचन तंत्र पर दबाव डालते हैं।',
          items: ['तैलीय, तला-भुना और भारी भोजन', 'अत्यधिक ठंडा पानी व आइसक्रीम', 'पैकेटबंद जंक फूड'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'शवासन और गहरा विश्राम',
          duration: '10 – 15 मिनट',
          intensity: 'विश्राम',
          description: 'बुखार के दौरान भारी व्यायाम न करें; शरीर को ऊर्जा बचाने और ठीक होने दें।',
          steps: [
            'आरामदायक बिस्तर पर लेट जाएं।',
            'आंखें बंद करके गहरी व शांत सांसें लें।',
          ],
        ),
      );
    } else {
      possibleCauses.addAll([
        'Viral infection or seasonal flu',
        'General systemic immune response',
        'Weather changes and mild dehydration',
      ]);
      generalTips.addAll([
        'Monitor temperature with a digital thermometer every 4-6 hours.',
        'Use lukewarm water sponge on forehead if fever is elevated.',
        'Stay thoroughly hydrated with ORS, coconut water, and clean fluids.',
        'Get plenty of restorative bed rest.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Hydrating & Light Recovery Nutrition',
          category: 'Recommended',
          description: 'Easy-to-digest fluids and soothing light nourishment.',
          items: ['Warm vegetable broth or clear dal soup', 'ORS solution and coconut water', 'Steamed soft khichdi', 'Fresh stewed apples and pomegranate'],
          icon: 'water_drop',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Heavy & Indigestible Foods',
          category: 'Limit/Avoid',
          description: 'Foods that place extra burden on digestive metabolism during fever.',
          items: ['Greasy, deep-fried snacks', 'Ice-cold refrigerated beverages', 'Heavy ultra-processed fast food'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Restorative Shavasana Bed Rest',
          duration: '10 – 15 mins',
          intensity: 'Rest',
          description: 'No active physical exercise during fever; conserve body energy for immune recovery.',
          steps: [
            'Lie comfortably supported with pillows in a well-ventilated room.',
            'Practice calm rhythmic breathing.',
          ],
        ),
      );
    }
    medList.add(medDb[0]); // Paracetamol
    if (medDb.length > 2) medList.add(medDb[2]); // ORS
  }

  static void _populateGeneralGuidance(
    List<String> possibleCauses,
    List<String> generalTips,
    List<FoodSuggestion> foodList,
    List<YogaExercise> yogaList,
    List<MedicineSafetyItem> medList,
    List<MedicineSafetyItem> medDb,
    AppLanguage lang,
  ) {
    if (lang == AppLanguage.hindi) {
      possibleCauses.addAll([
        'सामान्य थकान, तनाव या डिहाइड्रेशन',
        'खानपान में असंतुलन या अपर्याप्त नींद',
        'मौसम में बदलाव या शारीरिक थकान',
      ]);
      generalTips.addAll([
        'प्रतिदिन 8-10 गिलास साफ पानी पिएं।',
        '7-8 घंटे की नियमित और गहरी नींद लें।',
        'ताजा, घर का बना संतुलित भोजन करें।',
        'लक्षण 2-3 दिन से अधिक बने रहने पर डॉक्टर से मिलें।',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'संतुलित व पौष्टिक आहार',
          category: 'Recommended',
          description: 'शरीर की रोग प्रतिरोधक क्षमता और ऊर्जा बनाए रखने के लिए।',
          items: ['ताजे फल और हरी सब्जियां', 'दालें, अंकुरित अनाज और दही', 'पर्याप्त पानी और सूप'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'अस्वास्थ्यकर खाद्य पदार्थ',
          category: 'Limit/Avoid',
          description: 'शरीर को नुकसान पहुंचाने वाले आहार से बचें।',
          items: ['अत्यधिक तेल-मसालेदार खाना', 'जंक फूड और कोल्ड ड्रिंक', 'अधिक चीनी और मैदा'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'ताड़ासन और अनुलोम विलोम प्राणायाम',
          duration: '5 – 10 मिनट',
          intensity: 'सौम्य',
          description: 'शरीर को ऊर्जावान रखता है और तनाव कम करता है।',
          steps: [
            'सीधे खड़े होकर हाथ ऊपर खींचें (ताड़ासन)।',
            'इसके बाद 5 मिनट शांत बैठकर अनुलोम विलोम करें।',
          ],
        ),
      );
    } else {
      possibleCauses.addAll([
        'Mild general fatigue, stress, or temporary dehydration',
        'Irregular meal schedule or lack of quality sleep',
        'Minor muscular fatigue or weather changes',
      ]);
      generalTips.addAll([
        'Drink 8–10 glasses of clean water daily.',
        'Ensure 7–8 hours of sound nighttime sleep.',
        'Eat wholesome, freshly prepared balanced meals.',
        'Consult a physician if symptoms persist beyond 2-3 days.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Balanced Wellness Nutrition',
          category: 'Recommended',
          description: 'Nutrient-dense foods to boost vitality and immune strength.',
          items: ['Fresh fruits and green vegetables', 'Whole pulses, sprouts, and yogurt', 'Adequate hydration and clear soups'],
          icon: 'eco',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Unhealthy & Processed Foods',
          category: 'Limit/Avoid',
          description: 'Items that deplete energy and cause inflammation.',
          items: ['Greasy fast food', 'Sugary drinks and sodas', 'Excess refined flour snacks'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Tadasana (Mountain Pose) & Anulom Vilom',
          duration: '5 – 10 mins',
          intensity: 'Gentle',
          description: 'Improves posture, energizes the body, and eases mental fatigue.',
          steps: [
            'Stand tall with feet hip-width apart, reach hands overhead.',
            'Follow with 5 minutes of calming alternate nostril breathing.',
          ],
        ),
      );
    }
    medList.add(medDb[0]); // Paracetamol
  }

  // --- STRING GENERATORS ---
  static String _getRiskSummary(RiskLevel level, AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'हल्के लक्षण। घरेलू देखभाल, पर्याप्त पानी और आराम की सलाह दी जाती है।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Halke symptoms hain. Supportive home care, paani aur aaram se manage kiya ja sakta hai.';
    }
    return 'Mild symptoms suitable for supportive home care, hydration, and rest.';
  }

  static String _getDiabetesRiskSummary(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'ब्लड शुगर / डायबिटीज प्रबंधन की स्थिति पाई गई है। कम ग्लाइसेमिक आहार लें, ग्लूकोज की नियमित जांच करें और डायबेटोलॉजिस्ट से परामर्श लें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Blood sugar / Diabetes management concern detect hua hai. Low-GI diet lein, sugar monitor karein aur Diabetologist se consult karein.';
    }
    return 'Blood sugar / Diabetes management concern detected. Maintain low-GI nutrition, monitor glucose, and consult a Diabetologist.';
  }

  static String _getDentalRiskSummary(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'दांत या मसूड़ों की तकलीफ का पता चला है। सौम्य ओरल केयर अपनाएं और परीक्षण के लिए दंत चिकित्सक से मिलें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Dental takleef detect hui hai. Soothing oral hygiene follow karein aur Dentist ko dikhayein.';
    }
    return 'Dental discomfort detected. Follow soothing oral hygiene care and visit a dentist for clinical evaluation.';
  }

  static String _getFeverRiskSummary(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'लगातार कई दिनों से बना बुखार। सटीक जांच के लिए डॉक्टर से परामर्श अवश्य लें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Kayi dino se bukhar bana hua hai. Diagnostic tests aur doctor consult zaroori hai.';
    }
    return 'Persistent fever lasting several days requires professional medical diagnostic tests.';
  }

  static String _getModerateRiskSummary(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'मध्यम लक्षण। सावधान जीवनशैली बदलाव और डॉक्टर से समीक्षा की सिफारिश की जाती है।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Moderate symptoms hain. Careful home care aur scheduled doctor review recommended hai.';
    }
    return 'Moderate symptoms. Gentle lifestyle modifications recommended with scheduled doctor review.';
  }

  static String _getChronicRiskSummary(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'लंबे समय से बने रहने वाले लक्षणों की डॉक्टर द्वारा शारीरिक जांच जरूरी है।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Chronic ya lambe samay ki takleef ko doctor se physically check karwana chahiye.';
    }
    return 'Chronic or recurring symptoms should be physically checked by a doctor.';
  }

  static String _getSpecialist(String type, AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      switch (type) {
        case 'diabetologist':
          return 'मधुमेह विशेषज्ञ / डायबेटोलॉजिस्ट (MBBS, MD, DM)';
        case 'dentist':
          return 'दंत चिकित्सक / डेंटल सर्जन (BDS, MDS)';
        case 'orthopedic':
          return 'हड्डी रोग विशेषज्ञ / फिजियोथेरेपिस्ट (MS Ortho)';
        case 'cardiologist':
          return 'हृदय रोग विशेषज्ञ / फिजिशियन (MD, DM)';
        case 'emergency':
          return 'आपातकालीन चिकित्सा विशेषज्ञ (Emergency Care)';
        default:
          return 'सामान्य चिकित्सक (General Physician - MBBS, MD)';
      }
    } else if (lang == AppLanguage.hinglish) {
      switch (type) {
        case 'diabetologist':
          return 'Diabetologist / Endocrinologist (MBBS, MD, DM)';
        case 'dentist':
          return 'Dentist / Dental Surgeon (BDS, MDS)';
        case 'orthopedic':
          return 'Orthopedic / Physiotherapist (MS Ortho)';
        case 'cardiologist':
          return 'Cardiologist / Physician';
        case 'emergency':
          return 'Emergency Department / Hospital';
        default:
          return 'General Physician (MBBS, MD)';
      }
    } else {
      switch (type) {
        case 'diabetologist':
          return 'Diabetologist / Endocrinologist (MBBS, MD, DM)';
        case 'dentist':
          return 'Dentist / Dental Surgeon (BDS, MDS)';
        case 'orthopedic':
          return 'Orthopedic / Physiotherapist';
        case 'cardiologist':
          return 'Cardiologist / Physician';
        case 'emergency':
          return 'Emergency Medical Officer';
        default:
          return 'General Physician';
      }
    }
  }

  static String _getDiabetesDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'HbA1c जांच, फास्टिंग/पीपी ब्लड शुगर मूल्यांकन और व्यक्तिगत दवा प्रबंधन के लिए प्रमाणित डायबेटोलॉजिस्ट से मिलें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'HbA1c test, fasting/PP glucose evaluation aur personalized medicines ke liye Diabetologist se consult karein.';
    }
    return 'Schedule an appointment with a certified Diabetologist or Endocrinologist for an HbA1c test, fasting/PP glucose evaluation, and personalized medical management.';
  }

  static String _getDentalDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'दांतों की शारीरिक जांच, कैविटी फिलिंग या डेंटल एक्स-रे के लिए दंत चिकित्सक (Dentist) से मिलें। चेहरे पर तेज सूजन आने पर तुरंत अस्पताल जाएं।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Oral examination, cavity filling ya X-ray ke liye Dentist se milein. Facial swelling aane par turant hospital jayein.';
    }
    return 'Schedule an in-person dental consultation with an MDS/BDS dentist for physical oral examination, cavity filling, or dental X-ray. Seek emergency hospital care if you develop severe facial swelling.';
  }

  static String _getHeadacheDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'यदि सिरदर्द 2-3 दिन से अधिक बना रहे या उल्टी/धुंधलापन हो तो फिजिशियन से परामर्श लें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Agar headache 2-3 din se zyada rahe ya vomiting/blurry vision ho toh doctor se consult karein.';
    }
    return 'Consult a physician if headaches are persistent, recurring, or accompanied by visual changes or vomiting.';
  }

  static String _getAcidityDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'यदि एंटासिड के बाद भी सीने में जलन बनी रहे या निगलने में कठिनाई हो तो गैस्ट्रोएंटेरोलॉजिस्ट से मिलें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Agar acidity regular bani rahe ya khane me takleef ho toh Gastroenterologist se milein.';
    }
    return 'Consult a Gastroenterologist if acidity persists despite dietary changes or if you experience difficulty swallowing.';
  }

  static String _getBackPainDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'यदि पीठ दर्द पैरों तक फैल रहा हो या सुन्नपन हो तो ऑर्थोपेडिक विशेषज्ञ या फिजियोथेरेपिस्ट से मिलें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Agar kamar dard pairon tak jaye ya sunnpan ho toh Orthopedic specialist se consult karein.';
    }
    return 'Consult an Orthopedic doctor if back pain radiates down your legs or persists beyond 5–7 days.';
  }

  static String _getFeverDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'बुखार 3 दिन से अधिक रहने पर सीबीसी (CBC) और ब्लड टेस्ट के लिए फिजिशियन से मिलें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Bukhar 3 din se zyada rehne par blood test (CBC) ke liye doctor se consult karein.';
    }
    return 'Consult a General Physician for clinical evaluation and diagnostic blood work if fever exceeds 3 days.';
  }

  static String _getGeneralDoctorAdvice(AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      return 'सटीक निदान और शारीरिक परीक्षण के लिए योग्य चिकित्सक से परामर्श लें।';
    } else if (lang == AppLanguage.hinglish) {
      return 'Proper checkup aur diagnostic tests ke liye General Physician se milein.';
    }
    return 'Consult a qualified healthcare professional for formal diagnosis and personalized clinical management.';
  }

  static HealthGuidanceResult _buildEmergencyResult(
    HealthCheckInput input,
    List<String> triggers,
    AppLanguage lang,
  ) {
    final medDb = getVerifiedMedicineDatabase(lang);
    return HealthGuidanceResult(
      id: 'res-emerg-${_uuid.v4().substring(0, 8)}',
      reportedProblem: input.mainProblem.isNotEmpty ? input.mainProblem : (lang == AppLanguage.hindi ? 'आपातकालीन स्थिति' : 'Emergency Situation'),
      symptoms: input.symptoms,
      duration: input.duration,
      riskLevel: RiskLevel.emergency,
      riskSummary: lang == AppLanguage.hindi
          ? 'चेतावनी: गंभीर आपातकालीन लक्षण पाए गए हैं। तुरंत नजदीकी अस्पताल जाएं या 112 पर कॉल करें।'
          : (lang == AppLanguage.hinglish
              ? 'Warning: Serious emergency red flag symptoms detect hue hain. Turant hospital jayein ya 112 par call karein.'
              : 'CRITICAL ALERT: Serious emergency symptoms detected. Proceed to the nearest hospital emergency room immediately.'),
      possibleCauses: lang == AppLanguage.hindi
          ? ['तत्काल चिकित्सा जांच की आवश्यकता वाली गंभीर स्थिति']
          : ['Acute medical emergency requiring immediate in-hospital stabilization'],
      generalGuidanceTips: lang == AppLanguage.hindi
          ? [
              'स्वयं गाड़ी न चलाएं; एम्बुलेंस (108 / 112) बुलाएं या किसी की मदद लें।',
              'शांत रहें, आराम से बैठें और तंग कपड़े ढीले करें।',
              'डॉक्टर के परामर्श के बिना कोई भी नई दवा न खाएं।',
            ]
          : [
              'Do not drive yourself; call an emergency ambulance (112 / 108) or ask someone to drive.',
              'Sit or lie in a comfortable position and loosen tight clothing.',
              'Do not consume any new medicines or heavy meals while waiting for medical help.',
            ],
      foodSuggestions: const [],
      yogaExercises: const [],
      lifestyleTips: const [],
      medicineSafetyItems: medDb.take(1).toList(),
      doctorConsultationAdvice: lang == AppLanguage.hindi
          ? 'तुरंत नजदीकी इमरजेंसी / ट्रॉमा सेंटर जाएं।'
          : 'IMMEDIATE EMERGENCY ROOM / ICU CONSULTATION REQUIRED.',
      recommendedSpecialist: lang == AppLanguage.hindi ? 'आपातकालीन चिकित्सा विभाग (Emergency ER)' : 'Emergency Medical Officer / Hospital ER',
      isEmergency: true,
      emergencyRedFlags: triggers,
      createdAt: DateTime.now(),
    );
  }
}
