import 'package:crud_demo/core/constant/app_color.dart';
import 'package:crud_demo/presentation/screen/auth/screen/login_screen.dart';
import 'package:crud_demo/presentation/screen/home/cubit/home/home_cubit.dart';
import 'package:crud_demo/presentation/widget/button/common_button.dart';
import 'package:crud_demo/presentation/widget/textfield/textfield.dart';
import 'package:crud_demo/presentation/widget/toast/common_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String userId;
  TextEditingController searchController = TextEditingController();
  List notesList = [];
  List filteredNotes = [];

  

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? 'oiuy6578900';
    context.read<HomeCubit>().fetchNotes(userId);
  }

  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote(context);
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
      appBar: homeAppbar(context),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeFailed) {
            return Center(child: Text(state.error));
          }
          if (state is HomeSuccess) {
            notesList = state.notes;
            filteredNotes = searchController.text.isEmpty
                ? notesList
                : filteredNotes;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: notesList.isEmpty
                  ? Center(child: Text("No Item Found"))
                  : listData(state),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  void addNote(
    BuildContext context, {
    bool isAddNote = true,
    String? id,
    String? tit,
    String? con,
  }) {
    title.text = tit ?? '';
    content.text = con ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeSuccess) {
                  Navigator.of(context).pop();
                  title.clear();
                  content.clear();
                }
                if (state is HomeLoading) {
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is HomeFailed) {
                  title.clear();
                  content.clear();
                  CommonToast.commonToast(text: state.error, context: context);
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAddNote ? 'Add Note' : 'Update Note',
                    style: TextStyle(
                      fontSize: 18,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CommonTextField(
                    controller: title,
                    hintText: 'Please enter title...',
                    keyboardType: TextInputType.text,
                  ),
                  CommonTextField(
                    controller: content,
                    hintText: 'Please add notes...',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CommonButton(
                          text: 'Close',
                          onPressed: () {
                            Navigator.of(context).pop();
                            title.clear();
                            content.clear();
                          },
                        ),
                      ),
                      Expanded(
                        child: CommonButton(
                          text: isAddNote ? 'Add' : 'Submit',
                          onPressed: () {
                            if (isAddNote) {
                              context.read<HomeCubit>().addNote(
                                title: title.text.trim(),
                                content: content.text.trim(),
                                userId: userId,
                              );
                            } else {
                              context.read<HomeCubit>().updateNote(
                                title: title.text.trim(),
                                content: content.text.trim(),
                                userId: userId,
                                id: id ?? '',
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  listData(HomeSuccess stathhe) {
    return Column(
      children: [
        SizedBox(height: 10),
        CommonTextField(
          controller: searchController,
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          onChanged: (value) {
            setState(() {
              filteredNotes = notesList
                  .where(
                    (note) =>
                        note.title.toLowerCase().contains(value.toLowerCase()),
                  )
                  .toList();
            });
          },
        ),
        SizedBox(height: 10),
        filteredNotes.isEmpty
            ? Expanded(child: Center(child: Text("No Search Item Found")))
            : Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(
                        "${filteredNotes[i].title} (${filteredNotes[i].id})",
                      ),
                      subtitle: Text(filteredNotes[i].content),
                      trailing: Wrap(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.edit),
                            onTap: () {
                              addNote(
                                context,
                                isAddNote: false,
                                id: filteredNotes[i].id,
                                tit: filteredNotes[i].title,
                                con: filteredNotes[i].content,
                              );
                            },
                          ),
                          GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () async {
                              await context.read<HomeCubit>().deleteNote(
                                id: filteredNotes[i].id,
                                userId: userId,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return Divider();
                  },
                  itemCount: filteredNotes.length,
                ),
              ),
      ],
    );
  }

  PreferredSizeWidget? homeAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('Home'),
      actions: [
        TextButton(
          onPressed: () async {
            await HydratedBloc.storage.write('isLogin', false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
            await FirebaseAuth.instance.signOut();
          },
          child: Icon(Icons.logout, color: blackColor),
        ),
      ],
    );
  }
}
