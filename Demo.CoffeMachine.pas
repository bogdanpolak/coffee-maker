unit Demo.CoffeMachine;

interface

uses
  Classes,
  Rtti;

procedure ExecuteDemoCoffeeMachine;

implementation

uses
  Delphi.Mocks,
  Model.CoffeMachine;

type
  TDemoCoffeeMachine = class
    class var fCoffeeMachine: TCoffeeMachine;
    class procedure S01_BasicSample;
    class procedure S02_Veryfication;
  end;

class procedure TDemoCoffeeMachine.S01_BasicSample;
var
  aMachineTester: TStub<IMachineTester>;
  aCoffee: TCoffee;
begin
  aMachineTester := TStub<IMachineTester>.Create;
  aMachineTester.Setup.WillReturn(True).When.IsReadyToBrewCoffee;

  fCoffeeMachine := TCoffeeMachine.Create(
    {} TMock<IBrewingUnit>.Create,
    {} TMock<IGrinder>.Create,
    {} TMock<IUserPanel>.Create,
    {} aMachineTester);

  aCoffee := fCoffeeMachine.BrewCoffee(csEspresso);

  writeln(aCoffee.ToString);
  fCoffeeMachine.Free;
end;

class procedure TDemoCoffeeMachine.S02_Veryfication;
{var
  mockBrewingUnit: TMock<IBrewingUnit>;
  mockGrinder: TMock<IGrinder>;
  mockUserPanel: TMock<IUserPanel>;
  mockMachineTester: TMock<IMachineTester>; }
begin
  {mockBrewingUnit := TMock<IBrewingUnit>.Create;
  mockGrinder := TMock<IGrinder>.Create;
  mockUserPanel := TMock<IUserPanel>.Create;
  mockMachineTester := TMock<IMachineTester>.Create;
  mockMachineTester.Setup.WillReturn(True).When.IsReadyToBrewCoffee;}
end;

procedure ExecuteDemoCoffeeMachine;
begin
  TDemoCoffeeMachine.S01_BasicSample;
  writeln('Done ... hit Enter to finish ...');
end;

end.
