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
var
  aBrewingUnit: TMock<IBrewingUnit>;
  aGrinder: TMock<IGrinder>;
  aUserPanel: TMock<IUserPanel>;
  aMachineTester: TMock<IMachineTester>;
  aCoffee: TCoffee;
begin
  aBrewingUnit := TMock<IBrewingUnit>.Create;
  aGrinder := TMock<IGrinder>.Create;
  aUserPanel := TMock<IUserPanel>.Create;
  aMachineTester := TMock<IMachineTester>.Create;

  aMachineTester.Setup.WillReturn(True).When.IsReadyToBrewCoffee;

  aMachineTester.Setup.Expect.Once.When.IsReadyToBrewCoffee;
  aGrinder.Setup.Expect.Once.When.SetGrindSize(gsFine);
  aGrinder.Setup.Expect.Once.When.GrindCoffeeBeans(8.0 {mg coffee});
  aBrewingUnit.Setup.Expect.Once.When.PressCoffe;
  aBrewingUnit.Setup.Expect.Once.When.BrewWater(30.0 {ml water});
  aBrewingUnit.Setup.Expect.Once.When.PressWater(9.0 {bar});
  aBrewingUnit.Setup.Expect.Once.When.TrashCoffe;
  aUserPanel.Setup.Expect.Exactly(1).When.CoffeeInProgress(True);
  aUserPanel.Setup.Expect.Exactly(1).When.CoffeeInProgress(False);

  fCoffeeMachine := TCoffeeMachine.Create(
    {} aBrewingUnit,
    {} aGrinder,
    {} aUserPanel,
    {} aMachineTester);

  aCoffee := fCoffeeMachine.BrewCoffee(csEspresso);

  writeln(aCoffee.ToString);

  aMachineTester.Verify;
  aGrinder.Verify;
  aBrewingUnit.Verify;
  aUserPanel.Verify;

  fCoffeeMachine.Free;

end;

procedure ExecuteDemoCoffeeMachine;
begin
  TDemoCoffeeMachine.S02_Veryfication;
  writeln('Done ... hit Enter to finish ...');
end;

end.
