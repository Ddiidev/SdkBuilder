<#list usings as using>using ${using};
</#list>
namespace ${full_namespace}
{
    public struct ${name_struct}Interop
    {
<#list props as prop><#if prop.relation_typ != ''>
        public ${prop.relation_typ}Interop ${prop.name};<#else>
        public ${prop.typ} ${prop.name};</#if>
</#list>
    }

    public struct ${name_struct}
    {
<#list props as prop><#if prop.relation_typ != ''>
        public ${prop.relation_typ} ${prop.name};<#else>
        public ${prop.typ} ${prop.name};</#if>
</#list>

        public ${name_struct}(${arguments}) {
<#list props as prop><#if prop.relation_typ != ''>
            ${prop.name} = new ${prop.relation_typ}(${arg_prefix}${prop.name});<#else>
            ${prop.name} = ${arg_prefix}${prop.name};</#if>
</#list>
        }
    }
}