import 'dart:async';
import 'dart:math';

class MessageObject {
  String objName;
  String title;
  String time;
  String body;
  List<double> location;
  bool isClicked;

  // Standard constructor
  MessageObject(this.objName, this.title, this.time, this.body, this.location, this.isClicked);
}

class ArManager {
  static List<MessageObject> _messageObjects = [MessageObject("okay", "yes", "no", "awdawd", [43.667640, -79.390676], false)]; //test: MessageObject("hello", "goodbye", "no", [43.667847, -79.390824], false)
  static final _messageStreamController = StreamController<List<MessageObject>>.broadcast();

  static String generateUniqueName() {
    var uuid = Random().nextInt(10000);
    return 'node_$uuid';
  }

  static void updateList(String title, String time, String body, List<double> location) {
    _messageObjects.add(MessageObject(generateUniqueName(), title, time, body, location, false));
    _messageStreamController.add(_messageObjects); // Broadcast the updated list
  }

  static void updateList2(List<MessageObject> messageObjectNew) {
    _messageObjects = messageObjectNew;
  }

  static List<MessageObject> getMessageObjects() {
    return _messageObjects;
  }

  // Getter to expose the stream
  static Stream<List<MessageObject>> get messageObjectsStream => _messageStreamController.stream;

  // Don't forget to close the stream controller when it's no longer needed
  static void dispose() {
    _messageStreamController.close();
  }
}
