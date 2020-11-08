import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Bloc padrão, possue um controle de loading com o [_loadingController]
/// e também consegue "controlar" requisições com o [doOnlineAction]
abstract class BaseBloc {
  /// Controla o loading automaticamente e segura erros com
  /// um simples try catch
  Future<void> doOnlineAction({
    bool withLoading = true,
    Function action
  }) async {
    try {
      if (withLoading) {
        _onLoadingChange(true);
      }
      await action?.call();
    } on Exception catch(error, _) {
      log(error.toString());
    } finally {
      if (withLoading) {
        _onLoadingChange(false);
      }
    }
  }

  final _loadingController = BehaviorSubject<bool>.seeded(false);
  Function(bool) get _onLoadingChange => _loadingController.sink.add;
  Stream<bool> get isLoading => _loadingController.stream;

  /// Encerra os controllers quando o objeto morrer
  @mustCallSuper
  void dispose() {
    _loadingController.drain<dynamic>();
    _loadingController.close();
  } 
}