import 'package:fashion_store/models/dummy/stories_posts_fake_data.dart';
import 'package:flutter/material.dart';
import '../store/store_photo_model.dart';
import '../store/store_products_model.dart';
import '../store/store_reel_model.dart';
import '../store/store_review_model.dart';
import '../store/store_upper_model.dart';
import '../store/store_who_am_i_model.dart';

final StoreReelModel fakeReels = StoreReelModel(
  videos: [
    Video(
      id: "reel_1",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      thumbnailUrl: "https://picsum.photos/id/1011/800/1200",
    ),
    Video(
      id: "reel_2",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      thumbnailUrl: "https://picsum.photos/id/1012/800/1200",
    ),
    Video(
      id: "reel_3",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      thumbnailUrl: "https://picsum.photos/id/1013/800/1200",
    ),
  ],
);

final StorePhotoModel fakeStorePhotos = StorePhotoModel(
  images: [
    Photo(
      id: "photo_1",
      url: "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
    ),
    Photo(
      id: "photo_2",
      url: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
    ),
    Photo(
      id: "photo_3",
      url: "https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a",
    ),
    Photo(
      id: "photo_4",
      url: "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f",
    ),
  ],
);

final StoreProductsModel fakeProducts = StoreProductsModel(
  products: [
    Product(
      id: "product_1",
      name: "Classic Denim Jacket",
      description: "Premium blue denim jacket with a modern fit.",
      price: 89.99,
      imageUrl: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      preparationTime: "Available now",
      isLiked: true,
      store: storesInfo[0],
      sizes: const ["S", "M", "L", "XL"],
      colors: const [
        Colors.blue,
        Colors.black,
        Colors.grey,
      ],
      category: Category(
        id: "cat_1",
        name: "Jackets",
        description: "Stylish jackets for all seasons",
        imageUrl:
        "https://images.unsplash.com/photo-1520975661595-6453be3f7070",
      ),
    ),
    Product(
      id: "product_2",
      name: "Slim Fit Black Jeans",
      description: "Comfortable stretch denim with a slim silhouette.",
      price: 69.50,
      imageUrl: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246",
      preparationTime: "Available now",
      isLiked: false,
      store: storesInfo[2],
      sizes: const ["30", "32", "34", "36", "38"],
      colors: const [
        Colors.black,
        Colors.blue,
      ],
      category: Category(
        id: "cat_2",
        name: "Jeans",
        description: "Premium denim collection",
        imageUrl:
        "https://images.unsplash.com/photo-1475180098004-ca77a66827be",
      ),
    ),
    Product(
      id: "product_3",
      name: "Oversized Hoodie",
      description: "Soft cotton hoodie perfect for casual outfits.",
      price: 54.99,
      imageUrl: "https://images.unsplash.com/photo-1556906781-9a412961c28c",
      preparationTime: "Available now",
      isLiked: true,
      store: storesInfo[1],
      sizes: const ["S", "M", "L", "XL", "XXL"],
      colors: const [
        Colors.black,
        Colors.white,
        Colors.red,
        Colors.green,
      ],
      category: Category(
        id: "cat_3",
        name: "Hoodies",
        description: "Comfortable streetwear hoodies",
        imageUrl:
        "https://images.unsplash.com/photo-1551028719-00167b16eac5",
      ),
    ),
  ],
);
final stores = [
  StoreWhoAmIModel(
    id: "store_1",
    name: "Velvet Vogue",
    description:
        "Velvet Vogue is a premium fashion boutique offering modern streetwear and elegant outfits designed for confident individuals.",
    logoUrl: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
    workingHours: "10:00 AM - 9:00 PM",
  ),
  StoreWhoAmIModel(
    id: "store_3",
    name: "Adidas",
    description:
        "Adidas is a premium fashion boutique offering modern streetwear and elegant outfits designed for confident individuals.",
    logoUrl: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
    workingHours: "10:00 AM - 9:00 PM",
  ),
  StoreWhoAmIModel(
    id: "store_2",
    name: "Velvet Vogue 2",
    description:
        "Velvet Vogue is a premium fashion boutique offering modern streetwear and elegant outfits designed for confident individuals.",
    logoUrl: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
    workingHours: "10:00 AM - 9:00 PM",
  ),
];

final StoreWhoAmIModel fakeStoreInfo = StoreWhoAmIModel(
  id: "store_1",
  name: "Velvet Vogue",
  description:
      "Velvet Vogue is a premium fashion boutique offering modern streetwear and elegant outfits designed for confident individuals.",
  logoUrl: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
  mainImage: "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
  workingHours: "10:00 AM - 9:00 PM",
  country: Categories(
    id: "country_1",
    name: "Italy",
    image: "https://flagcdn.com/w320/it.png",
  ),
  categories: Categories(
    id: "fashion_cat",
    name: "Streetwear & Casual Fashion",
    image: "https://images.unsplash.com/photo-1483985988355-763728e1935b",
  ),
);

final StoreUpperModel fakeStoreHeader = StoreUpperModel(
  id: "store_1",
  name: "Velvet Vogue",
  profileImage: "https://images.unsplash.com/photo-1521335629791-ce4aec67dd53",
  rating: 4.8,
  followersCount: 12450,
  isFollowed: true,
  userId: "owner_1",
);

final StoreReviewModel fakeReviews = StoreReviewModel(
  avgRating: 4.7,
  totalReviewers: 128,
  reviews: [
    Review(
      id: "review_1",
      score: 5,
      comment: "Amazing quality clothes! The denim jacket fits perfectly.",
      timeAgo: "2 days ago",
      image: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      user: User(
        id: "user_1",
        name: "Emily Carter",
        profilePicture: "https://randomuser.me/api/portraits/women/44.jpg",
      ),
    ),
    Review(
      id: "review_2",
      score: 4.5,
      comment: "Great store with modern streetwear. Highly recommend.",
      timeAgo: "1 week ago",
      user: User(
        id: "user_2",
        name: "Daniel Brown",
        profilePicture: "https://randomuser.me/api/portraits/men/32.jpg",
      ),
    ),
    Review(
      id: "review_3",
      score: 4,
      comment: "Nice variety of fashion pieces and good prices.",
      timeAgo: "3 weeks ago",
      user: User(
        id: "user_3",
        name: "Sophia Martinez",
        profilePicture: "https://randomuser.me/api/portraits/women/68.jpg",
      ),
    ),
  ],
);

final List<Category> categories = [
  Category(
    id: "cat_1",
    name: "Jackets",
    description: "Stylish jackets for all seasons",
    imageUrl: "https://images.unsplash.com/photo-1520975661595-6453be3f7070",
  ),
  Category(
    id: "cat_2",
    name: "Jeans",
    description: "Premium denim collection",
    imageUrl: "https://images.unsplash.com/photo-1475180098004-ca77a66827be",
  ),
  Category(
    id: "cat_3",
    name: "Hoodies",
    description: "Comfortable streetwear hoodies",
    imageUrl: "https://images.unsplash.com/photo-1551028719-00167b16eac5",
  ),
];
