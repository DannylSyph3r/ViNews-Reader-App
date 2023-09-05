import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';

class OnboardingPageContent {
  String imagePath;
  String title;
  String description;

  OnboardingPageContent({required this.imagePath, required this.title, required this.description});
}

// Onboard Screen Content
List<OnboardingPageContent> pageContents = [
  OnboardingPageContent(
    imagePath: ViNewsAppImagesPath.onboardScreenImageOne,
    title: ViNewsAppTexts.onboardScreenOneTitleText,
    description: ViNewsAppTexts.onboardScreenOneDescriptionText
  ),
  OnboardingPageContent(
    imagePath: ViNewsAppImagesPath.onboardScreenImageTwo,
    title: ViNewsAppTexts.onboardScreenTwoTitleText,
    description: ViNewsAppTexts.onboardScreenTwoDescriptionText
  ),
  OnboardingPageContent(
    imagePath: ViNewsAppImagesPath.onboardScreenImageThree,
    title: ViNewsAppTexts.onboardScreenThreeTitleText,
    description: ViNewsAppTexts.onboardScreenThreeDescriptionText
  ),
];