//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
///import 'package:flutter_app/common/image/custom_network_image.dart';
//import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/utils/HexColor.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:path/path.dart' as path;

class HtmlParser {
  HtmlParser({
    @required this.width,
    this.onLinkTap,
    this.renderNewlines = false,
  });

  final double width;
  final Function onLinkTap;
  final bool renderNewlines;

  static const _supportedElements = [
    "a",
    "abbr",
    "acronym",
    "address",
    "article",
    "aside",
    "b",
    "bdi",
    "bdo",
    "big",
    "blockquote",
    "body",
    "br",
    "caption",
    "cite",
    "center",
    "code",
    "data",
    "dd",
    "del",
    "dfn",
    "div",
    "dl",
    "dt",
    "em",
    "figcaption",
    "figure",
    "footer",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "header",
    "hr",
    "i",
    "img",
    "ins",
    "kbd",
    "li",
    "main",
    "mark",
    "nav",
    "noscript",
    "ol", //partial
    "p",
    "pre",
    "q",
    "rp",
    "rt",
    "ruby",
    "s",
    "samp",
    "section",
    "small",
    "span",
    "strike",
    "strong",
    "table",
    "tbody",
    "td",
    "template",
    "tfoot",
    "th",
    "thead",
    "time",
    "tr",
    "tt",
    "u",
    "ul", //partial
    "var",
    "font"
  ];

  ///Parses an html string and returns a list of widgets that represent the body of your html document.
  List<Widget> parse(String data) {
    List<Widget> widgetList = new List<Widget>();

    if (renderNewlines) {
      print("Before: $data");
      data = data.replaceAll("\n", "<br />");
      print("After: $data");
    }
    dom.Document document = parser.parse(data);
    widgetList.add(_parseNode(document.body));
    return widgetList;
  }

  Widget _parseNode(dom.Node node) {
    if (node is dom.Element) {
      print("Found ${node.localName}");
      if (!_supportedElements.contains(node.localName)) {
        return Container();
      }
      print(node.localName);
      switch (node.localName) {
        case "a":
          return GestureDetector(
              child: DefaultTextStyle.merge(
                child: Wrap(
                  children: _parseNodeList(node.nodes),
                ),
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueAccent,
                    decorationColor: Colors.blueAccent),
              ),
              onTap: () {
                if (node.attributes.containsKey('href') && onLinkTap != null) {
                  String url = node.attributes['href'];
                  onLinkTap(url);
                }
              });
        case "abbr":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
            ),
          );
        case "acronym":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
            ),
          );
        case "address":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "article":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "aside":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "b":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        case "bdi":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "bdo":
          if (node.attributes["dir"] != null) {
            return Directionality(
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
              textDirection: node.attributes["dir"] == "rtl"
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            );
          }
          //Direction attribute is required, just render the text normally now.
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "big":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontSize: 20.0,
            ),
          );
        case "blockquote":
          return Padding(
            padding: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
          );
        case "body":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "br":
          if (_isNotFirstBreakTag(node)) {
            return Container(width: width, height: 14.0);
          }
          return Container(width: width);
        case "caption":
          return Container(
            width: width,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: _parseNodeList(node.nodes),
            ),
          );
        case "center":
          return Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
                alignment: WrapAlignment.center,
              ));
        case "cite":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "code":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          );
        case "data":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "dd":
          return Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Container(
                width: width,
                child: Wrap(
                  children: _parseNodeList(node.nodes),
                ),
              ));
        case "del":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
            ),
          );
        case "dfn":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "div":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "dl":
          return Padding(
              padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
              child: Column(
                children: _parseNodeList(node.nodes),
                crossAxisAlignment: CrossAxisAlignment.start,
              ));
        case "dt":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "em":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "figcaption":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "figure":
          return Padding(
              padding: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
              child: Column(
                children: _parseNodeList(node.nodes),
                crossAxisAlignment: CrossAxisAlignment.center,
              ));
        case "footer":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "h1":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "h2":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "h3":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "h4":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "h5":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "h6":
          return DefaultTextStyle.merge(
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          );
        case "header":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "hr":
          return Padding(
            padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
            child: Container(
              height: 0.0,
              decoration: BoxDecoration(border: Border.all()),
            ),
          );
        case "i":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "img":
          if (node.attributes['src'] != null) {

            return CachedNetworkImage(
              fit: BoxFit.contain,
              cacheManager: ImageCacheManager(),
              imageUrl: getImagePath(node.attributes['src'], false, false),
              placeholder: (context,url){
                return Container(
                    color: Colors.white,
                    );
              },
              errorWidget: (context,url,errors){
                return Container(
                    color: Colors.white,
                    );
              },
            );

          } else if (node.attributes['alt'] != null) {
            //Temp fix for https://github.com/flutter/flutter/issues/736
            if (node.attributes['alt'].endsWith(" ")) {
              return Container(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Text(node.attributes['alt']));
            } else {
              return Text(node.attributes['alt']);
            }
          }
          return Container();
        case "ins":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          );
        case "kbd":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          );
        case "li":
          String type = node.parent.localName; // Parent type; usually ol or ul
          const EdgeInsets markPadding = EdgeInsets.symmetric(horizontal: 4.0);
          Widget mark;
          switch (type) {
            case "ul":
              mark = Container(child: Text('•'), padding: markPadding);
              break;
            case "ol":
              int index = node.parent.children.indexOf(node) + 1;
              mark = Container(child: Text("$index."), padding: markPadding);
              break;
            default: //Fallback to middle dot
              mark = Container(width: 0.0, height: 0.0);
              break;
          }
          return Container(
            width: width,
            child: Wrap(
              children: <Widget>[
                mark,
                Wrap(children: _parseNodeList(node.nodes))
              ],
            ),
          );
        case "main":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "mark":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: TextStyle(
              color: Colors.black,
              background: _getPaint(Colors.yellow),
            ),
          );
        case "nav":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "noscript":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "ol":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "p":
          return Padding(
            padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
            child: Container(
              width: width,
              child: Wrap(
                children: _parseNodeList(node.nodes),
              ),
            ),
          );
        case "font":
          String colorStr = node.attributes["color"];
          // var color = colorStr.substring(1,colorStr.length);
          // String col = "0xf" + color;
          // String a = "b74093";
          // dynamic colInt = HexColor(color);
          // const Color c5ab9d5 = Color(0xff5ab9d5);
          //print('颜色值为 ' + colorStr);
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: TextStyle(color: node.attributes["color"] == null ? Colors.black : HexColor(node.attributes["color"])),
          );
        case "pre":
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: DefaultTextStyle.merge(
              child: Text(node.innerHtml),
              style: const TextStyle(
                fontFamily: 'monospace',
              ),
            ),
          );
        case "q":
          List<Widget> children = List<Widget>();
          children.add(Text("\""));
          children.addAll(_parseNodeList(node.nodes));
          children.add(Text("\""));
          return DefaultTextStyle.merge(
            child: Wrap(
              children: children,
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
        case "rp":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "rt":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "ruby":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "s":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
            ),
          );
        case "samp":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          );
        case "section":
          return Container(
            width: width,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "small":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontSize: 10.0,
            ),
          );
        case "span":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "strike":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
            ),
          );
        case "strong":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        case "table":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "tbody":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "td":
          int colspan = 1;
          if (node.attributes['colspan'] != null) {
            colspan = int.tryParse(node.attributes['colspan']);
          }
          return Expanded(
            flex: colspan,
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
          );
        case "template":
        //Not usually displayed in HTML
          return Container();
        case "tfoot":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "th":
          int colspan = 1;
          if (node.attributes['colspan'] != null) {
            colspan = int.tryParse(node.attributes['colspan']);
          }
          return DefaultTextStyle.merge(
            child: Expanded(
              flex: colspan,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: _parseNodeList(node.nodes),
              ),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        case "thead":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "time":
          return Wrap(
            children: _parseNodeList(node.nodes),
          );
        case "tr":
          return Row(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        case "tt":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          );
        case "u":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          );
        case "ul":
          return Column(
            children: _parseNodeList(node.nodes),
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        case "var":
          return DefaultTextStyle.merge(
            child: Wrap(
              children: _parseNodeList(node.nodes),
            ),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          );
      }
    } else if (node is dom.Text) {
      //We don't need to worry about rendering extra whitespace
      if (node.text.trim() == "" && node.text.indexOf(" ") == -1) {
        return Wrap();
      }
      if (node.text.trim() == "" && node.text.indexOf(" ") != -1) {
        node.text = " ";
      }

      print("Plain Text Node: '${trimStringHtml(node.text)}'");
      String finalText = trimStringHtml(node.text);
      //Temp fix for https://github.com/flutter/flutter/issues/736
      if (finalText.endsWith(" ")) {
        return Container(
            padding: EdgeInsets.only(right: 2.0), child: Text(finalText));
      } else {
        return Text(finalText);
      }
    }
    return Wrap();
  }

  List<Widget> _parseNodeList(List<dom.Node> nodeList) {
    return nodeList.map((node) {
      return _parseNode(node);
    }).toList();
  }

  Paint _getPaint(Color color) {
    Paint paint = new Paint();
    paint.color = color;
    return paint;
  }

  String trimStringHtml(String stringToTrim) {
    stringToTrim = stringToTrim.replaceAll("\n", "");
    while (stringToTrim.indexOf("  ") != -1) {
      stringToTrim = stringToTrim.replaceAll("  ", " ");
    }
    return stringToTrim;
  }

  bool _isNotFirstBreakTag(dom.Node node) {
    int index = node.parentNode.nodes.indexOf(node);
    if (index == 0) {
      if (node.parentNode == null) {
        return false;
      }
      return _isNotFirstBreakTag(node.parentNode);
    } else if (node.parentNode.nodes[index - 1] is dom.Element) {
      if ((node.parentNode.nodes[index - 1] as dom.Element).localName == "br") {
        return true;
      }
      return false;
    } else if (node.parentNode.nodes[index - 1] is dom.Text) {
      if ((node.parentNode.nodes[index - 1] as dom.Text).text.trim() == "") {
        return _isNotFirstBreakTag(node.parentNode.nodes[index - 1]);
      } else {
        return false;
      }
    }
    return false;
  }




  String getImagePath(String imgPath, bool fullImg, bool isGauss,
      {double width, double height}) {
    if (TextUtil.isEmpty(imgPath)) {
      l.e("image", "getImagePath()...imgPath is empty",
          stackTrace: StackTrace.current);
      return "";
    }
    if (imgPath.startsWith("http") || imgPath.startsWith("https")) {
      return imgPath;
    }

    ///需要大图且不高斯
    if (fullImg && !isGauss) {
      imgPath = path.join(Address.baseImagePath, imgPath);
      return imgPath;
    }
    String rootPath = path.join(Address.baseImagePath, "imageView/1");
    /*if (!fullImg &&
        !width.isInfinite &&
        !width.isNaN &&
        height.isNaN &&
        height.isInfinite) {
      rootPath = path.join(rootPath, "w/$width/h/$height");
    }*/

    if (isGauss) {
      rootPath = path.join(rootPath, "s/${Config.GAUSS_VALUE}");
    }
    rootPath = path.join(rootPath, imgPath);
    return rootPath;
  }
}
