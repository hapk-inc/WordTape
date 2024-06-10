enum WordValidate {
  alreadyFilled,
  filled,
  previous,
  focused,
  error,
  revealed,
  idle,
}

bool filledState(WordValidate wv) =>
    wv == WordValidate.alreadyFilled ||
    wv == WordValidate.previous ||
    wv == WordValidate.filled ||
    wv == WordValidate.revealed;

enum AuthValidate { notLogged, guest, loggedIn }
