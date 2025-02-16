import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/csv_reference.dart';
import 'package:mobile/model/reference.dart';
import 'package:mobile/util/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile/service/api_singleton.dart';


class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController _cameraController = MobileScannerController();
  final TextEditingController _quantityController = TextEditingController();
  String? _barecode;
  CsvReference? _csvReference;
  Reference? _reference;
  ApiSingleton http = ApiSingleton();

  // TODO Move to generic method in separate file
  Future<Reference?> searchReferenceInAPI(String cip13) async {
    Response response = await http.client!.get("${http.apiUrl}/reference/${cip13}");
    return response.statusCode == 200 && response.data is Map<String, dynamic> ? Reference.fromJson(response.data) : null;
  }

  // TODO Add loading animation
  void _onDetect(BarcodeCapture barcodeCapture) async {
    if (barcodeCapture.barcodes.first.rawValue != null) {
      _cameraController.stop();
      
      Reference? reference = await searchReferenceInAPI(barcodeCapture.barcodes.first.rawValue!);
      setState(() {
        _barecode = barcodeCapture.barcodes.first.rawValue; 
        _reference = reference;
      });

      if(reference == null) {
        CsvReference? csvReference = await searchReferenceInCSV('assets/medicaments.csv', _barecode!); 
        setState(() {
          _csvReference =  csvReference;
        });
      }
    }
  }

  Future<void> _onSubmit() async {
    int? value = int.tryParse(_quantityController.text);
    if (value != null && value > 0) {
      Response response = _reference == null ? 
        await http.client!.post("${http.apiUrl}/reference", data : {"cip13" : _barecode, "quantity" : value}) : 
        await http.client!.patch("${http.apiUrl}/reference/$_barecode", data : {"quantity" : value});

      if(response.statusCode == 200 || response.statusCode == 201) {
        showSnackBar(context, "Ajouté au stock : $value x ${_reference?.name ?? _csvReference?.name}");
        _quantityController.clear();
        setState(() {
          _reference = Reference.fromJson(response.data);
          _csvReference = null;
        });
      }
    }
  }

  void _onRescan() {
    _cameraController = MobileScannerController();
    setState(() {
      _barecode = null; 
      _reference = null;
      _csvReference = null;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_barecode == null ? 'Scanner un médicament' : 'Ajouter un médicament')),
      body: _barecode != null ? 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if(_reference != null || _csvReference != null)
              ...[
                Text("Nom : ${_reference?.name ?? _csvReference?.name}", style: const TextStyle(fontSize: 15)),
                Text("CIP7 : ${_reference?.cip7 ?? _csvReference?.cip7}", style: const TextStyle(fontSize: 15)),
                Text("CIP13 : ${_reference?.cip13 ?? _csvReference?.cip13}", style: const TextStyle(fontSize: 15)),
                Text("Quantité actuelle :  ${_reference?.quantity ?? 0}", style: const TextStyle(fontSize: 15)),
                SizedBox(
                  width: 300,
                  child : TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number, 
                    decoration: const InputDecoration(
                      labelText: 'Quantité à ajouter au stock',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {await _onSubmit();},
                  child: const Text('Ajouter au stock'),
                ),
              ]
            else
              Text("Aucune réference trouvée pour le code $_barecode, veuillez réessayer"),
              ElevatedButton(onPressed : () {_onRescan();},
                child: const Text('Rescanner')
              )
          ],
        )
      ) :
      MobileScanner(
        controller: _cameraController,
        onDetect: _onDetect,
      ),
    );
  }
}
