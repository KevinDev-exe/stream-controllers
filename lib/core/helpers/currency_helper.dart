class CurrencyHelper {
  static String formatCOP(double value) {
    final int amount = value.round();
    final String text = amount.toString();
    final StringBuffer buffer = StringBuffer();

    int counter = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      counter++;

      if (counter == 3 && i != 0) {
        buffer.write('.');
        counter = 0;
      }
    }

    return '\$${buffer.toString().split('').reversed.join()} COP';
  }
}