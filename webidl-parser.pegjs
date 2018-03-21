Definitions = pN:(cw ExtendedAttributeList cw Definition)* cw {
    return pN.map(entry => { 
        let result = entry[3];
        result.attrs = entry[1];
        return result;
    });
}

Definition = Callback / Partial / Interface / Dictionary / Enum / Typedef / ImplementsStatement

Callback = "callback" cwr (CallbackRest / Interface)

Interface = kind:"interface" cwr mixin:("mixin" cw)? name:identifier cw Inheritance? cw "{" cw members:InterfaceMembers cw "}" cw ";" {
    return {kind, name, members, mixin};
}

Partial = "partial" cwr interfaceOrDict:(PartialInterface / PartialDictionary) { return interfaceOrDict; }

PartialInterface = kind:"interface" cwr mixin:("mixin" cw)? name:identifier membersContainer:(cw "{" InterfaceMembers cw "}")? cw ";" {
    let members = [];
    if (membersContainer) {
        members = membersContainer[2];
    }
    return {kind, name, members, mixin};
}

InterfaceMembers = pN:(cw ExtendedAttributeList cw InterfaceMember)* {
    return pN.map(entry => { 
        let result = entry[3]; 
        result.attrs = entry[1]; 
        return result; 
    });
}

InterfaceMember = Const / Operation / SpecialOperation / Serializer / Stringifier / StaticMember / Iterable / ReadOnlyMember / ReadWriteAttribute 

Dictionary = "dictionary" cwr identifier cw Inheritance? cw "{" cw DictionaryMembers cw "}" cw ";"

DictionaryMembers = (cw ExtendedAttributeList cw DictionaryMember)*

DictionaryMember = ("required" cwr)? Type cw identifier (cw Default)? cw ";"

PartialDictionary = "dictionary" cwr identifier cwr "{" cw DictionaryMembers cw "}" cw ";"

Default = "=" cw DefaultValue

DefaultValue = ConstValue / string / "[" cw "]"

Inheritance = ":" cw identifier

Enum = "enum" cwr identifier cw "{" cw EnumValueList cw "}" cw ";"

EnumValueList = string (cw "," cw string)*

CallbackRest = identifier cw "=" cw ReturnType cw (identifier cw)? "(" cw ArgumentList? cw ")" cw ";"

Typedef = "typedef" cw Type cw identifier cw ";"

ImplementsStatement = derived:identifier cw ("implements"/"includes") cwr base:identifier cw ";" {
    return {kind: "includes", derived, base};
}

Const = kind:"const" cwr type:ConstType cw name:identifier cw "=" cw value:ConstValue cw ";" { return { kind, type, name, value }; }

ConstValue = BooleanLiteral / FloatLiteral / integer / string / "null"

BooleanLiteral = "true" / "false" / "VARIANT_TRUE" / "VARIANT_FALSE"

FloatLiteral = float / "-Infinity" / "Infinity" / "NaN"

Serializer = "serializer" cw SerializerRest

SerializerRest = OperationRest / "=" cw SerializationPattern cw ";" / ";"

SerializationPattern = "{" cw SerializationPatternMap? cw "}" / "[" cw SerializationPatternList? cw "]" / identifier

SerializationPatternMap = "getter" / "inherit" ( cw "," cw identifier)* / identifier ( cw "," cw identifier)*

SerializationPatternList = "getter" / identifier (cw "," cw identifier)*

Stringifier = "stringifier" cw StringifierRest

StringifierRest = ReadOnly cw AttributeRest / Operation / ";"

StaticMember = "static" cwr member:StaticMemberRest { return member; }

StaticMemberRest = ReadOnly cw result:AttributeRest / result:Operation { return result; }

ReadOnlyMember = "readonly" cwr member:AttributeRest { return member; }

ReadWriteAttribute = "inherit" cwr ReadOnly cw attr:AttributeRest / attr:AttributeRest { return attr; }

AttributeRest = kind:"attribute" cwr type:Type cw name:AttributeName cw ";" { return { kind, type, name }; }

AttributeName = identifier

Inherit = "inherit"?

ReadOnly = "readonly"?

Operation = returnType:ReturnType cw rest:OperationRest { return { kind: "operation", returnType, name: rest.name, args: rest.args || [] }; }

SpecialOperation = Special cw Specials cw operation:Operation { return operation; }

Specials = (cw Special cw)*

Special = "getter"  / "setter"  / "deleter"  / "legacycaller"

OperationRest = name:identifier? cw "(" cw args:ArgumentList? cw ")" cw ";" { return { name, args }; }

ArgumentList = arg1:Argument argN:(cw "," cw Argument)* { return [arg1].concat(argN.map(entry => entry[3])); }

Argument = ExtendedAttributeList cw OptionalOrRequiredArgument

OptionalOrRequiredArgument = "optional" cwr Type cw ArgumentName (cw Default)? / Type cw Ellipsis cw ArgumentName (cw Default)?

ArgumentName = identifier / ArgumentNameKeyword

Ellipsis = "..."?

Iterable = "iterable" cw "<" cw Type cw ("," cw Type cw)? ">" cw ";"

ExtendedAttributeList = entries:("[" cw ExtendedAttribute (cw ("," / "]" cw "[") cw ExtendedAttribute)* cw "]")? {
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

Other = integer  / float  / identifier  / string  / other  / "-"  / "-Infinity"  / "."  / "..."  / ":"  / ";"  / "<"  / "="  / ">"  / "?"  / "ByteString"  / "DOMString"  / "Infinity"  / "NaN"  / "USVString"  / "any"  / "boolean"  / "byte"  / "double"  / "false"  / "VARIANT_FALSE" / "float"  / "long"  / "null"  / "object"  / "octet"  / "or"  / "optional"  / "sequence"  / "short"  / "true" / "VARIANT_TRUE" / "unsigned"  / "void"  / ArgumentNameKeyword  / BufferRelatedType 

ArgumentNameKeyword = "attribute"  / "callback"  / "const"  / "deleter"  / "dictionary"  / "enum"  / "getter"  / "implements"  / "inherit"  / "interface"  / "iterable"  / "legacycaller"  / "partial"  / "required"  / "serializer"  / "setter"  / "static"  / "stringifier"  / "typedef"  / "unrestricted"

OtherOrComma = Other / ","

Type = NonAnyType / "any" / UnionType cw Null

UnionType = "(" cw UnionMemberType cw "or" cw UnionMemberType cw UnionMemberTypes cw ")"

UnionMemberType = NonAnyType / UnionType cw Null

UnionMemberTypes = ("or" cw UnionMemberType cw UnionMemberTypes)?

NonAnyType =  ("FrozenArray" / "sequence" / "record") cw "<" cw Type (cw "," cw Type)* cw ">" cw Null / PrimitiveType cw Null  / PromiseType cw Null  / identifier cw Null  / "ByteString" cw Null  / "DOMString" cw Null  / "USVString" cw Null  / "object" cw Null  / "Error" cw Null  / "DOMException" cw Null  / BufferRelatedType cw Null 

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

ExtendedAttribute = ExtendedAttributeExpr
ExtendedAttributeExpr = ("[" ExtendedAttributeExpr? "]" / [^,\]])+

ExtendedAttributeForActualParsing = ExtendedAttributeArgList / ExtendedAttributeIdentList / ExtendedAttributeFancyExtras / ExtendedAttributeIdent / ExtendedAttributeNoArgs
ExtendedAttributeNoArgs = identifier
ExtendedAttributeArgList = p1:identifier cw "(" cw p2:(ArgumentList)? cw ")" { return p1 + "(" + p2 + ")"; }
ExtendedAttributeIdent = p1:identifier cw "=" cw p2:(identifier / DefaultValue) { return p1 + "=" + p2; }
ExtendedAttributeIdentList = p1:identifier cw "=" cw "(" cw pN:IdentifierList cw ")" { return p1 + "=(" + pN + ")"; }
ExtendedAttributeNamedArgList = p1:identifier cw "=" cw p2:identifier cw "(" cw pN:ArgumentList cw ")" { return p1 + "=" + p2 + "(" + pN + ")"; }
ExtendedAttributeFancyExtras =  p1:identifier cw "=" cw pN:(string / identifier / [()|\":] / whitespace / comment)+ { return p1 + "=" + pN.join(""); }

octdigit = [0-7]
decdigit = [0-9]
hexdigit = [0-9a-zA-Z]

integer = "-"? (hexinteger / octinteger / decinteger)

decinteger = decdigit+
hexinteger = "0" [xX] hexdigit+
octinteger = "0" octdigit

float = "-"? (((decdigit+ "." decdigit* / decdigit* "." decdigit+) ([Ee] [+-]? decdigit+)?)/(decdigit+[Ee][+-]?decdigit+))

identifier = p1:"_"? p2:[A-Za-z] p3:[-_A-Za-z0-9]* { return (p1 ? p1 : "") + p2 + p3.join(""); }

string = p1:'"' p2:[^\"]* p3:'"' { return p1 + p2.join("") + p3; }

cwi = (whitespace / comment) { return; }
cw = cwi* { return; }
cwr = cwi+ { return; }

whitespace = [\t\n\r ]+

comment = "//" [^\n]* / "/*" (!"*/" .)* "*/"

other = [^\t\n\r 0-9A-Za-z]