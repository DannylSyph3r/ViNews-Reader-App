import 'package:vinews_news_reader/utils/vinews_images_path.dart';

class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({required this.image, required this.title, required this.description});
}

List<UnboardingContent> pageContents = [
  UnboardingContent(
    image: ViNewsAppImagesPath.onboardScreenImageOne,
    title: "Get The Latest News headlines and Updates to Read Anytime and Anywhere!",
    description: "Stay informed with the most up-to-date news from around the world. Our app delivers breaking headlines and updates straight to your device, ensuring you're always in the know, no matter where you are."
  ),
  UnboardingContent(
    image: ViNewsAppImagesPath.onboardScreenImageTwo,
    title: "Personalize your News feed according to your Preference and Interests!",
    description: "Tailor your news experience to match your interests and preferences. With our app, you're in control. Choose the topics and sources that matter most to you, and enjoy a curated news feed designed just for you."
  ),
  UnboardingContent(
    image: ViNewsAppImagesPath.onboardScreenImageThree,
    title: "Save and share Captivating stories and Articles with your friends!",
    description: "Discover interesting stories and easily save them to your collection. Plus, share captivating articles with your friends and family effortlessly, fostering discussions and staying connected through the power of news."
  ),
];