// This is an Unreal Script
class XComGameState_ChosenData extends XComGameState_BaseObject;


struct AbilitySummaries {
	var String AbilityName;
	var String AbilityDescription;
};


struct ChosenFiles {
	var array<AbilitySummaries> Strengths; // might be easier to just have as an array of names like the data file.
	var array<AbilitySummaries> Weaknesses;
	var bool bIsActive;
	var String ChosenIcon;
	var String ChosenLogo;
	var String ChosenName;
	var String ChosenType;
};

var array<ChosenFiles> ChosenDocs;


function UpdateChosenInformation() {

	local XComGameState_AdventChosen ChosenState;
	local XComGameStateHistory History;
	local X2AbilityTemplate TraitTemplate;
	local X2AbilityTemplateManager AbilityMgr;
	local AbilitySummaries Detail;
	local array<X2AbilityTemplate> Strengths;
	local array<X2AbilityTemplate> Weaknesses;
	local name TraitName;
	local String ChosenType;
	local int Index;
	local ChosenFiles File;
	// local XComGameState TestGameState;
	History = `XCOMHISTORY;
	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach History.IterateByClassType(class 'XComGameState_AdventChosen', ChosenState) {
		ChosenType = Split(string(ChosenState.GetMyTemplateName()), "_", true);
		Index = ChosenDocs.Find('ChosenType', ChosenType);
		if(!ChosenState.bMetXCom) { // haven't met, don't create an entry
			continue;
		} else if (Index == INDEX_NONE) { // James Franco: first time?
			File.ChosenName = ChosenState.FirstName $ " " $ ChosenState.NickName $ " " $ ChosenState.LastName;
			File.bIsActive = !ChosenState.bDefeated;
			File.ChosenType = ChosenType;
			if (File.ChosenType == "Warlock") {
				File.ChosenIcon = "img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Warlock";
			} else if (File.ChosenType == "Hunter") {
				File.ChosenIcon = "img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Hunter";
			} else if (File.ChosenType == "Assassin") {
				File.ChosenIcon = "img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Assasin"; // THEY MISSPELLED ASSASSIN WTF. I WAS STUCK ON THIS LONGER THAN I SHOULD HAVE BEEN.
				// TestGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating Chosen Strengths");
				// ChosenState.GainNewStrengths(TestGameState, 3); // for testing
				// `XCOMGAME.GameRuleset.SubmitGameState(TestGameState);
			}
			Strengths = ChosenState.GetChosenStrengths();
			Weaknesses = ChosenState.GetChosenWeaknesses();
			foreach Strengths(TraitTemplate) {
				Detail.AbilityName = TraitTemplate.LocFriendlyName;
				Detail.AbilityDescription = TraitTemplate.LocHelpText;
				File.Strengths.AddItem(Detail);
			}
			foreach Weaknesses(TraitTemplate) {
				Detail.AbilityName = TraitTemplate.LocFriendlyName;
				Detail.AbilityDescription = TraitTemplate.LocHelpText;
				File.Weaknesses.AddItem(Detail);
			}
			File.ChosenLogo = "img:///gfxTacticalHUD.chosen_logo";
			ChosenDocs.AddItem(File);
		} else { // update info
			ChosenDocs[Index].Strengths.Length = 0;
			ChosenDocs[Index].Weaknesses.Length = 0;
			// check if they've been killed
			if (ChosenState.bDefeated) {
				ChosenDocs[Index].bIsActive = false;
			}
			foreach Strengths(TraitTemplate) {
				Detail.AbilityName = TraitTemplate.LocFriendlyName;
				Detail.AbilityDescription = TraitTemplate.LocHelpText;
				ChosenDocs[Index].Strengths.AddItem(Detail);
			}
			foreach Weaknesses(TraitTemplate) {
				Detail.AbilityName = TraitTemplate.LocFriendlyName;
				Detail.AbilityDescription = TraitTemplate.LocHelpText;
				ChosenDocs[Index].Weaknesses.AddItem(Detail);
			}
		}
			
	}
}

function updateChosenActiveState(string ChosenType) {
	local int i;
	i = ChosenDocs.Find('ChosenType', ChosenType); // we are assuming this will be found since this only runs when the chosen has been defeated.
	ChosenDocs[i].bIsActive = false;
}