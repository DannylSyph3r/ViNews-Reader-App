import 'dart:math';

class ArticleSelections {
  final String urlImage;
  final String articleTitle;
  final String articleDescription;
  final String articleSource;
  final String articleCategory;
  final DateTime articlePublicationDate;

  ArticleSelections({
    required this.urlImage,
    required this.articleTitle,
    required this.articleDescription,
    required this.articleSource,
    required this.articleCategory,
    required this.articlePublicationDate,
  });
}

List<ArticleSelections> articleDisplayList = [
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/8721318/pexels-photo-8721318.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Major Technological Breakthroughs in the Field of Artificial Intelligence",
    articleDescription:
        "The field of artificial intelligence (AI) is experiencing a wave of groundbreaking developments. From advanced machine learning algorithms to the rise of neural networks, AI is reshaping industries and opening new possibilities.",
    articleSource: "Tech News",
    articleCategory: "Technology",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/210607/pexels-photo-210607.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Global Economic Trends: A Detailed Analysis of Positive Growth",
    articleDescription:
        "A comprehensive analysis of global economic trends reveals a sustained period of positive growth. This report examines the factors contributing to the economic upturn and discusses its implications for businesses worldwide.",
    articleSource: "Business Insights",
    articleCategory: "Business",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/276015/pexels-photo-276015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Blockbuster Movie Premiere: Hollywood's Most Anticipated Film",
    articleDescription:
        "The highly anticipated blockbuster film of the year has made its grand debut in Hollywood. Audiences can expect a cinematic masterpiece filled with mesmerizing performances and cutting-edge special effects.",
    articleSource: "Entertainment Weekly",
    articleCategory: "Entertainment",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/4021775/pexels-photo-4021775.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Medical Research Revolution: Paving the Way for Healthier Lives",
    articleDescription:
        "Recent breakthroughs in medical research are transforming healthcare as we know it. These advancements offer new hope for patients and promise to address some of the most challenging health issues facing humanity.",
    articleSource: "Health Matters",
    articleCategory: "Health",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/2229887/pexels-photo-2229887.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Global Climate Summit: World Leaders Tackle Climate Change Head-On",
    articleDescription:
        "Leaders from around the world have come together to address the urgent issue of climate change. This global initiative aims to reduce greenhouse gas emissions, protect ecosystems, and secure a sustainable future for all.",
    articleSource: "Political News Network",
    articleCategory: "Politics",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/7671957/pexels-photo-7671957.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Frontiers of Space Exploration: New Discoveries Beyond Our Imagination",
    articleDescription:
        "The exploration of the cosmos continues to yield remarkable discoveries. Scientists are uncovering new planets, observing celestial phenomena, and expanding our knowledge of the universe. These findings inspire wonder and curiosity.",
    articleSource: "Space Insights",
    articleCategory: "Science",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/1627960/pexels-photo-1627960.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle: "Soccer Triumph: Local Team Secures Championship Victory",
    articleDescription:
        "In a thrilling championship match, the local soccer team emerged as champions. Fans celebrated the team's exceptional teamwork and skill on the field. This victory marks a historic achievement for the club.",
    articleSource: "Sports Highlights",
    articleCategory: "Sports",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/5945962/pexels-photo-5945962.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Global Gastronomic Delight: Highlights from the International Food Festival",
    articleDescription:
        "Food enthusiasts from across the globe gathered at the International Food Festival to savor a diverse array of delectable cuisines. Renowned chefs showcased their culinary talents, creating a feast for the senses.",
    articleSource: "Foodie Chronicles",
    articleCategory: "Food",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/3976320/pexels-photo-3976320.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Clean Energy Revolution: Advancements in Renewable Power Sources",
    articleDescription:
        "The clean energy revolution continues to gain momentum with innovative technologies. Solar and wind power projects are expanding, reducing our reliance on fossil fuels. These advancements play a vital role in combating climate change.",
    articleSource: "EcoTech Today",
    articleCategory: "Environment",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/4427626/pexels-photo-4427626.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Global Diplomatic Efforts: World Leaders Collaborate for Lasting Peace",
    articleDescription:
        "World leaders have united to promote diplomacy and peace on the international stage. Through diplomatic talks and collaborative efforts, they aim to resolve conflicts and build a more peaceful world for future generations.",
    articleSource: "World News",
    articleCategory: "World",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/1851481/pexels-photo-1851481.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle: "Travel Innovation: Exploring the Latest Trends in Tourism",
    articleDescription:
        "The tourism industry is experiencing a wave of innovation, enhancing the travel experience. From virtual tours to eco-friendly accommodations, these developments cater to the evolving needs of modern tourists. Discover the future of travel.",
    articleSource: "Traveler's Gazette",
    articleCategory: "Tourism",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/356040/pexels-photo-356040.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Scientific Advancements: Unveiling the Latest Breakthroughs in Research",
    articleDescription:
        "Researchers are making remarkable strides in various fields, from medicine to technology. Their groundbreaking discoveries are reshaping industries and improving lives. Stay updated on the latest scientific breakthroughs shaping our future.",
    articleSource: "Research Insights",
    articleCategory: "Science",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/699122/pexels-photo-699122.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Tech Trends of Tomorrow: A Glimpse into Future Technology Innovations",
    articleDescription:
        "The world of technology is evolving rapidly, with exciting trends on the horizon. From artificial intelligence to virtual reality, these innovations will revolutionize how we live and work. Stay informed about the tech trends shaping our future.",
    articleSource: "Tech Innovations",
    articleCategory: "Technology",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/3856050/pexels-photo-3856050.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle: "Global News Roundup: Top Stories Making Headlines Worldwide",
    articleDescription:
        "Get an in-depth look at the top news stories capturing global attention. From significant global events to local developments, stay informed about the latest happenings that impact our world. Connect with the world through our top news coverage.",
    articleSource: "Global Insights",
    articleCategory: "Top News",
    articlePublicationDate: getRandomDate(),
  ),
  ArticleSelections(
    urlImage:
        "https://images.pexels.com/photos/1390403/pexels-photo-1390403.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    articleTitle:
        "Holistic Health and Wellness: Expert Tips for a Fulfilling Life",
    articleDescription:
        "Explore valuable health and wellness tips designed to help you lead a happier and healthier life. From nutrition guidance to fitness routines, our experts share insights to empower you in making positive lifestyle choices. Prioritize your well-being with our comprehensive wellness advice.",
    articleSource: "Healthy Living",
    articleCategory: "Health",
    articlePublicationDate: getRandomDate(),
  ),
];

// Function to generate a random date within the last year
DateTime getRandomDate() {
  final random = Random();
  final now = DateTime.now();
  final oneYearAgo = now.subtract(const Duration(days: 365));
  final randomDate = oneYearAgo.add(Duration(days: random.nextInt(365)));
  return randomDate;
}
