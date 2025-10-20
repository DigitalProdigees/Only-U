import 'package:flutter/material.dart';

//Colors
const Color secondaryColor = Color(0xFFFF3181);

//Base Url
const String baseURl =
    "https://us-central1-only-u-48058.cloudfunctions.net/api";
const String postsLike = "/posts/like";

//Text Styles
const redHeadingStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: secondaryColor, // secondary color
  fontFamily: 'Avenir',
);

const whiteSubHeadingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontFamily: 'Avenir',
);

const normalBodyStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Avenir',
);

// Dummy Data Models

//Categories
const categories = [
  {
    "id": "JuqjwnzTRo6B3r3g1eeH",
    "name": "Woman",
    "imageUrl": "example.com/uikklhiiik.png",
    "createdAt": {"_seconds": 1759449927, "_nanoseconds": 411000000},
    "updatedAt": {"_seconds": 1759449927, "_nanoseconds": 411000000},
  },
  {
    "id": "WU66XziFWsUMZCOJuvMO",
    "name": "Forest",
    "imageUrl": "example.com/uikklhiiik.png",
    "createdAt": {"_seconds": 1759449954, "_nanoseconds": 169000000},
    "updatedAt": {"_seconds": 1759449954, "_nanoseconds": 169000000},
  },
  {
    "id": "F8v8wV5ZeiVgIM2Hqjbh",
    "name": "Shoes",
    "imageUrl": "example.com/uikklhiiik.png",
    "createdAt": {"_seconds": 1759449933, "_nanoseconds": 998000000},
    "updatedAt": {"_seconds": 1759449933, "_nanoseconds": 998000000},
  },

  {
    "id": "KmExkKet0T7EObmcgSvn",
    "name": "Man",
    "imageUrl": "example.com/uikklhiiik.png",
    "createdAt": {"_seconds": 1759449921, "_nanoseconds": 667000000},
    "updatedAt": {"_seconds": 1759449921, "_nanoseconds": 667000000},
  },
  {
    "id": "fgxf8wg13VPznRdWMLDl",
    "name": "Kids",
    "imageUrl": "example.com/uikklhiiik.png",
    "createdAt": {"_seconds": 1759449844, "_nanoseconds": 12000000},
    "updatedAt": {"_seconds": 1759449844, "_nanoseconds": 12000000},
  },
];

const postModel = {
  "id": "postId", // unique post identifier
  "user": {
    "id": "userId",
    "name": "John Doe",
    "username": "userName",
    "avatar": "avatarUrl",
  },
  "media": [
    {
      "type": "image", // image | video | text | audio | poll
      "url": "https://example.com/media.jpg",
      "thumbnail": "https://example.com/thumb.jpg", // for videos/images
      "duration": 15, // optional, for video/audio
    },
  ],
  "description": "this is a post description",
  "tags": ["flutter", "firebase"], // hashtags or keywords
  "mentions": ["userId1", "userId2"], // tagged people
  "location": {"name": "New York City", "lat": 40.7128, "lng": -74.0060},
  "likesCount": 120,
  "commentsCount": 30,
  "sharesCount": 10,
  "likedBy": ["userId1", "userId2"], // optional, or fetch separately
  "createdAt": 1682948400, // timestamp
  "updatedAt": 1682952000, // for edits
  "privacy": "public", // public | private | friends
  "status": "active", // active | deleted | reported
};
