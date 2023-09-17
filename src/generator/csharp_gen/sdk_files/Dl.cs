using System.Runtime.InteropServices;

namespace @{name_space_project}.Interop
{
    public static class Dl
    {
        [DllImport("kernel32.dll")]
        public static extern IntPtr LoadLibrary(string dllToLoad);

        [DllImport("kernel32.dll")]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procedureName);

        [DllImport("kernel32.dll")]
        public static extern bool FreeLibrary(IntPtr hModule);

        /// <summary>
        /// Get function from pointer
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="dlHandle"></param>
        /// <param name="nameFunction"></param>
        /// <returns></returns>
        public static T? PtrFunction<T>(IntPtr dlHandle, string nameFunction)
        {
            if (dlHandle != IntPtr.Zero)
            {
                var ptrAddressFunc = GetProcAddress(dlHandle, nameFunction);

                return Marshal.GetDelegateForFunctionPointer<T>(ptrAddressFunc);
            }

            return default;
        }
    }
}
