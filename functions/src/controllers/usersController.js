const usersService = require("../services/userService");
const ApiResponseHelper = require("../utils/apiResponseHelper");

exports.toggleFollow = async (req, res) => {
  try {
    const { followerId, followingId } = req.body;

    if (!followerId || !followingId) {
      return res
        .status(400)
        .json({ error: "followerId and followingId are required" });
    }

    const result = await usersService.toggleFollow(followerId, followingId);
    return ApiResponseHelper.success(
      res,
      200,
      result.followed ? "User followed" : "User unfollowed",
      result
    );
  } catch (error) {
    console.error("Error in toggleFollow:", error);
    return ApiResponseHelper.error(res, 500, error.message);
  }
};
