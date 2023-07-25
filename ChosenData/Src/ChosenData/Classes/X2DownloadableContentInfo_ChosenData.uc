//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ChosenData.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ChosenData extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	CheckUpdateOrCreateNewGameState();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	CheckUpdateOrCreateNewGameState();
}

static event OnPostMission() {
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local X2MissionTemplateManager MissionTemplateManager;
	local X2MissionTemplate MissionTemplate;
	local XComGameState NewGameState;
	local XComGameState_ChosenData Information;

	MissionTemplateManager = class'X2MissionTemplateManager'.static.GetMissionTemplateManager();
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionTemplate = MissionTemplateManager.FindMissionTemplate(BattleData.MapData.ActiveMission.MissionName);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Check, create or Update Chosen Information");
	Information = XComGameState_ChosenData(History.GetSingleGameStateObjectForClass(class 'XComGameState_ChosenData', true));
	Information = XComGameState_ChosenData(NewGameState.ModifyStateObject(Information.Class, Information.ObjectID));

	if (MissionTemplate.DisplayName == "Defeat Chosen Warlock") {
		Information.updateChosenActiveState("Warlock");
		 `GAMERULES.SubmitGameState(NewGameState);
	} else if (MissionTemplate.DisplayName == "Defeat Chosen Assassin") {
		Information.updateChosenActiveState("Assassin");
		 `GAMERULES.SubmitGameState(NewGameState);
	} else if (MissionTemplate.DisplayName == "Defeat Chosen Hunter") {
		Information.updateChosenActiveState("Hunter");
		 `GAMERULES.SubmitGameState(NewGameState);
	}
	
}



static final function CheckUpdateOrCreateNewGameState()
{
	local XComGameState_ChosenData Information;
    local XComGameState NewGameState;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
    Information = XComGameState_ChosenData(History.GetSingleGameStateObjectForClass(class 'XComGameState_ChosenData', true));

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Check, create or Update Chosen Information");

    if (Information == none)
    {
        Information = XComGameState_ChosenData(NewGameState.CreateNewStateObject(class'XComGameState_ChosenData'));
    }
    else
    {
        Information = XComGameState_ChosenData(NewGameState.ModifyStateObject(Information.Class, Information.ObjectID));
    }

    Information.UpdateChosenInformation();

    `GAMERULES.SubmitGameState(NewGameState);
}