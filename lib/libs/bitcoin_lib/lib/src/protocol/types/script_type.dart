enum ScriptType {
  empty,
  unsupported, // TODO: add support for other script types, then remove this type.
  p2pk,
  p2pkh,
  p2sh,
  p2wpkh,
  p2wsh;

  const ScriptType();
}
