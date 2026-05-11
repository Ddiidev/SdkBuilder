using @{name_space}.Interop;
namespace @{name_space}. @{name_space}Interop. @{project_name} {
    public class @{project_name} : IDisposable {
        private IntPtr DlPtr;

@for _, delegate in delegates
		@{delegate.content.replace('\n', '\n\t')}
@end

@{constructor_dl.replace('\n', '\n\t')}

      public void Dispose()
      {
      	Dl.FreeLibrary(DlPtr);
      	GC.SuppressFinalize(this);
      }
    }
}
