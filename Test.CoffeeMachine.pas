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
    fBrewingUnit: TMock<IBrewingUnit>;
    fGrinder: TMock<IGrinder>;
    fUserPanel: TMock<IUserPanel>;
    fMachineTester: TMock<IMachineTester>;
  public
    [SetUp]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('Ristretto', 'csRistretto,7,gsSuperFine,20')]
    [TestCase('Espresso', 'csEspresso,8,gsFine,30')]
    [TestCase('Doppio', 'csDoppio,16,gsFine,60')]
    [TestCase('Lungo', 'csLungo,8,gsFine,45')]
    procedure BrewAndVerifyBehaviour(const aCoffeeSelection: TCoffeeSelection;
      aCoffeeWeight: double; aGrindSize: TGrindSize; aWaterAmount: double);
  published
    procedure NotReadyToBrewCoffee;
    procedure BrewingEspresso;
  end;
{$TYPEINFO OFF}

implementation

{ TestCoffeeMaker }

procedure TestCoffeeMaker.SetUp;
begin
  fBrewingUnit := TMock<IBrewingUnit>.Create;
  fGrinder := TMock<IGrinder>.Create;
  fUserPanel := TMock<IUserPanel>.Create;
  fMachineTester := TMock<IMachineTester>.Create;
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
  fMachineTester.SetUp.WillReturn(False).When.IsReadyToBrewCoffee;
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
  : TCoffeeSelection; aCoffeeWeight: double; aGrindSize: TGrindSize; aWaterAmount: double);
var
  aCoffee: TCoffee;
begin
  fMachineTester.SetUp.WillReturn(True).When.IsReadyToBrewCoffee;

  fMachineTester.SetUp.Expect.Once.When.IsReadyToBrewCoffee;
  fGrinder.SetUp.Expect.Once.When.SetGrindSize(aGrindSize);
  fGrinder.SetUp.Expect.Once.When.GrindCoffeeBeans(aCoffeeWeight {mg coffee});
  fBrewingUnit.SetUp.Expect.Once.When.PressCoffe;
  fBrewingUnit.SetUp.Expect.Once.When.BrewWater(aWaterAmount {ml water});
  fBrewingUnit.SetUp.Expect.Once.When.PressWater(9.0 {bar});
  fBrewingUnit.SetUp.Expect.Once.When.TrashCoffe;
  fUserPanel.SetUp.Expect.Exactly(1).When.CoffeeInProgress(True);
  fUserPanel.SetUp.Expect.Exactly(1).When.CoffeeInProgress(False);

  aCoffee := fCoffeeMachine.BrewCoffee(aCoffeeSelection);

  Assert.AreEqual(aCoffeeSelection, aCoffee.Selection);
  Assert.AreEqual(aWaterAmount, aCoffee.WaterML);
  fMachineTester.Verify;
  fGrinder.Verify;
  fBrewingUnit.Verify;
  fUserPanel.Verify;
end;

initialization

TDUnitX.RegisterTestFixture(TestCoffeeMaker);

end.
