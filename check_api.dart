import 'dart:convert';
import 'dart:io';

void main() async {
  final request = await HttpClient().getUrl(Uri.parse('https://equran.id/api/v2/surat/1'));
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final json = jsonDecode(stringData);
  print(jsonEncode(json['data']['ayat'].take(2).toList()));
}
