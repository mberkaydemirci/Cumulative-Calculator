import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ("Deu Not Hesaplama"),
      theme: ThemeData(
        accentColor: Colors.purple.shade800,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Ortalama Hesapla")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulamaGovdesi();
        } else {
          return uygulamaGovdesiLandscape();
        }
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      //margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, //yapının tam tersi
        //statik form bulan container
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            // color: Colors.pink.shade200,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: TextEditingController(text: "Calculus I"),
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      hintText: "Ders Adını Giriniz",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0)
                        return null;
                      else {
                        return "Ders Adı Bos Bırakılamaz";
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.add(Ders(dersAdi, dersHarfDegeri, dersKredi,
                            rasgeleRenkOlustur()));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: dersKredileriItems(),
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                            value: dersKredi,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: dersHarfDegerleri(),
                            onChanged: (secilenHarfDegeri) {
                              setState(() {
                                dersHarfDegeri = secilenHarfDegeri;
                              });
                            },
                            value: dersHarfDegeri,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.blue,
                border: BorderDirectional(
                  top: BorderSide(color: Colors.blue, width: 2),
                  bottom: BorderSide(color: Colors.blue, width: 2),
                )),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: tumDersler.length == 0
                        ? "Lutfen Ders Ekleyin"
                        : "Ortalama:",
                    style: TextStyle(color: Colors.white, fontSize: 30)),
                TextSpan(
                    text: tumDersler.length == 0
                        ? " "
                        : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ]),
            )),
          ),
          //dinamik liste tutan container
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // color: Colors.pink.shade200,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: TextEditingController(text: "Calculus I"),
                          decoration: InputDecoration(
                            labelText: "Ders Adı",
                            hintText: "Ders Adını Giriniz",
                            hintStyle: TextStyle(fontSize: 20),
                            labelStyle: TextStyle(fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0)
                              return null;
                            else {
                              return "Ders Adı Bos Bırakılamaz";
                            }
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersAdi = kaydedilecekDeger;
                            setState(() {
                              tumDersler.add(Ders(dersAdi, dersHarfDegeri,
                                  dersKredi, rasgeleRenkOlustur()));
                              ortalama = 0;
                              ortalamayiHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: dersKredileriItems(),
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  },
                                  value: dersKredi,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.purple, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: dersHarfDegerleri(),
                                  onChanged: (secilenHarfDegeri) {
                                    setState(() {
                                      dersHarfDegeri = secilenHarfDegeri;
                                    });
                                  },
                                  value: dersHarfDegeri,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.purple, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: BorderDirectional(
                          top: BorderSide(color: Colors.blue, width: 2),
                          bottom: BorderSide(color: Colors.blue, width: 2),
                        )),
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: tumDersler.length == 0
                                ? "Lutfen Ders Ekleyin"
                                : "Ortalama:",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        TextSpan(
                            text: tumDersler.length == 0
                                ? " "
                                : "${ortalama.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ]),
                    )),
                  ),
                )
              ],
            ),
            flex: 1,
          ),
          Expanded(
              child: Container(
                child: ListView.builder(
                  itemBuilder: _listeElemanlariniOlustur,
                  itemCount: tumDersler.length,
                ),
              ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem> dersKredileriItems() {
    List<DropdownMenuItem> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(
        DropdownMenuItem(
          value: i,
          child: Text(
            "$i Kredi",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return krediler;
  }

  //harf değerleri liste fonksiyonu
  List<DropdownMenuItem> dersHarfDegerleri() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "FD",
        style: TextStyle(fontSize: 20),
      ),
      value: 0.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    return harfler;
  }

  //liste elemanları oluşturma fonk silme falan da burda
  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: tumDersler[index].renk, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(4),
        child: ListTile(
          leading: Icon(
            Icons.done,
            size: 36,
            color: tumDersler[index].renk,
          ),
          title: Text(tumDersler[index].ad),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: tumDersler[index].renk,
          ),
          subtitle: Text("kredi" +
              tumDersler[index].kredi.toString() +
              "Ders Notu" +
              tumDersler[index].hardDegeri.toString()),
        ),
      ),
    );
  }

  //ort hesaplatma fonk
  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.kredi;
      var harfDegeri = oankiDers.hardDegeri;
      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color rasgeleRenkOlustur() {
    return Color.fromARGB(
      150 + Random().nextInt(105),
      Random().nextInt(255),
      Random().nextInt(255),
      Random().nextInt(255),
    );
  }
}

//ders classı
class Ders {
  String ad;
  double hardDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.hardDegeri, this.kredi, this.renk) {}
}
