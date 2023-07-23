// This is an Unreal Script
class ChosenDataScreen extends UIPersonnel dependson(XComGameState_ChosenData);

var UIPersonnel ChosenDataList;
var UINavigationHelp NavHelp;
var ChosenData_ListItem LastHighlighted;


simulated function InitChosenDataScreen()
{
	ChosenDataList = Spawn(class'UIPersonnel', self);
	// ChosenDataList.OverrideInterpTime = 0.0;
	ChosenDataList.m_eListType = eUIPersonnel_Scientists;
	ChosenDataList.bIsNavigable = true;
	// ChosenDataList.OnItemClicked = OnSquadSelected;
	MC.FunctionString("SetScreenHeader", "Chosen Information");
}

simulated function OnListItemClicked(UIList ContainerList, int ItemIndex) {
	if (!ChosenData_ListItem(ContainerList.GetItem(ItemIndex)).IsDisabled) {
		OpenChosenDetails(ChosenData_ListItem(ContainerList.GetItem(ItemIndex)));
	}
}

// I have the list item, but how do I get the data?
simulated function OpenChosenDetails(ChosenData_ListItem Data) {
	local TDialogueBoxData DialogData;
	local String StrDetails;
	local ChosenFiles Detail;
	local Texture2D StaffPicture;
	local int i;
	Detail = Data.Data;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = Detail.ChosenName;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;

	DialogData.strText = StrDetails;
	DialogData.strImagePath = class'UIUtilities_Image'.static.ValidateImagePath(Detail.ChosenIcon);
	Movie.Pres.UIRaiseDialog( DialogData );
}

simulated function CreateSortHeaders()
{
	//1st two are 'not needed' but is for the flash stuff ? Dunno, the whole dropdown menu goes haywire without them
	m_kSoldierSortHeader = Spawn(class'UIPanel', self);
	m_kSoldierSortHeader.bIsNavigable = false;
	m_kSoldierSortHeader.InitPanel('soldierSort', 'SoldierSortHeader');
	m_kSoldierSortHeader.Hide();

	m_kDeceasedSortHeader = Spawn(class'UIPanel', self);
	m_kDeceasedSortHeader.bIsNavigable = false;
	m_kDeceasedSortHeader.InitPanel('deceasedSort', 'DeceasedSortHeader');
	m_kDeceasedSortHeader.Hide();

	//the one we actually want to adjust
	m_kPersonnelSortHeader = Spawn(class'UIPanel', self);
	m_kPersonnelSortHeader.bIsNavigable = false;
	m_kPersonnelSortHeader.InitPanel('personnelSort', 'PersonnelSortHeader');
	m_kPersonnelSortHeader.Hide();

	// Create Bestiary header 
	if(m_arrNeededTabs.Find(eUIPersonnel_Scientists) != INDEX_NONE)
	{
		Spawn(class'UIFlipSortButton', m_kPersonnelSortHeader).InitFlipSortButton("nameButton", ePersonnelSoldierSortType_Name, "name");
		Spawn(class'UIFlipSortButton', m_kPersonnelSortHeader).InitFlipSortButton("statusButton", ePersonnelSoldierSortType_Status, "status");
	}
}


simulated function OnCancel()
{
	Movie.Stack.PopFirstInstanceOfClass(class'ChosenDataScreen');

	Movie.Pres.PlayUISound(eSUISound_MenuClose);
}

simulated function PopulateListInstantly() {
	local XComGameState_ChosenData Info;
	local int i;
	Info = XComGameState_ChosenData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_ChosenData', true));
	for (i = 0; i < Info.ChosenDocs.Length; i++) {
		m_kList.OnItemClicked = OnListItemClicked;
		Spawn(class'ChosenData_ListItem', m_kList.itemContainer).InitListItem(Info.ChosenDocs[i]);
	}
	MC.FunctionString("SetEmptyLabel", Info.ChosenDocs.Length == 0 ? "No Chosen Encountered": "");
}

simulated function PopulateListSequentially(UIPanel Control) {
	PopulateListInstantly();
}

simulated function UpdateData() {
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local int i;
    	
	History = `XCOMHISTORY;

	// Destroy old data
	m_arrSoldiers.Length = 0;	m_arrScientists.Length = 0;	m_arrEngineers.Length = 0;	m_arrDeceased.Length = 0;

}

defaultproperties
{
	MCName          = "theScreen";
	Package = "/ package/gfxSoldierList/SoldierList";
	bConsumeMouseEvents = true;
	m_eListType=eUIPersonnel_Scientists;
}