String getReadableInterval(double value) {
  if (value < 60.0) {
    return '${value.round().toString()} m';
  } else {
    return '${(value / 60.0).round().toString()} hr';
  }
}

double getSliderValue(double value) {
  if (value <= 60.0) {
    return value / 5.0;
  } else {
    return 12.0 + (value - 60.0) / 60.0;
  }
}

double getRealValue(double value) {
  if (value <= 12.0) {
    return value * 5.0;
  } else {
    return 60.0 + (value - 12.0) * 60.0;
  }
}