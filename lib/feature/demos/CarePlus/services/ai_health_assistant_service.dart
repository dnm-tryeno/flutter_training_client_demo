import 'package:uuid/uuid.dart';
import '../models/ai_chat_message.dart';
import '../localization/app_language.dart';

class AIHealthAssistantService {
  static const _uuid = Uuid();

  static List<AIChatMessage> getInitialMessages(AppLanguage language) {
    String welcome;
    switch (language) {
      case AppLanguage.hinglish:
        welcome =
            'Namaste! Main CarePlus AI hoon — aapka health guidance companion.\n\nAap mujhse food, diet, safe exercises, lifestyle tips ya medicine safety ke baare me pooch sakte hain. Main aapko simple aur safe educational guidance doonga.\n\n*(Dhyan dein: Main doctor nahi hoon aur prescription nahi deta).*';
        break;
      case AppLanguage.hindi:
        welcome =
            'नमस्ते! मैं CarePlus AI हूँ — आपका स्वास्थ्य साथी।\n\nआप मुझसे आहार, सुरक्षित व्यायाम, जीवनशैली सुझाव या दवा सुरक्षा के बारे में पूछ सकते हैं।\n\n*(कृपया ध्यान दें: मैं कोई डॉक्टर नहीं हूँ और दवा का नुस्खा नहीं देता)।*';
        break;
      case AppLanguage.english:
        welcome =
            'Hello! I am CarePlus AI — your health guidance companion.\n\nYou can ask me about nutrition, gentle exercises, lifestyle habits, or general medicine safety precautions.\n\n*(Please note: I provide general educational guidance and cannot prescribe medicines or diagnose conditions).*';
        break;
    }

    return [
      AIChatMessage(
        id: 'msg-welcome',
        text: welcome,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        quickOptions: language == AppLanguage.hinglish
            ? [
                'Mujhe acidity hai, kya khana chahiye?',
                'Mere sir me dard hai, kya karun?',
                'Kaunsi exercise safe ho sakti hai?',
                'Paracetamol ke side effects kya hain?',
              ]
            : language == AppLanguage.hindi
                ? [
                    'एसिडिटी में क्या खाना चाहिए?',
                    'सिरदर्द के सुरक्षित उपाय?',
                    'कमर दर्द में कौन सा योग करें?',
                    'पैरासिटामोल के सामान्य दुष्प्रभाव?',
                  ]
                : [
                    'What should I eat for acidity?',
                    'Gentle remedies for headache',
                    'Safe exercises for back stiffness',
                    'General safety precautions for Paracetamol',
                  ],
      ),
    ];
  }

  static AIChatMessage processUserQuery(String query, AppLanguage language) {
    final lower = query.toLowerCase().trim();
    final isHinglish = language == AppLanguage.hinglish;
    final isHindi = language == AppLanguage.hindi;

    // 1. Emergency Red-flag Triage
    if (lower.contains('chest pain') ||
        lower.contains('chhati me dard') ||
        lower.contains('seene me dard') ||
        lower.contains('difficulty breathing') ||
        lower.contains('saans lene me takleef') ||
        lower.contains('unconscious') ||
        lower.contains('behosh') ||
        lower.contains('paralysis') ||
        lower.contains('heavy bleeding') ||
        lower.contains('stroke')) {
      final text = isHinglish
          ? '🚨 **EMERGENCY WARNING!**\n\nAapne jo lakshan bataye hain, ye gambhir medical emergency ho sakti hai.\n\n1. Turant kisi emergency doctor ya hospital se contact karein.\n2. **112 / 108 emergency helpline** par call karein.\n3. Ghar par khud se koi medicine na lein aur akele na rahein.'
          : isHindi
              ? '🚨 **आपातकालीन चेतावनी!**\n\nये लक्षण गंभीर चिकित्सीय स्थिति का संकेत हो सकते हैं।\n\n1. तुरंत निकटतम अस्पताल या डॉक्टर से संपर्क करें।\n2. **112 / 108 हेल्पलाइन** पर तुरंत कॉल करें।\n3. बिना डॉक्टरी सलाह के कोई दवा न लें।'
              : '🚨 **EMERGENCY MEDICAL ALERT!**\n\nThe symptoms described may indicate a critical medical emergency requiring urgent intervention.\n\n1. Please call emergency services (**112 / 108 / 911**) immediately.\n2. Proceed to the nearest hospital emergency room without delay.\n3. Do not attempt self-medication at home.';

      return AIChatMessage(
        id: 'msg-${_uuid.v4().substring(0, 8)}',
        text: text,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        isEmergencyAlert: true,
        disclaimer: 'Seek immediate professional emergency medical care.',
        quickOptions: ['Emergency Call (112)', 'Find Nearest Hospital'],
      );
    }

    // 2. Acidity / Stomach Issues
    if (lower.contains('acidity') ||
        lower.contains('pet me dard') ||
        lower.contains('gas') ||
        lower.contains('heartburn') ||
        lower.contains('indigestion') ||
        lower.contains('khana') && lower.contains('acid')) {
      final text = isHinglish
          ? '🌿 **Acidity ke liye General Guidance & Food Tips:**\n\n• **Kya Khayein:** Thanda doodh (agar lactose allergy na ho), paka kela, nariyal paani, daliya, saunf ka paani aur oatmeal.\n• **Parhez Karein:** Zyada mirch-masala, deep-fried snacks (samosa, pakoda), chai, coffee aur cold drinks.\n• **Lifestyle Tip:** Khana khane ke baad turant bistar par na leetein; 10-15 minute walk karein ya Vajrasana me 5 minute baithein.\n\n⚠️ *Agar acidity ke saath chhati me bhaari-pan ya saans lene me dikkat ho, to turant doctor se janch karwayein.*'
          : isHindi
              ? '🌿 **एसिडिटी के लिए आहार और जीवनशैली सुझाव:**\n\n• **क्या खाएं:** ठंडा दूध, पका केला, नारियल पानी, हल्का दलिया, सौंफ का पानी।\n• **परहेज करें:** ज्यादा तला-भुना, अत्यधिक मिर्च-मसालेदार भोजन, चाय, कॉफी और कोल्ड ड्रिंक्स।\n• **सलाह:** भोजन के तुरंत बाद न लेटें; 15 मिनट टहलें या वज्रासन में बैठें।\n\n⚠️ *लगातार समस्या होने पर योग्य डॉक्टर से परामर्श लें।*'
              : '🌿 **Dietary & Lifestyle Guidance for Acidity/Reflux:**\n\n• **Recommended:** Cold milk (if lactose-tolerant), ripe bananas, coconut water, oatmeal, and fennel tea.\n• **Foods to Avoid:** Deep-fried items, heavy spicy curries, citrus fruits on empty stomach, and excess caffeine/sodas.\n• **Habit:** Avoid lying flat for 2–3 hours after meals. Eat smaller, regular meals.\n\n⚠️ *Consult a doctor if symptoms persist or radiate to the chest/arm.*';

      return AIChatMessage(
        id: 'msg-${_uuid.v4().substring(0, 8)}',
        text: text,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        quickOptions: isHinglish
            ? ['Vajrasana kaise karein?', 'Antacid kab lena chahiye?', 'Doctor kab dikhayein?']
            : ['Yoga for Digestion', 'Medicine Precautions', 'Talk to Doctor'],
      );
    }

    // 3. Headache
    if (lower.contains('headache') || lower.contains('sir dard') || lower.contains('sar dard') || lower.contains('migraine')) {
      final text = isHinglish
          ? '💆 **Sir Dard (Headache) ke liye Supportive Care:**\n\n• **Turant Aaram:** Shant aur kam roshni wale kamre me 20-30 minute rest karein.\n• **Hydration:** 1-2 glass taaza paani dhire-dhire piyein. Aksar paani ki kami se sir dard hota hai.\n• **Gentle Breathing:** Anulom-Vilom pranayama 5-8 minute karein aur screen (mobile/laptop) se door rahein.\n\n⚠️ *Zaroori Note: Agar sir dard achanak bohot tez ho, ulti aaye ya gardan me jakdan ho, to turant doctor se consult karein.*'
          : isHindi
              ? '💆 **सिरदर्द के लिए सामान्य देखभाल सुझाव:**\n\n• **आराम:** शांत और कम रोशनी वाले कमरे में विश्राम करें।\n• **जलपान:** पर्याप्त पानी पिएं क्योंकि निर्जलीकरण से भी सिरदर्द होता है।\n• **प्राणायाम:** 5 मिनट अनुलोम-विलोम करें और मोबाइल स्क्रीन से दूरी बनाएं।\n\n⚠️ *यदि सिरदर्द अत्यंत तीव्र हो, तो तुरंत चिकित्सक से संपर्क करें।*'
              : '💆 **Supportive Self-Care for Headache:**\n\n• **Rest:** Lie down in a quiet, dimly lit room.\n• **Hydration:** Sip a large glass of clean water slowly (dehydration is a frequent cause).\n• **Relaxation:** Take a break from digital screens; practice 5 minutes of gentle diaphragmatic breathing.\n\n⚠️ *Seek immediate medical evaluation if the headache is severe and sudden, or accompanied by stiff neck, fever, or vision changes.*';

      return AIChatMessage(
        id: 'msg-${_uuid.v4().substring(0, 8)}',
        text: text,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        quickOptions: isHinglish
            ? ['Paracetamol safety rule?', 'Neck stretch kaise karein?', 'Health check start karein']
            : ['Medicine Safety', 'Neck Stretches', 'Full Health Check'],
      );
    }

    // 4. Exercise / Yoga safe guidance
    if (lower.contains('exercise') || lower.contains('yoga') || lower.contains('kasrat') || lower.contains('back pain') || lower.contains('kamar')) {
      final text = isHinglish
          ? '🧘 **Safe Yoga & Exercise Guidelines:**\n\n• **Kamar Dard (Back Stiffness):** Cat-Cow stretch (Marjaryasana), Bhujangasana (gentle cobra pose) aur halki walking safe rehti hai.\n• **Niyam:** Koi bhi aasan karte waqt jhatka na dein aur dard mehsoos hote hi ruk jayein.\n• **Khayal Rakhein:** Agar pregnancy ya severe slip-disc ho, to bina certified trainer/doctor ki salah ke aasan na karein.\n\nRozana 20-30 minute walk karna sabse safe aur effective exercise hai.'
          : isHindi
              ? '🧘 **सुरक्षित योग और व्यायाम के दिशानिर्देश:**\n\n• **कमर दर्द:** मार्जरी-बिटिलासन (Cat-Cow) और भुजंगासन का सौम्य अभ्यास लाभदायक है।\n• **सावधानी:** किसी भी खिंचाव में झटका न दें। तेज दर्द होने पर तुरंत रुकें।\n• **नियम:** गर्भावस्था या पुरानी रीढ़ की समस्या में डॉक्टर की सलाह आवश्यक है।'
              : '🧘 **Safe Yoga & Activity Guidelines:**\n\n• **For Back Support:** Gentle Cat-Cow stretches, mild extension, and 20–30 minutes of low-impact walking.\n• **Golden Rule:** Never push through sharp pain or bounce during stretches.\n• **Caution:** If pregnant or managing chronic spinal conditions, practice only under qualified medical/physiotherapy guidance.';

      return AIChatMessage(
        id: 'msg-${_uuid.v4().substring(0, 8)}',
        text: text,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        quickOptions: isHinglish ? ['Food suggestions?', 'Check My Health'] : ['Food Suggestions', 'Check My Health'],
      );
    }

    // 5. Medicine Safety / Side Effects query
    if (lower.contains('medicine') || lower.contains('dawa') || lower.contains('paracetamol') || lower.contains('side effect') || lower.contains('dose')) {
      final text = isHinglish
          ? '💊 **Medicine Safety & General Guidelines:**\n\n• **Over-the-Counter Care:** Paracetamol mild fever ya body ache me commonly use hoti hai, par iska over-use liver ke liye harmful hota hai.\n• **Khana ke saath:** Jyadatar medicines ko khali pet lene se bachein (jab tak doctor na kahe).\n• **Crucial Rule:** CarePlus exact dosage ya prescription recommend nahi karta. Kisi bhi dawa ko lene se pehle pharmacist ya doctor se confirm karein.\n\n⚠️ *Prescription medicines ko doctor ki permission ke bina band ya modify na karein.*'
          : isHindi
              ? '💊 **दवा सुरक्षा और सामान्य जानकारी:**\n\n• **सावधानी:** कभी भी स्वयं से दवाओं की अधिक खुराक न लें।\n• **दवा लेने का नियम:** अधिकांश दवाएं भोजन के बाद ही लें (जब तक चिकित्सक अलग निर्देश न दें)।\n• **महत्वपूर्ण:** हम कोई दवा का पर्चा (Prescription) नहीं देते। कृपया डॉक्टर या फार्मासिस्ट से परामर्श लें।'
              : '💊 **Educational Medicine Safety Principles:**\n\n• **Dosing Caution:** Always follow official product labels or a doctor’s exact written prescription. Never double dose.\n• **Interactions:** Inform your pharmacist of all existing supplements or chronic medicines you take.\n• **Mandatory Rule:** CarePlus is an educational tool and does not prescribe medicines or determine dosages.\n\n⚠️ *Always consult a registered physician or licensed pharmacist.*';

      return AIChatMessage(
        id: 'msg-${_uuid.v4().substring(0, 8)}',
        text: text,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        quickOptions: isHinglish
            ? ['Medicine Safety Directory dekhein', 'Doctor consultation book karein']
            : ['View Medicine Safety Directory', 'Book Doctor Consult'],
      );
    }

    // Default conversational response with clarifying question
    final defaultResponse = isHinglish
        ? 'Aapne jo bataya hai, use samajhne ke liye kripya kuch aur details dein:\n\n1. Ye dikkat kab se ho rahi hai?\n2. Iske saath fever, ulti ya koi aur lakshan bhi hai?\n\nAap "Check My Health" button dabakar complete personalized report bhi pa sakte hain!'
        : isHindi
            ? 'आपकी समस्या को बेहतर समझने के लिए कृपया कुछ और विवरण बताएं:\n\n1. यह समस्या कितने दिनों से है?\n2. क्या इसके साथ बुखार, चक्कर या दर्द भी है?\n\nआप "स्वास्थ्य जांचें" बटन दबाकर संपूर्ण मार्गदर्शन प्राप्त कर सकते हैं।'
            : 'To offer more accurate supportive guidance, could you share a bit more context?\n\n1. How long have you been experiencing this?\n2. Are there any other symptoms like fever, nausea, or dizziness?\n\nYou can also tap "Check My Health" to generate a complete personalized report!';

    return AIChatMessage(
      id: 'msg-${_uuid.v4().substring(0, 8)}',
      text: defaultResponse,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      quickOptions: isHinglish
          ? ['Check My Health Start Karein', 'Food Guidance', 'Yoga Tips']
          : ['Start Health Check', 'Food Guidance', 'Yoga Tips'],
    );
  }
}
