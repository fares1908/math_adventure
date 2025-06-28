List<String> mapOperatorsToTypes(Set<String> ops) {
  final Map<String, String> opToType = {
    '+': 'addition',
    '-': 'subtraction',
    '×': 'multiplication',
    '÷': 'division',
  };

  final List<String> types = ops.map((op) => opToType[op] ?? '').toList();

  // لو مفيش ولا عملية مشروطة، نرجّع النوع العام
  if (types.every((e) => e.isEmpty)) {
    return ['general'];
  }

  return types.where((e) => e.isNotEmpty).toList();
}
