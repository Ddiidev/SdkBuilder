    public @{name_class_dl}()
    {
    	DlPtr = Dl.LoadLibrary("./@{path_dl_with_ext}");

    	if (DlPtr == IntPtr.Zero)
    		throw new Exception("Failed do import Library");

    @for function in functions
        ${function.variable_function} = Dl.PtrFunction< @{function.delegate_function} >(DlPtr, @{function.name_function_dl})!;
    @end
    }
