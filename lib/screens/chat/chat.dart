import 'package:flutter/material.dart';
import 'package:app_3/data/chat_model.dart';

const roundedCorner = Radius.circular(20);

class Chat extends StatelessWidget {
  final Size size;
  final bool isMine;
  final ChatModel chatModel;

  const Chat(
      {Key? key,
        required this.size,
        required this.isMine,
        required this.chatModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine ? _buildMyMsg(context) : _buildOthersMsg(context);
  }

  Row _buildOthersMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(chatModel.msg,
                  style: Theme.of(context).textTheme.bodyText1!),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints:
              BoxConstraints(minHeight: 40, maxWidth: size.width * 0.5),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                      topRight: roundedCorner,
                      topLeft: Radius.circular(2),
                      bottomRight: roundedCorner,
                      bottomLeft: roundedCorner)),
            ),
            SizedBox(
              width: 6,
            ),
            Text('${chatModel.createdDate}'),
          ],
        ),
      ],
    );
  }

  Row _buildMyMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${chatModel.createdDate}'),
        SizedBox(
          width: 6,
        ),
        Container(
          child: Text(
            chatModel.msg,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints:
          BoxConstraints(minHeight: 40, maxWidth: size.width * 0.6),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: roundedCorner,
                  topRight: Radius.circular(2),
                  bottomRight: roundedCorner,
                  bottomLeft: roundedCorner)),
        ),
      ],
    );
  }
}