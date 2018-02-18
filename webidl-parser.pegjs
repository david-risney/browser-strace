Definitions = pN:(cw ExtendedAttributeList cw Definition)* cw {
    return pN.map(entry => ({ attrs: entry[1], def: entry[3] }));
}

Definition = Callback / Partial / Interface / Dictionary / Enum / Typedef / ImplementsStatement

Callback = "callback" cwr (CallbackRest / Interface)

Interface = kind:"interface" cwr name:identifier cwr Inheritance? cw "{" members:InterfaceMembers cw "}" cw ";" {
    return {kind, name, members};
}

Partial = "partial" cwr (PartialInterface / PartialDictionary)

PartialInterface = kind:"interface" cwr name:identifier cwr "{" members:InterfaceMembers cw "}" cw ";" {
    return {kind, name, members};
}

InterfaceMembers = pN:(cw ExtendedAttributeList cw InterfaceMember)* {
    return pN.map(entry => ({ attrs: entry[1], member: entry[3] }));
}

InterfaceMember = Const / Operation / Serializer / Stringifier / StaticMember / Iterable / ReadOnlyMember / ReadWriteAttribute 

Dictionary = "dictionary" cwr identifier cwr Inheritance? cw "{" cw DictionaryMembers? cw "}" cw ";"

DictionaryMembers = ExtendedAttributeList cw DictionaryMember cw DictionaryMembers 

DictionaryMember = Required? cw Type cwr identifier cwr Default? cw ";"

Required = "required";

PartialDictionary = "dictionary" cwr identifier cwr "{" cw DictionaryMembers cw "}" cw ";"

Default = "=" cw DefaultValue;

DefaultValue = ConstValue / string / "[" cw "]"

Inheritance = ":" cw identifier

Enum = "enum" cwr identifier cw "{" cw EnumValueList cw "}" cw ";"

EnumValueList = string (cw "," cw string)*

CallbackRest = identifier cw "=" cw ReturnType cw "(" cw ArgumentList cw ")" cw ";"

Typedef = "typedef" cwr Type cwr identifier cw ";"

ImplementsStatement = identifier cw ("implements"/"includes") cwr identifier cw ";"

Const = "const" cwr ConstType cw identifier cw "=" cw ConstValue cw ";"

ConstValue = BooleanLiteral / FloatLiteral / integer / "null"

BooleanLiteral = "true" / "false"

FloatLiteral = float / "-Infinity" / "Infinity" / "NaN"

Serializer = "serializer" cwr SerializerRest

SerializerRest = OperationRest / "=" cw SerializationPattern cw ";" / ";"

SerializationPattern = "{" cw SerializationPatternMap? cw "}" / "[" cw SerializationPatternList? cw "]" / identifier

SerializationPatternMap = "getter" / "inherit" cwr ( cw "," cw identifier)* / identifier cwr ( cw "," cw identifier)*

SerializationPatternList = "getter" / identifier cwr (cw "," cw identifier)*

Stringifier = "stringifier" cwr StringifierRest

StringifierRest = ReadOnly cw AttributeRest / ReturnType cw OperationRest / ";"

StaticMember = "static" cwr StaticMemberRest

StaticMemberRest = ReadOnly cw AttributeRest / ReturnType cw OperationRest

ReadOnlyMember = "readonly" cwr ReadOnlyMemberRest

ReadOnlyMemberRest = AttributeRest 

ReadWriteAttribute = "inherit" cwr ReadOnly cw AttributeRest / AttributeRest

AttributeRest = "attribute" cwr Type cw AttributeName cw ";"

AttributeName = AttributeNameKeyword / identifier

AttributeNameKeyword = "required"

Inherit = "inherit"?

ReadOnly = "readonly"?

Operation = ReturnType cw OperationRest / SpecialOperation

SpecialOperation = Special cw Specials cw ReturnType cw OperationRest

Specials = (cw Special cw)*

Special = "getter"  / "setter"  / "deleter"  / "legacycaller"

OperationRest = OptionalIdentifier cw "(" cw ArgumentList cw ")" cw ";"

OptionalIdentifier = identifier?

ArgumentList = Argument (cw "," cw Argument)*

Argument = ExtendedAttributeList cw OptionalOrRequiredArgument

OptionalOrRequiredArgument = "optional" cwr Type cw ArgumentName cw Default / Type cw Ellipsis cw ArgumentName

ArgumentName = ArgumentNameKeyword / identifier

Ellipsis = "..."?

Iterable = "iterable" cw "<" cw Type cw ("," cw Type cw)? ">" cw ";"

ExtendedAttributeList = entries:("[" cw ExtendedAttribute (cw "," cw ExtendedAttribute)* cw "]")? {
    let arr = [];
    if (entries) {
        if (entries[2]) {
            arr.push(entries[2]);
        }
        if (entries[3].length) {
            arr = arr.concat(entries[3].map((entry) => entry[3]));
        }
    }
    return arr;
}

Other = integer  / float  / identifier  / string  / other  / "-"  / "-Infinity"  / "."  / "..."  / ":"  / ";"  / "<"  / "="  / ">"  / "?"  / "ByteString"  / "DOMString"  / "Infinity"  / "NaN"  / "USVString"  / "any"  / "boolean"  / "byte"  / "double"  / "false"  / "float"  / "long"  / "null"  / "object"  / "octet"  / "or"  / "optional"  / "sequence"  / "short"  / "true"  / "unsigned"  / "void"  / ArgumentNameKeyword  / BufferRelatedType 

ArgumentNameKeyword = "attribute"  / "callback"  / "const"  / "deleter"  / "dictionary"  / "enum"  / "getter"  / "implements"  / "inherit"  / "interface"  / "iterable"  / "legacycaller"  / "partial"  / "required"  / "serializer"  / "setter"  / "static"  / "stringifier"  / "typedef"  / "unrestricted"

OtherOrComma = Other / ","

Type = NonAnyType / "any" / UnionType cw Null

UnionType = "(" cw UnionMemberType cw "or" cw UnionMemberType cw UnionMemberTypes cw ")"

UnionMemberType = NonAnyType / UnionType cw Null

UnionMemberTypes = ("or" cw UnionMemberType cw UnionMemberTypes)?

NonAnyType = PrimitiveType cw Null  / PromiseType cw Null  / "ByteString" cw Null  / "DOMString" cw Null  / "USVString" cw Null  / identifier cw Null  / "sequence" cw "<" cw Type cw ">" cw Null  / "object" cw Null  / "Error" cw Null  / "DOMException" cw Null  / BufferRelatedType cw Null 

BufferRelatedType = "ArrayBuffer"  / "DataView"  / "Int8Array"  / "Int16Array"  / "Int32Array"  / "Uint8Array"  / "Uint16Array"  / "Uint32Array"  / "Uint8ClampedArray"  / "Float32Array"  / "Float64Array"

ConstType = PrimitiveType cw Null / identifier cw Null

PrimitiveType = UnsignedIntegerType  / UnrestrictedFloatType  / "boolean"  / "byte" / "octet"

UnrestrictedFloatType = "unrestricted" cw FloatType / FloatType

FloatType = "float" / "double"

UnsignedIntegerType = "unsigned" cw IntegerType / IntegerType

IntegerType = "short" / "long" cw OptionalLong?

OptionalLong = "long" 

PromiseType = "Promise" cw "<" cw ReturnType cw ">"

Null = "?"?

ReturnType = Type / "void"

IdentifierList = identifier (cw "," cw identifier)*

ExtendedAttribute = ExtendedAttributeFancyExtras / ExtendedAttributeArgList / ExtendedAttributeNoArgs
ExtendedAttributeNoArgs = identifier
ExtendedAttributeArgList = p1:identifier cw "(" cw p2:ArgumentList cw ")" { return p1 + "(" + p2 + ")"; }
ExtendedAttributeIdent = p1:identifier cw "=" cw p2:identifier { return p1 + "=" + p2; }
ExtendedAttributeIdentList = p1:identifier cw "=" cw "(" cw pN:IdentifierList cw ")" { return p1 + "=(" + pN + ")"; }
ExtendedAttributeNamedArgList = p1:identifier cw "=" cw p2:identifier cw "(" cw pN:ArgumentList cw ")" { return p1 + "=" + p2 + "(" + pN + ")"; }
ExtendedAttributeFancyExtras =  p1:identifier cw "=" cw pN:( identifier / [()|\":] / whitespace / comment )+ { return p1 + "=" + pN.join(""); }

octdigit = [0-7]
decdigit = [0-9]
hexdigit = [0-9a-zA-Z]

integer = "-"? (decinteger / hexinteger / octinteger)

decinteger = decdigit+
hexinteger = "0" [Xx] hexdigit+
octinteger = "0" octdigit

float = "-"? (((decdigit+ "." decdigit* / decdigit* "." decdigit+) ([Ee] [+-]? decdigit+)?)/(decdigit+[Ee][+-]?decdigit+))

identifier = p1:"_"? p2:[A-Za-z] p3:[-_A-Za-z0-9]* { return (p1 ? p1 : "") + p2 + p3.join(""); }

string = p1:'"' p2:[^\"]* p3:'"' { return p1 + p2.join("") + p3; }

cwi = (whitespace / comment) { return; }
cw = cwi* { return; }
cwr = cwi+ { return; }

whitespace = [\t\n\r ]+

comment = "\/\/" [^\n]* / "\/\*" ("."/"\n")* "\*\/"

other = [^\t\n\r 0-9A-Za-z]