import 'package:flutter/material.dart';

class PhotoHolderComponent extends StatelessWidget {
  final String userName, dpURL, postURL, commentCount, likeCount;

  PhotoHolderComponent(
      {Key? key,
      required this.userName,
      required this.dpURL,
      required this.postURL,
      required this.commentCount,
      required this.likeCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                // Post holder here
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onDoubleTap: () {
                    // Image on double tap like function here
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius:
                              MediaQuery.of(context).size.width * 0.00099,
                          blurRadius:
                              MediaQuery.of(context).size.width * 0.0099,
                          offset: Offset(
                            -1,
                            MediaQuery.of(context).size.width * 0.008,
                          ),
                        ),
                      ],
                    ),
                    child: Image.network(
                      postURL,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Post holder end

              // Post owner dp and name
              GestureDetector(
                onTap: () {
                  // go to post owner profile function here
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, left: 15),
                          child: Container(
                            alignment: Alignment.centerRight,
                            height: 15,
                            width: userName.length.toDouble() * 8,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white.withOpacity(0.9),
                            ),
                            padding: EdgeInsets.only(right: 2),
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 2,
                                color: Colors.white,
                                strokeAlign: BorderSide.strokeAlignOutside),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius:
                                    MediaQuery.of(context).size.width * 0.00099,
                                blurRadius:
                                    MediaQuery.of(context).size.width * 0.0099,
                                offset: Offset(
                                  -1,
                                  MediaQuery.of(context).size.width * 0.008,
                                ),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: dpURL.isEmpty
                                ? AssetImage(
                                    'lib/image_assests/icons/user_dp2.png')
                                : Image.network(
                                    dpURL,
                                    filterQuality: FilterQuality.high,
                                  ).image, //NetworkImage(dpURL),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Post owner dp and name
            ],
          ),

          // Post buttons
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Image.asset(
                            // Heart icon
                            'lib/image_assests/icons/post_video_icons/heart_on_icon.png',
                            scale: 16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16, top: 12),
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  color: Colors.grey,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0.5),
                              child: Text(
                                likeCount,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Image.asset(
                            // Comment icon
                            'lib/image_assests/icons/post_video_icons/comment_on_icon.png',
                            scale: 17,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 11),
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  color: Colors.grey,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0.5),
                              child: Text(
                                commentCount,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        // Share icon
                        'lib/image_assests/icons/post_video_icons/share_icon.png',
                        scale: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 5),
            child: Divider(
              thickness: 1.5,
              color: Color(0x62525252),
            ),
          ),
        ],
      ),
    );
  }
}
