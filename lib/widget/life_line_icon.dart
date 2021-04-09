import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LifeLineIcon extends StatefulWidget {
  final filler;
  final Function callback;
  final bool isEnabled;

  LifeLineIcon({@required this.filler, @required this.callback, @required this.isEnabled});

  @override
  _LifeLineIconState createState() => _LifeLineIconState(isEnabled);
}

class _LifeLineIconState extends State<LifeLineIcon> with SingleTickerProviderStateMixin{

  final bool isEnabled;
  _LifeLineIconState(this.isEnabled);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: widget.isEnabled ? Colors.greenAccent : Colors.red,
      child: CircleAvatar(
        radius: 27,
        backgroundColor: widget.isEnabled ?  Theme.of(context).buttonColor : Colors.grey,
        child: ClipOval(
          child: Center(
            child: _getFiller()
          ),
        ),
      ),
    );
  }

  Widget _getFiller() {
    Widget _filler;
    if(widget.filler is IconData) {
      _filler = new IconButton(
        onPressed: widget.isEnabled ? widget.callback : (){},
        icon: new Icon(
          widget.filler,
          color: Theme.of(context).iconTheme.color,
        ),
      );
    } else if(widget.filler is String){
      _filler = GestureDetector(
        onTap: widget.isEnabled ? widget.callback : (){},
        child: Text(
          widget.filler,
          style: GoogleFonts.mcLaren(color: Theme.of(context).textSelectionColor),
        ),
      );
    }
    return _filler;
  }

}
