@for using in usings
using @{using};
@end

namespace @{name_space} . @{name_space}Interop . @{project_name}
{
    // StructInterop pure
    public struct @{name_struct}Interop
    {
@for prop in props
    @if prop.relation_typ != ''
        public @{prop.relation_typ}Interop @{prop.name};
    @else
        public @{prop.typ} @{prop.name};
    @end
@end
    }

    // StructInterop with relation
    public struct @{name_struct}
    {
        // Properties

@for prop in props
    @if prop.relation_typ != ''
        public @{prop.relation_typ} @{prop.name};
    @else
        public @{prop.typ} @{prop.name};
    @end
@end

        // Constructor
        public @{name_struct}(@{arguments}) {
    @for prop in props
        @if prop.relation_typ != ''
            @{prop.name} = new @{prop.relation_typ}(_arg. @{prop.name});
        @else
            @{prop.name} = _arg. @{prop.name};
        @end
    @end
        }
    }
}
