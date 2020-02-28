program CoffeeMaker;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}

{$R *.res}

uses
  System.SysUtils,
  Delphi.Mocks.AutoMock in 'delphi-mocks\Delphi.Mocks.AutoMock.pas',
  Delphi.Mocks.Behavior in 'delphi-mocks\Delphi.Mocks.Behavior.pas',
  Delphi.Mocks.Expectation in 'delphi-mocks\Delphi.Mocks.Expectation.pas',
  Delphi.Mocks.Helpers in 'delphi-mocks\Delphi.Mocks.Helpers.pas',
  Delphi.Mocks.Interfaces in 'delphi-mocks\Delphi.Mocks.Interfaces.pas',
  Delphi.Mocks.MethodData in 'delphi-mocks\Delphi.Mocks.MethodData.pas',
  Delphi.Mocks.ObjectProxy in 'delphi-mocks\Delphi.Mocks.ObjectProxy.pas',
  Delphi.Mocks.ParamMatcher in 'delphi-mocks\Delphi.Mocks.ParamMatcher.pas',
  Delphi.Mocks in 'delphi-mocks\Delphi.Mocks.pas',
  Delphi.Mocks.Proxy in 'delphi-mocks\Delphi.Mocks.Proxy.pas',
  Delphi.Mocks.Proxy.TypeInfo in 'delphi-mocks\Delphi.Mocks.Proxy.TypeInfo.pas',
  Delphi.Mocks.ReturnTypePatch in 'delphi-mocks\Delphi.Mocks.ReturnTypePatch.pas',
  Delphi.Mocks.Utils in 'delphi-mocks\Delphi.Mocks.Utils.pas',
  Delphi.Mocks.Validation in 'delphi-mocks\Delphi.Mocks.Validation.pas',
  Delphi.Mocks.VirtualInterface in 'delphi-mocks\Delphi.Mocks.VirtualInterface.pas',
  Delphi.Mocks.VirtualMethodInterceptor in 'delphi-mocks\Delphi.Mocks.VirtualMethodInterceptor.pas',
  Delphi.Mocks.WeakReference in 'delphi-mocks\Delphi.Mocks.WeakReference.pas',
  Delphi.Mocks.When in 'delphi-mocks\Delphi.Mocks.When.pas',
  Model.CoffeMachine in 'Model.CoffeMachine.pas',
  Demo.CoffeMachine in 'Demo.CoffeMachine.pas',
  Engine.TestRunner in 'Engine.TestRunner.pas';

begin
  ExecuteTestRunner;

  {
  try
    ExecuteDemoCoffeeMachine;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
  }
end.
