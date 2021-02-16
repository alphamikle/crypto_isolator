import 'package:crypto_isolator/state/token_state.dart';
import 'package:crypto_isolator/ui/tokens_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokensListWrapper<T extends TokenState> extends StatefulWidget {
  const TokensListWrapper({Key key}) : super(key: key);

  @override
  _TokensListWrapperState<T> createState() {
    return _TokensListWrapperState();
  }
}

class _TokensListWrapperState<T extends TokenState> extends State<TokensListWrapper> {
  T _state;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<T>(context, listen: false);
    _state.start();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, T state, Widget child) => TokensList(
        tokens: state.tokens,
        isLoading: state.isLoading,
      ),
    );
  }
}
