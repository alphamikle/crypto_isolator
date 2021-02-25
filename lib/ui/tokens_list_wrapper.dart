import 'package:crypto_isolator/base/screens_state.dart';
import 'package:crypto_isolator/base/token_state.dart';
import 'package:crypto_isolator/ui/tokens_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokensListWrapper<T extends TokenState> extends StatefulWidget {
  const TokensListWrapper({
    @required this.index,
    Key key,
  }) : super(key: key);

  final int index;

  @override
  _TokensListWrapperState<T> createState() => _TokensListWrapperState<T>();
}

class _TokensListWrapperState<T extends TokenState> extends State<TokensListWrapper<T>> {
  T _state;
  ScreenState _screenState;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<T>(context, listen: false);
    _screenState = Provider.of(context, listen: false);
    _state.start();
  }

  @override
  void dispose() {
    _state.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, T state, Widget child) => TokensList(
        tokens: state.tokens,
        isLoading: state.isLoading,
        controller: _screenState.getControllerByIndex(widget.index),
      ),
    );
  }
}
