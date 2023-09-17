using System.Runtime.InteropServices;

namespace @{name_space_project}.Interop
{
    public struct VString
    {
        public string stringCSharp;
        public IntPtr str;
        public int len;

        public VString(VStringInterop vs)
        {
            stringCSharp = string.Empty;
            str = vs.str;
            len = vs.len;
            ToString();
        }

        public override string ToString()
        {
            return stringCSharp.Length == len
                ? stringCSharp
                : (stringCSharp = Marshal.PtrToStringUTF8(str) ?? "");
        }

        public static implicit operator string(VString vs) => vs.ToString();

        public static implicit operator VString(string s)
        {
            return new VString
            {
                str = Marshal.StringToCoTaskMemUTF8(s),
                stringCSharp = s,
                len = s.Length
            };
        }
    }
}
