unit Model.CoffeMachine;

interface

uses
  SysUtils,
  Math;

type
  TGrindSize = (gsSuperFine, gsFine, gsMediumFine, gsMedium);
  TCoffeeSelection = (csNone, csRistretto, csEspresso, csDoppio, csLungo);
  TBeanAmount = (baClassic, baLight, bsExtraStrong);
  TMachineWarning = (mnNonw, mwNoBeans, mwNoWater, mvGrinderJammed,
    mvDeviceDamage);

type
  TCoffee = record
    Selection: TCoffeeSelection;
    TemperatureC: double;
    WaterML: double;
    class function Create(aSelection: TCoffeeSelection; aTemperatureC: double;
      aWaterML: double): TCoffee; static;
    function ToString: string;
  end;

  TBeanPortion = record
  end;

  TWaterPortion = record
  end;

type
  IBeansContainer = interface(IInvokable)
    function IsContainerLoaded: boolean;
    function AreBeansAvaliable: boolean;
    function ProvideCoffeeBeans: TBeanPortion;
  end;

  IGrinder = interface(IInvokable)
    function IsReady: boolean;
    procedure SetGrindSize(aGrindSize: TGrindSize);
    procedure GrindCoffeeBeans(aWeightInGrams: double);
  end;

  IWaterContainer = interface(IInvokable)
    function IsContainerLoaded: boolean;
    function IsWarterAvaliable: boolean;
    function ProvideWarer(aMilliliters: double): TWaterPortion;
  end;

  IUserPanel = interface(IInvokable)
    procedure SetWarning(aWarning: TMachineWarning; aStatus: boolean);
    procedure CoffeeInProgress(isInProgress: boolean);
  end;

  IBrewingUnit = interface(IInvokable)
    procedure SetWaterTemperature(aWaterTemperatureInCelsius: double);
    procedure PressCoffe;
    procedure BrewWater(aMilliliters: double);
    procedure PressWater(aBarPressure: double);
    procedure TrashCoffe;
  end;

  IMachineTester = interface(IInvokable)
    function IsReadyToBrewCoffee: boolean;
    procedure DisplayStatus(aUserPanel: IUserPanel);
  end;

  TMachineTester = class(TInterfacedObject, IMachineTester)
  strict private
    fBeansContainer: IBeansContainer;
    fGrinder: IGrinder;
    fWaterContainer: IWaterContainer;
  public
    constructor Create(aBeansContainer: IBeansContainer; aGrinder: IGrinder;
      aWaterContainer: IWaterContainer);
    function IsReadyToBrewCoffee: boolean;
    procedure DisplayStatus(aUserPanel: IUserPanel);
  end;

  TCoffeeMachine = class
  strict private
    fGrinder: IGrinder;
    fBrewingUnit: IBrewingUnit;
    fUserPanel: IUserPanel;
    fMachineTester: IMachineTester;
  private
    fBeanAmount: TBeanAmount;
    function GetCoffeeWeight(aSelection: TCoffeeSelection): double;
    function GetWaterAmount(aSelection: TCoffeeSelection): double;
    function GetGrindSize(aSelection: TCoffeeSelection): TGrindSize;
  protected
  public
    constructor Create(aBrewingUnit: IBrewingUnit; aGrinder: IGrinder;
      aUserPanel: IUserPanel; aMachineTester: IMachineTester);
    procedure SetBeanAmount(aBeanAmount: TBeanAmount);
    function BrewCoffee(aSelection: TCoffeeSelection): TCoffee;
  end;

type
  EMachineError = class(Exception);

implementation

constructor TCoffeeMachine.Create(aBrewingUnit: IBrewingUnit;
  aGrinder: IGrinder; aUserPanel: IUserPanel; aMachineTester: IMachineTester);
begin
  fGrinder := aGrinder;
  fBrewingUnit := aBrewingUnit;
  fUserPanel := aUserPanel;
  fMachineTester := aMachineTester;
  fBeanAmount := baClassic;
end;

function TCoffeeMachine.GetCoffeeWeight(aSelection: TCoffeeSelection): double;
const
  aCoffeeWeight: array [TBeanAmount, TCoffeeSelection] of double =
    {    baClassic: } ((0, 7.0, 8.0, 16.0, 8.0),
    {      baLight:  } (0, 7.0, 7.0, 14.0, 7.0),
    { bsExtraStrong: } (0, 8.0, 9.0, 18.0, 9.0));
begin
  Result := aCoffeeWeight[fBeanAmount, aSelection];
end;

function TCoffeeMachine.GetWaterAmount(aSelection: TCoffeeSelection): double;
begin
  Result := 0;
  case aSelection of
    csRistretto:
      Result := 20.0;
    csEspresso:
      Result := 30.0;
    csDoppio:
      Result := 60.0;
    csLungo:
      Result := 45.0
  else
    Result := 0
  end;
end;

function TCoffeeMachine.GetGrindSize(aSelection: TCoffeeSelection): TGrindSize;
begin
  Result := gsFine;
  case aSelection of
    csRistretto:
      Result := gsSuperFine;
    csEspresso, csDoppio:
      Result := gsFine;
    csLungo:
      Result := gsFine;
  end;
end;

procedure TCoffeeMachine.SetBeanAmount(aBeanAmount: TBeanAmount);
begin
  fBeanAmount := aBeanAmount;
end;

function TCoffeeMachine.BrewCoffee(aSelection: TCoffeeSelection): TCoffee;
const
  WaterTemperatureInCelsius = 85;
  WaterPressureInBars = 9.0;
var
  aWaterAmount: double;
begin
  Result.Selection := csNone;
  fBrewingUnit.SetWaterTemperature(WaterTemperatureInCelsius);

  if fMachineTester.IsReadyToBrewCoffee then
  begin
    fUserPanel.CoffeeInProgress(True);
    try
      fGrinder.SetGrindSize(GetGrindSize(aSelection));
      fGrinder.GrindCoffeeBeans(GetCoffeeWeight(aSelection));
      fBrewingUnit.PressCoffe;
      aWaterAmount := GetWaterAmount(aSelection);
      fBrewingUnit.BrewWater(aWaterAmount);
      fBrewingUnit.PressWater(WaterPressureInBars);
      Result.Selection := aSelection;
      Result.TemperatureC := WaterTemperatureInCelsius;
      Result.WaterML := aWaterAmount;
      fBrewingUnit.TrashCoffe;
    finally
      fUserPanel.CoffeeInProgress(False);
    end;
  end;
  fMachineTester.DisplayStatus(fUserPanel);
end;

{ TMachineTester }

constructor TMachineTester.Create(aBeansContainer: IBeansContainer;
  aGrinder: IGrinder; aWaterContainer: IWaterContainer);
begin
  fBeansContainer := aBeansContainer;
  fGrinder := aGrinder;
  fWaterContainer := aWaterContainer;
end;

procedure TMachineTester.DisplayStatus(aUserPanel: IUserPanel);
begin

end;

function TMachineTester.IsReadyToBrewCoffee: boolean;
begin
  Result :=
    {} fBeansContainer.IsContainerLoaded and
    {} fBeansContainer.AreBeansAvaliable and
    {} fGrinder.IsReady and
    {} fWaterContainer.IsContainerLoaded and
    {} fWaterContainer.IsWarterAvaliable;
end;

class function TCoffee.Create(aSelection: TCoffeeSelection;
  aTemperatureC, aWaterML: double): TCoffee;
begin
  Result.Selection := aSelection;
  Result.TemperatureC := aTemperatureC;
  Result.WaterML := aWaterML;
end;

function TCoffee.ToString: string;
begin
  case Selection of
    csRistretto:
      Result := Format('Ristretto (%.1f°C, %.0f ml)', [TemperatureC, WaterML]);
    csEspresso:
      Result := Format('Espresso (%.1f°C, %.0f ml)', [TemperatureC, WaterML]);
    csDoppio:
      Result := Format('Doppio (%.1f°C, %.0f ml)', [TemperatureC, WaterML]);
    csLungo:
      Result := Format('Lungo (%.1f°C, %.0f ml)', [TemperatureC, WaterML]);
  else
    Result := '-- no coffee --';
  end;
end;

end.
