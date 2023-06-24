import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/theme/style.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/single_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/text_messsage_entity.dart';
import 'package:proyecto_c2/features/Chats/Presentation/cubit/chat/chat_cubit.dart';
import 'package:proyecto_c2/features/Chats/Presentation/cubit/group/group_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SingleChatPage extends StatefulWidget {
  final SingleChatEntity singleChatEntity;
  const SingleChatPage({Key? key, required this.singleChatEntity})
      : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  late String url;
  late String vidurl;
  late String audiourl;
  String messageContent = "";
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _changeKeyboardType = false;
  int _menuIndex = 0;
  ImagePicker _imagePicker = ImagePicker();
  VideoPlayerController? _vidController;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });

    BlocProvider.of<ChatCubit>(context)
        .getMessages(channelId: widget.singleChatEntity.groupId);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _vidController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  check() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      appBar: AppBar(
        title: Text("${widget.singleChatEntity.groupName}"),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (index, chatState) {
          if (chatState is ChatLoaded) {
            return Column(
              children: [
                _messagesListWidget(chatState),
                _sendMessageTextField(),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _sendMessageTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: Offset(0.0, 0.50),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 60),
                        child: Scrollbar(
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            controller: _messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? xFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (xFile != null) {
                            url = await uploadFile(
                                'chatimages/${xFile.name}', File(xFile.path));
                          } else {
                            print('No se seleccionó ninguna imagen.');
                          }
                          BlocProvider.of<ChatCubit>(context).sendTextMessage(
                              textMessageEntity: TextMessageEntity(
                                  time: Timestamp.now(),
                                  senderId: widget.singleChatEntity.uid,
                                  content: url,
                                  senderName: widget.singleChatEntity.username,
                                  type: "IMG"),
                              channelId: widget.singleChatEntity.groupId);
                          BlocProvider.of<GroupCubit>(context).updateGroup(
                              groupEntity: GroupEntity(
                            groupId: widget.singleChatEntity.groupId,
                            lastMessage: _messageController.text,
                            creationTime: Timestamp.now(),
                          ));
                        },
                        child: Icon(
                          LineIcons.imageFile,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      _messageController.text.isEmpty
                          ? GestureDetector(
                              onTap: () async {
                                String videourl = '';
                                XFile? xFile = await _imagePicker.pickVideo(
                                    source: ImageSource.gallery);
                                if (xFile != null) {
                                  videourl = await uploadFile(
                                      'videos/${xFile.name}', File(xFile.path));
                                } else {
                                  print('No se seleccionó ningún video.');
                                }
                                BlocProvider.of<ChatCubit>(context)
                                    .sendTextMessage(
                                        textMessageEntity:
                                            TextMessageEntity(
                                                time: Timestamp.now(),
                                                senderId: widget
                                                    .singleChatEntity.uid,
                                                content: videourl,
                                                senderName:
                                                    widget.singleChatEntity
                                                        .username,
                                                type: "VID"),
                                        channelId:
                                            widget.singleChatEntity.groupId);
                                BlocProvider.of<GroupCubit>(context)
                                    .updateGroup(
                                        groupEntity: GroupEntity(
                                  groupId: widget.singleChatEntity.groupId,
                                  lastMessage: _messageController.text,
                                  creationTime: Timestamp.now(),
                                ));
                              },
                              child: Icon(
                                LineIcons.videoFile,
                                color: Colors.grey[500],
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () async {
              if (_messageController.text.isEmpty) {
                print('hola');
                FilePickerResult? filePickerResult =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['mp3', 'wav'], // Extensiones permitidas
                );

                if (filePickerResult != null) {
                  audiourl = await uploadFile(
                    'audios/${filePickerResult.files.single.name}',
                    File(filePickerResult.files.single.path!),
                  );
                } else {
                  print('No se seleccionó ningún audio.');
                }
                BlocProvider.of<ChatCubit>(context).sendTextMessage(
                    textMessageEntity: TextMessageEntity(
                        time: Timestamp.now(),
                        senderId: widget.singleChatEntity.uid,
                        content: audiourl,
                        senderName: widget.singleChatEntity.username,
                        type: "AUDIO"),
                    channelId: widget.singleChatEntity.groupId);
                BlocProvider.of<GroupCubit>(context).updateGroup(
                    groupEntity: GroupEntity(
                  groupId: widget.singleChatEntity.groupId,
                  lastMessage: _messageController.text,
                  creationTime: Timestamp.now(),
                ));
                //TO DO mensajes de voz
              } else {
                print(_messageController.text);
                BlocProvider.of<ChatCubit>(context).sendTextMessage(
                    textMessageEntity: TextMessageEntity(
                        time: Timestamp.now(),
                        senderId: widget.singleChatEntity.uid,
                        content: _messageController.text,
                        senderName: widget.singleChatEntity.username,
                        type: "TEXT"),
                    channelId: widget.singleChatEntity.groupId);
                BlocProvider.of<GroupCubit>(context).updateGroup(
                    groupEntity: GroupEntity(
                  groupId: widget.singleChatEntity.groupId,
                  lastMessage: _messageController.text,
                  creationTime: Timestamp.now(),
                ));
                setState(() {
                  _messageController.clear();
                });
              }
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  color: darkPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                _messageController.text.isEmpty ? Icons.mic : Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _messagesListWidget(ChatLoaded messages) {
    Timer(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
      );
    });
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.messages.length,
        itemBuilder: (_, index) {
          final message = messages.messages[index];

          if (message.senderId == widget.singleChatEntity.uid) {
            print(message.type);
            if (message.type == 'TEXT') {
              return _messageLayout(
                name: "Me",
                alignName: TextAlign.end,
                color: primaryColor,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                text: message.content,
              );
            } else if (message.type == 'IMG') {
              return _imageLayout(
                name: "Me",
                alignName: TextAlign.end,
                color: primaryColor,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                url: message.content,
              );
            } else if (message.type == 'VID') {
              return _videoLayout(
                name: "Me",
                alignName: TextAlign.end,
                color: primaryColor,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                url: message.content,
              );
            } else if (message.type == 'AUDIO') {
              return _audioLayout(
                name: "Me",
                alignName: TextAlign.end,
                color: primaryColor,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                url: message.content,
              );
            }
          } else {
            // ignore: curly_braces_in_flow_control_structures
            if (message.type == 'TEXT') {
              return _messageLayout(
                color: Colors.white,
                name: "${message.senderName}",
                alignName: TextAlign.end,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                text: message.content,
              );
            } else if (message.type == 'IMG') {
              return _imageLayout(
                color: Colors.white,
                name: "${message.senderName}",
                alignName: TextAlign.end,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                url: message.content,
              );
            } else if (message.type == 'VID') {
              return _videoLayout(
                color: Colors.white,
                name: "${message.senderName}",
                alignName: TextAlign.end,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                url: message.content,
              );
            } else if (message.type == 'AUDIO') {
              return _audioLayout(
                color: Colors.white,
                name: "${message.senderName}",
                alignName: TextAlign.end,
                time: DateFormat('hh:mm a').format(message.time!.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                url: message.content,
              );
            }
          }
        },
      ),
    );
  }

  Widget _messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    textAlign: align,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _imageLayout({
    url,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Image.network(
                    url,
                    height: 100,
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _videoLayout({
    url,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    final Uri vidurl = Uri.parse(url);
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      text: url,
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL(url.toString());
                        },
                    ),
                  ),
                  // Text(
                  //   url,
                  //   textAlign: align,
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  // FutureBuilder<String?>(
                  //   future: generateThumbnail(url),
                  //   builder: (context, AsyncSnapshot<String?> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       if (snapshot.hasData && snapshot.data != null) {
                  //         return Image.memory(snapshot.data! as Uint8List);
                  //       } else if (snapshot.hasError) {
                  //         return Text('Error al generar el thumbnail');
                  //       }
                  //     }
                  //     return CircularProgressIndicator();
                  //   },
                  // ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _audioLayout({
    url,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
    String? name,
    alignName,
  }) {
    print(url);
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    textAlign: alignName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _audioPlayer.play(UrlSource(url));
                    },
                    child: Text('Reproducir Audio'),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<String> uploadFile(String path, File file) async {
    Reference reference = FirebaseStorage.instance.ref().child(path);
    UploadTask upladTask = reference.putFile(file);

    TaskSnapshot taskSnapshot = await upladTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }

  // Future<void> setVideo(String url) async {
  //   print(url);
  //   _vidController = VideoPlayerController.network(url)
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  // Future<String?> generateThumbnail(String videoUrl) async {
  //   print("hola");
  //   print("holaaa" + videoUrl);
  //   final thumbnail = await VideoThumbnail.thumbnailFile(
  //     video: videoUrl,
  //     imageFormat: ImageFormat.JPEG,
  //     maxHeight: 64,
  //     quality: 25,
  //   );
  //   return thumbnail;
  // }

  redirect(String vid) async {
    final Uri url = Uri.parse(vid);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }
}
