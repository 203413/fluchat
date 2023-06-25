import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_c2/features/AuthUsers/Data/models/user_model.dart';
import 'package:proyecto_c2/features/AuthUsers/Data/datasources/storage_provider.dart';
import 'package:proyecto_c2/features/AuthUsers/Domain/entities/user_entity.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/cubit/user/user_cubit.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/common.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/profile_widget.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/theme/style.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _statusController;
  TextEditingController? _emailController;
  TextEditingController? _numController;

  File? _image;
  String? _profileUrl;
  String? _username;
  String? _phoneNumber;
  final picker = ImagePicker();

  void dispose() {
    _nameController!.dispose();
    _statusController!.dispose();
    _emailController!.dispose();
    _numController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: "");
    _statusController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _numController = TextEditingController(text: "");
    super.initState();
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          StorageProviderRemoteDataSource.uploadFile(file: _image!)
              .then((value) {
            print("profileUrl");
            setState(() {
              _profileUrl = value;
            });
          });
        } else {
          print('Imagen no seleccionada.');
        }
      });
    } catch (e) {
      toast("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return _profileWidget(userState.users);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _profileWidget(List<UserEntity> users) {
    final user = users.firstWhere((user) => user.uid == widget.uid,
        orElse: () => UserModel());
    _nameController!.value = TextEditingValue(text: "${user.name}");
    _emailController!.value = TextEditingValue(text: "${user.email}");
    _statusController!.value = TextEditingValue(text: "${user.status}");

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(150, 150, 150, 1),
                  borderRadius: BorderRadius.all(Radius.circular(75)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(75)),
                  child:
                      profileWidget(imageUrl: user.profileUrl, image: _image),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Eliminar foto de perfil',
              style: TextStyle(
                  color: darkPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 28,
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 22),
              height: 47,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color747480.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _nameController,
                onChanged: (textData) {
                  _username = textData;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  hintText: 'Nombre de usuario',
                  hintStyle:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 22),
              height: 47,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color747480.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: AbsorbPointer(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.grey,
                    ),
                    hintText: 'Correo electrónico',
                    hintStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 22),
              height: 47,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color747480.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _statusController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.article,
                    color: Colors.grey,
                  ),
                  hintText: 'Estado',
                  hintStyle:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Divider(
              thickness: 1,
              endIndent: 15,
              indent: 15,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _updateProfile();
              },
              child: Container(
                  margin: EdgeInsets.only(left: 60, right: 60),
                  alignment: Alignment.center,
                  height: 44,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(18, 169, 221, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    'Actualizar',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    BlocProvider.of<UserCubit>(context).getUpdateUser(
      user: UserEntity(
        uid: widget.uid,
        name: _nameController!.text,
        status: _statusController!.text,
        profileUrl: _profileUrl!,
      ),
    );
    toast("Perfil actualizado");
  }
}
