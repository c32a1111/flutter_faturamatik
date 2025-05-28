class NFCInfoMessages {
  final String? tagError;
  final String? moreThanOneTag;
  final String? connectionError;
  final String? invalidMrzKey;
  final String? responseError;
  final String? defaultMessage;
  final String? successMessage;
  final String? requestPresentPass;

  NFCInfoMessages({
    this.tagError,
    this.moreThanOneTag,
    this.connectionError,
    this.invalidMrzKey,
    this.responseError,
    this.defaultMessage,
    this.successMessage,
    this.requestPresentPass,
  });

  Map<String, String> toMap() {
    final map = <String, String>{};
    if (tagError != null) map['tagError'] = tagError!;
    if (moreThanOneTag != null) map['moreThanOneTag'] = moreThanOneTag!;
    if (connectionError != null) map['connectionError'] = connectionError!;
    if (invalidMrzKey != null) map['invalidMrzKey'] = invalidMrzKey!;
    if (responseError != null) map['responseError'] = responseError!;
    if (defaultMessage != null) map['defaultMessage'] = defaultMessage!;
    if (successMessage != null) map['successMessage'] = successMessage!;
    if (requestPresentPass != null) map['requestPresentPass'] = requestPresentPass!;
    return map;
  }
}