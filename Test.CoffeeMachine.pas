unit Test.CoffeeMachine;

interface

uses
  Classes,
  Rtti,
  DUnitX.TestFramework,
  Delphi.Mocks,
  Model.CoffeMachine;

{$TYPEINFO ON}

type

  [TestFixture]
  TestCoffeeMaker = class(TObject)
  private
    // -----
    fCoffeeMachine: TCoffeeMachine;
    // -----
    fBrewingUnit: TStub<IBrewingUnit>;
    fGrinder: TStub<IGrinder>;
    fUserPanel: TStub<IUserPanel>;
    fMachineTester: TStub<IMachineTester>;
  public
    [SetUp]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('VerifyDoppioCoffee', 'csDoppio')]
    procedure BrewAndVerifyBehaviour(const aCoffeeSelection: TCoffeeSelection);
  published
    procedure NotReadyToBrewCoffee;
    procedure BrewingEspresso;
  end;
{$TYPEINFO OFF}

implementation

{ TestCoffeeMaker }

procedure TestCoffeeMaker.SetUp;
begin
  fBrewingUnit := TStub<IBrewingUnit>.Create;
  fGrinder := TStub<IGrinder>.Create;
  fUserPanel := TStub<IUserPanel>.Create;
  fMachineTester := TStub<IMachineTester>.Create;
  // ----
  fCoffeeMachine := TCoffeeMachine.Create(
    {} fBrewingUnit,
    {} fGrinder,
    {} fUserPanel,
    {} fMachineTester);
end;

procedure TestCoffeeMaker.TearDown;
begin
  fCoffeeMachine.Free;
end;

procedure TestCoffeeMaker.NotReadyToBrewCoffee;
var
  aCoffee: TCoffee;
begin
  aCoffee := fCoffeeMachine.BrewCoffee(csEspresso);
  Assert.AreEqual('-- no coffee --', aCoffee.ToString);
end;

procedure TestCoffeeMaker.BrewingEspresso;
var
  aCoffee: TCoffee;
begin
  fMachineTester.SetUp.WillReturn(True).When.IsReadyToBrewCoffee;
  aCoffee := fCoffeeMachine.BrewCoffee(csEspresso);
  Assert.AreEqual('Espresso (85,0°C, 30 ml)', aCoffee.ToString);
end;

procedure TestCoffeeMaker.BrewAndVerifyBehaviour(const aCoffeeSelection
  : TCoffeeSelection);
begin
  Assert.AreEqual(csDoppio, aCoffeeSelection);
end;

initialization

TDUnitX.RegisterTestFixture(TestCoffeeMaker, 'Test CoffeeMaker');

end.
