import 'package:flutter/material.dart';

//Colors
const Color secondaryColor = Color(0xFFFF3181);


//Base Url
const String baseURl = "https://us-central1-only-u-48058.cloudfunctions.net/api";
const String postsLike = "/posts/like";

//Text Styles
const redHeadingStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: secondaryColor, // secondary color
  fontFamily: 'Rubik',
);

const whiteSubHeadingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontFamily: 'Rubic',
);

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
