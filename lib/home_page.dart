import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gym_application/custom_colors.dart';
import 'package:gym_application/custom_widgets/hero_dialog_route.dart';
import 'package:gym_application/custom_widgets/profile_menu_button.dart';
import 'package:gym_application/custom_widgets/profile_picture.dart';
import 'package:gym_application/models/user.dart';
import 'package:gym_application/providers/ui_provider.dart';
import 'package:gym_application/screens/all_chats_screen.dart';
import 'package:gym_application/screens/find_user_screen.dart';
import 'package:gym_application/screens/home_screen.dart';
import 'package:gym_application/screens/host_profile_screen.dart';
import 'package:gym_application/screens/start_chat_screen.dart';
import 'package:gym_application/services/authentication_service.dart';
import 'package:gym_application/services/post_db_service.dart';
import 'package:gym_application/services/user_db_service.dart';
import 'package:gym_application/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List screens = [
    const HomeScreen(),
    AllChatsScreen(),
    const FindUserScreen(),
    //StatsScreen(),
    HostProfileScreen(),
  ];
  final _userDbService = UserDbService();
  final _postDbService = PostDbService();
  final _auth = auth.FirebaseAuth.instance;
  OverlayEntry? _overlayEntry;
  int _index = 0;
  List<String> titles = ["Home", "Chats", "Find", /*"Body Stats",*/ "Profile"];
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UIProvider>(context);
    final backgroundColor = provider.backgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          provider.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: getActions(),
      ),
      body: SafeArea(
        child: Expanded(
          child: screens[_index],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: provider.backgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
              onTabChange: _onTabChange,
              color: Colors.white,
              activeColor: Colors.white,
              padding: const EdgeInsets.all(16),
              tabBackgroundColor: const Color.fromARGB(66, 96, 93, 93),
              gap: 10,
              tabBorderRadius: 60,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.send_rounded,
                  text: "Send",
                ),
                GButton(
                  icon: Icons.search_outlined,
                  text: "Find",
                ),
                /*GButton(
                  icon: Icons.query_stats_rounded,
                  text: "Stats",
                ),*/
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ]),
        ),
      ),
    );
  }

  void _onTabChange(int index) {
    final provider = Provider.of<UIProvider>(context, listen: false);
    if (_isMenuOpen) {
      _closeFriendRequests();
    }
    setState(() {
      _index = index;
    });
    if (index != 3) {
      provider.changeTitle(index);
    }
  }

  List<Widget>? getActions() {
    if (_index == 0) {
      return [
        IconButton(
            onPressed: () {
              if (!_isMenuOpen) {
                _showFriendRequests(context);
              } else {
                _closeFriendRequests();
              }
            },
            icon: const Icon(FontAwesomeIcons.userGroup, color: Colors.white))
      ];
    }
    if (_index == 1) {
      return [startChatButton()];
    }
    if (_index == 3) {
      return [
        IconButton(
            onPressed: () => _showSettings(context),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ))
      ];
    }
    return null;
  }

  Widget startChatButton() {
    return Hero(
        tag: "tag-1",
        child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  HeroDialogRoute(builder: (context) => StartChatScreen()));
            }));
  }

  void _showFriendRequests(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    List<User?> requestedFriends = await _userDbService
        .getFriendRequests(auth.FirebaseAuth.instance.currentUser!.uid);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: kToolbarHeight + 35,
          right: 10,
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: themeColor2,
            elevation: 4,
            child: Container(
              width: 300,
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: requestedFriends.isEmpty
                  ? const SizedBox(
                      height: 60,
                      child: Center(
                          child: Text(
                        "No friend requests",
                        style: TextStyle(color: Colors.white),
                      )),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: requestedFriends.map((user) {
                        if (user == null) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          color: Colors.transparent,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProfilePicture(userId: user.userId),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 80,
                                  child: AutoSizeText(
                                    maxFontSize: 15,
                                    maxLines: 1,
                                    user.userName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              _friendRequestButton(
                                  () => _userDbService.acceptFriendRequest(
                                      _auth.currentUser!.uid, user.userId),
                                  Colors.blue,
                                  "Accept"),
                              const SizedBox(width: 5),
                              _friendRequestButton(
                                  () => _userDbService.declineFriendRequest(
                                      _auth.currentUser!.uid, user.userId),
                                  Colors.red,
                                  "Decline"),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeFriendRequests() {
    _overlayEntry?.remove();
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: themeColor3,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 220,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      color: themeColor2,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileMenuButton(
                          content: const Text("SignOut"),
                          onPressedMethod: () {
                            AuthenticationService.logOut();
                            SystemNavigator.pop();
                          }),
                      ProfileMenuButton(
                          content: const Text("Upload Image"),
                          onPressedMethod: () async {
                            File? file = await getImageFromGallery(context);
                            if (file != null) {
                              final user = await _userDbService
                                  .getSpecificUser(_auth.currentUser!.uid);
                              final isSuccess =
                                  await _postDbService.uploadPost(file, user!);
                              if (isSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Image posted!")));
                              } else {
                                print("An error occured!");
                              }
                            }
                          }),
                      ProfileMenuButton(
                          content: const Text("Change Profile Picture"),
                          onPressedMethod: () async {
                            File? file = await getImageFromGallery(context);
                            if (file != null) {
                              addOrChangeProfilePicture(file);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "An error occured. Please try again later.")));
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _friendRequestButton(
      Function method, Color buttonColor, String buttonText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          backgroundColor: buttonColor,
          maximumSize: const Size(80, 40),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
      onPressed: () => method(),
      child: Text(buttonText,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
