import 'package:flutter/material.dart';

const String _name = "Brian Phiri";
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = TextEditingController();
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Sending message'
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textEditingController.text),
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  void dispose() async {
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatter'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String string) {
    _textEditingController.clear();
    ChatMessage message = ChatMessage(
      text: string,
      animationController: AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message); 
    });
    message.animationController.forward();
  }
}

// Display chat messages
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
    sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut),
    axisAlignment: 0.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}