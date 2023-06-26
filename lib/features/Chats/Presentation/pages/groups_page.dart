import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_c2/features/AuthUsers/Data/models/user_model.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/cubit/user/user_cubit.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/single_item_group_widget.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/single_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Presentation/cubit/group/group_cubit.dart';
import 'package:proyecto_c2/page_const.dart';

class GroupsPage extends StatelessWidget {
  final String uid;
  final String? query;

  const GroupsPage({Key? key, required this.uid, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0A6AA6),
        onPressed: () {
          Navigator.pushNamed(context, PageConst.createGroupPage,
              arguments: uid);
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            final user = userState.users.firstWhere(
                (element) => element.uid == uid,
                orElse: () => UserModel());

            return BlocBuilder<GroupCubit, GroupState>(
              builder: (context, groupState) {
                if (groupState is GroupLoaded) {
                  final filteredGroups = groupState.groups
                      .where((group) =>
                          group.groupName.startsWith(query!) ||
                          group.groupName.startsWith(query!.toLowerCase()))
                      .toList();

                  return Column(
                    children: [
                      Expanded(
                          child: filteredGroups.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 40,
                                        color: Colors.black.withOpacity(.4),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Aún no hay grupos aquí",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.2)),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredGroups.length,
                                  itemBuilder: (_, index) {
                                    return SingleItemGroupWidget(
                                      group: filteredGroups[index],
                                      onTap: () {
                                        BlocProvider.of<GroupCubit>(context)
                                            .joinGroup(
                                                groupEntity: GroupEntity(
                                                    groupId:
                                                        filteredGroups[index]
                                                            .groupId))
                                            .then((value) {
                                          BlocProvider.of<GroupCubit>(context)
                                              .getGroups();
                                        });
                                        Navigator.pushNamed(
                                            context, PageConst.singleChatPage,
                                            arguments: SingleChatEntity(
                                                username: user.name,
                                                groupId: filteredGroups[index]
                                                    .groupId,
                                                groupName: filteredGroups[index]
                                                    .groupName,
                                                uid: uid));
                                      },
                                    );
                                  },
                                ))
                    ],
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
