enum AccountType {
  temporary, normal,
}

extension ExAccountType on Map<String, dynamic>{
  AccountType getAccoutType(String key, { AccountType or }){
    final dynamic value = this[key];
    if(value is! AccountType){
      return or;
    }
    switch(value as String){
      case 'temporary': return AccountType.temporary;
      case 'normal': return AccountType.normal;
      default: return or;
    }
  }
}