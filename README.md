
# SdkBuilder

The idea is that you can develop your entire business rule in V and share it via .dll/.so/.dylib, the important thing is that your experience in the target language does not need to be adapted, it needs to be as if you had built it in your own language.

![ray-so-export](https://github.com/ldedev/SdkBuilder/assets/7676415/da738d19-6b82-44cc-b62e-851589552243)


## Funcionalidades

- [x] Functions that return primitive types.
- [x] Functions with struct return.
- [x] Basic implementation of V strings.
- [x] Passing arguments to functions with primitive types.
- [ ] Passing arguments to functions with structs.
- [ ] Implementation of struct methods.

## Linguagens suportadas

- [x] C# (Partial)
- [ ] V
- [ ] Python
- [ ] Php
## How to use

First you will need to create a configuration json file in the root folder of your V project.

```json
{
  "project": {
    "name": "MySimpleDll",
    "entry_point": "src/main.v",
    "compiler": "gcc",
    "prod": false
  },
  "target": {
    "language": "csharp",
    "namespace": "SimpleProjCS"
  }
}
```

And then you can run...        
```
> sdkBuilder "./Example/MySimpleDll/sdkbuilder.json"

Building SDK
Reading file conf. sdk
Generate AST for "C:\Users\AndreLuiz\Documents\SourceApps\Vlang\SdkTest\src/main.v"
Generating sdk, language target: csharp

-- Create folders --
...\SdkBuilder\projects_sdk\csharp\SimpleProjCSInterop
...\SdkBuilder\projects_sdk\csharp\SimpleProjCSInterop\Interop
...\SdkBuilder\projects_sdk\csharp\SimpleProjCSInterop\MySimpleDll

 -- Implementing structs -- 
-> Struct

 -- Implementing delegates -- 
-> ReturnInteger32Delegate
-> ReturnFloat32Delegate
-> ReturnStringDelegate
-> ReturnStructDelegate
-> ReturnVoidDelegate
-> InputArgsDelegate
-> FibonacciDelegate

 -- Implement constructor -- 
-> MySimpleDll

 -- Create files class sdk -- 
-> Struct.cs

 -- Create files class interop -- 
-> Dl.cs
-> VString.cs
-> VStringInterop.cs


Compiling the V library...
-> Name : MySimpleDll
-> Language : csharp
-> Compiler : gcc
-> Production : false
```

If you selected the csharp target like I did, it will be in the root folder of `/projects_sdk/csharp`, after which you can copy the entire folder to your project.



The C# code would look something like:
```csharp
using (var sdk = new MySimpleDll())
{

	Console.WriteLine(sdk.ReturnFloat32());
	Console.WriteLine(sdk.ReturnString());
	Console.WriteLine(sdk.ReturnInteger32());

	var struct_ = sdk.ReturnStruct();
	Console.WriteLine(struct_.s);
	Console.WriteLine(struct_.i);

	Console.WriteLine(sdk.Fibonacci(15));
	Console.WriteLine(sdk.InputArgs("1", 5));

}
```


Note that the method names are in good C# practices, because the idea here is to really have the experience of using a native Nuget lib.


## Demonstration

https://github.com/ldedev/SdkBuilder/assets/7676415/cb15451e-8b7a-49d4-bf7e-eddeed5b03c6


https://github.com/ldedev/SdkBuilder/assets/7676415/5a7e89d0-2ec7-4283-9adc-b81bbd6715fb




