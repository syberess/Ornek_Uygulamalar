import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_veri_cek/kitap.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Material App', home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var url = Uri.parse(
      "https://www.kitapyurdu.com/index.php?route=product/best_sellers&list_id=22");
  List<Kitap> kitaplar = [];
  bool isloading=false;
  Future getData() async {
    setState(() {
      isloading=true;
    });
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

    /*resim->element.children[3].children[0].children[0].children[0].attributes['src']
      KİTAP_ADİ -> element.children[4].text
      yayın adı-> element.children[5].text
      yazar adı-> element.children[6].text
      fiyaı-> element.children[9].text


   */
    var response = document
        .getElementsByClassName("product-grid")[0]
        .getElementsByClassName("product-cr")
        .forEach((element) {
          setState(() {
            kitaplar.add(
              Kitap(
          image: element.children[3].children[0].children[0].children[0].attributes['src'].toString(),
          kitapAdi: element.children[4].text.toString(),
          yayinEvi: element.children[5].text.toString(),
          yazar: element.children[6].text.toString(),
          fiyat: element.children[9].text.toString()
          
      ));
          });
      
    });
    setState(() {
      isloading=false;
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('Web Scarping Kitap Yurdu'),
      ),
      body: isloading? const Center(child: CircularProgressIndicator(),) : SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemCount: kitaplar.length,
        itemBuilder: (context, index) => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 6,
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                        kitaplar[index].image),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      index.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 122, 7, 125),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Kitap İsmi:${kitaplar[index].kitapAdi}",
                style: _style,
              ),
              Text(
                "Kitap YayınEvi: ${kitaplar[index].yayinEvi} ",
                style: _style,
              ),
              Text(
                "Kitap Yazarı: ${kitaplar[index].yazar}",
                style: _style,
              ),
              Text(
                "Kitap Fiyatı: ${kitaplar[index].fiyat}tl",
                style: _style,
              ),
            ]),
          ),
        ),
      )),
    );
    return scaffold;
  }

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 15);
}
