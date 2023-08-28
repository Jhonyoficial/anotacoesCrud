import 'package:anotacoes/helper/AnotacaoHelper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl_browser.dart';
// import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  var _db = AnotacaoHelper();
  List<Anotacao> anotacoes = List.empty(growable: true);

  _openPopUpCadastro({Anotacao? anotacao}) {
    String _label = '';
    if (anotacao == null) {
      _tituloController.text = '';
      _descricaoController.text = '';
      _label = 'Cadastrar';
    } else {
      _tituloController.text = anotacao.titulo.toString();
      _descricaoController.text = anotacao.descricao.toString();
      _label = 'Atualizar';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$_label Anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Título', hintText: 'Digite título...'),
                ),
                TextField(
                  controller: _descricaoController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Digite a descrição...'),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _salvarAtualizarAnotacao(item: anotacao);
                  Navigator.pop(context);
                },
                child: Text('$_label'),
              )
            ],
          );
        });
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotcao();

    List<Anotacao> anotacaoTemp = List.empty(growable: true);
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      anotacaoTemp.add(anotacao);
    }

    setState(() {
      anotacoes = anotacaoTemp;
    });
    anotacaoTemp = List.empty(growable: true);
  }

  _salvarAtualizarAnotacao({Anotacao? item}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if (item == null) {
      Anotacao anotacao =
          Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    } else {
      item.titulo = titulo.toString();
      item.descricao = titulo.toString();
      item.data = DateTime.now().toString();
      await _db.atualizarAnotacao(item);
    }

    _tituloController.clear();
    _descricaoController.clear();
  }

  String _formatarData(String data) {
    // initializeDateFormatting('pt_BR');
    var formatador = DateFormat("y/MM/d");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _removerAnotacao(int id) async {
    int resultado = await _db.removerAnotacao(id);
    _recuperarAnotacoes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Anotações'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: anotacoes.length,
                    itemBuilder: (context, index) {
                      final _item = anotacoes[index];

                      return Card(
                        child: ListTile(
                          title: Text(_item.titulo.toString()),
                          subtitle: Text(
                              " ${_formatarData(_item.data.toString())} - ${_item.descricao.toString()}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onDoubleTap: () {
                                  _openPopUpCadastro(anotacao: _item);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () {
                                  _removerAnotacao(_item.id!);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _openPopUpCadastro();
          }),
    );
  }
}
