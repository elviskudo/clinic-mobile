import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AboutAppController extends GetxController {
  final supabase = Supabase.instance.client;
  final aboutContent = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAboutContent();
  }

// ... existing code ...

  Future<void> getAboutContent() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('abouts')
          .select('en_body')
          .order('id', ascending: true)
          .single();

      aboutContent.value = '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body {
                font-family: 'Segoe UI', Arial, sans-serif;
                padding: 20px;
                line-height: 1.6;
                color: #2c3e50;
                background-color: #f8f9fa;
                max-width: 800px;
                margin: 0 auto;
              }
              h2 {
                color: #2c3e50;
                text-align: center;
                margin: 24px 0;
                font-size: 28px;
                border-bottom: 2px solid #3498db;
                padding-bottom: 10px;
              }
              h3 {
                color: #2980b9;
                margin: 20px 0;
                font-size: 22px;
              }
              p {
                text-align: justify;
                margin: 16px 0;
                font-size: 16px;
              }
              ol {
                padding-left: 20px;
              }
              li {
                margin: 12px 0;
                line-height: 1.5;
              }
              a {
                color: #3498db;
                text-decoration: none;
              }
              a:hover {
                text-decoration: underline;
              }
              .feature-list li {
                background-color: white;
                padding: 12px 15px;
                margin: 8px 0;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                transition: transform 0.2s;
              }
              .feature-list li:hover {
                transform: translateX(5px);
              }
              .team-member {
                background-color: white;
                padding: 15px;
                margin: 10px 0;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
              }
              .contact-info {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                margin: 20px 0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
              }
              .highlight {
                color: #e74c3c;
                font-weight: bold;
              }
            </style>
          </head>
          <body>
            <div class="content">
              ${response['en_body'] as String}
            </div>
            <script>
              // Menambahkan kelas untuk styling
              document.querySelectorAll('ol').forEach((ol, index) => {
                if (index === 0) ol.classList.add('feature-list');
                if (index === 1) ol.classList.add('team-list');
              });
              
              // Membungkus kontak dalam div
              const contactSection = document.querySelector('h3:last-of-type');
              const contactInfo = document.createElement('div');
              contactInfo.className = 'contact-info';
              const contactElements = [];
              let element = contactSection.nextElementSibling;
              while (element && element.tagName === 'P') {
                contactElements.push(element.cloneNode(true));
                element = element.nextElementSibling;
              }
              contactElements.forEach(el => contactInfo.appendChild(el));
              contactSection.parentNode.insertBefore(contactInfo, contactSection.nextSibling);
            </script>
          </body>
        </html>
      ''';
    } catch (e) {
      print('Error: $e');
      aboutContent.value = '<h2>Error loading content</h2>';
    } finally {
      isLoading.value = false;
    }
  }
}
