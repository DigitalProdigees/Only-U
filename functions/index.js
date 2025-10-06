/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { setGlobalOptions } = require("firebase-functions");
const { onRequest } = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

// Init Firebase Admin
admin.initializeApp();
const db = admin.firestore();

// Setup Express
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

/**
 * Create new post
 * POST /createPost
 */
app.post("/createPost", async (req, res) => {
  try {
    const { userId, description, media, tags, mentions, location, privacy } =
      req.body;

    if (!userId || !description) {
      return res
        .status(400)
        .json({ error: "userId and description are required" });
    }

    // Create post object
    const postData = {
      userId,
      description,
      media: media || [],
      tags: tags || [],
      mentions: mentions || [],
      location: location || null,
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      privacy: privacy || "public",
      status: "active",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Save to Firestore
    const postRef = await db.collection("posts").add(postData);

    return res
      .status(201)
      .json({ message: "Post created", postId: postRef.id });
  } catch (error) {
    console.error("Error creating post:", error);
    return res.status(500).json({ error: error.message });
  }
});

app.post("/likePost", async (req, res) => {
  try {
    const { postId, userId } = req.body;

    if (!postId || !userId) {
      return res.status(400).json({ error: "postId and userId are required" });
    }

    const likeRef = db
      .collection("posts")
      .doc(postId)
      .collection("likes")
      .doc(userId); // use userId as docId to prevent duplicate likes

    await likeRef.set({
      userId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // increment counter in post
    await db
      .collection("posts")
      .doc(postId)
      .update({
        likesCount: admin.firestore.FieldValue.increment(1),
      });

    return res.status(200).json({ message: "Post liked" });
  } catch (error) {
    console.error("Error liking post:", error);
    return res.status(500).json({ error: error.message });
  }
});

/**
 * Add a comment to a post
 * POST /addComment
 */
app.post("/addComment", async (req, res) => {
  try {
    const { postId, userId, text } = req.body;

    if (!postId || !userId || !text) {
      return res
        .status(400)
        .json({ error: "postId, userId and text are required" });
    }

    // Create a new comment
    const commentData = {
      userId,
      text,
      likesCount: 0,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Save comment in subcollection
    const commentRef = await db
      .collection("posts")
      .doc(postId)
      .collection("comments")
      .add(commentData);

    // Increment comments count in post
    await db
      .collection("posts")
      .doc(postId)
      .update({
        commentsCount: admin.firestore.FieldValue.increment(1),
      });

    return res.status(201).json({
      message: "Comment added",
      commentId: commentRef.id,
    });
  } catch (error) {
    console.error("Error adding comment:", error);
    return res.status(500).json({ error: error.message });
  }
});

// Export Cloud Function
exports.api = functions.https.onRequest(app);
