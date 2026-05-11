using ${namespace_interop};
namespace ${full_namespace}
{
    public class ${project_name} : IDisposable
    {
        private IntPtr DlPtr;
<#list delegates as delegate>
${delegate.content}
</#list>
${constructor_dl}

        public void Dispose()
        {
            Dl.FreeLibrary(DlPtr);
            GC.SuppressFinalize(this);
        }
    }
}