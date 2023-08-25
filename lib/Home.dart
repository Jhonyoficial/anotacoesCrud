import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  _openPopUpCadastro(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Adicionar Anotação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: 'Digite título...'
                ),
              ),
              TextField(
                controller: _descricaoController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite a descrição...'
                ),
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

              }, 
              child: Text('Salvar'),
            )
          ],
        );
      }
    );
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
            
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _openPopUpCadastro();
        }
      ),
    );
  }
}