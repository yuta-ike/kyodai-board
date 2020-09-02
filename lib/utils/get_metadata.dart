import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';

Future<Metadata> getMetadata (String url) async {
  // Makes a call
  final response = await http.get(url);
  // Covert Response to a Document. The utility function `responseToDocument` is provided or you can use own decoder/parser.
  final document = responseToDocument(response);
  // get metadata
  final data = MetadataParser.parse(document);
  return data;
}
