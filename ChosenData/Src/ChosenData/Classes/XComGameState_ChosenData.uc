// This is an Unreal Script
class XComGameState_ChosenData extends XComGameState_BaseObject;


struct ChosenFiles {
	var array<String> Strengths; // might be easier to just have as an array of names like the data file.
	var array<String> Weaknesses;
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
	local String ChosenType;
	local int Index;
	local ChosenFiles File;
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class 'XComGameState_AdventChosen', ChosenState) {
		ChosenType = Split(string(ChosenState.GetMyTemplateName()), "_", true);
		Index = ChosenDocs.Find('ChosenType', ChosenType);
		if(!ChosenState.bMetXCom) { // haven't met, don't create an entry
			continue;
		} else if (Index != INDEX_NONE) { // James Franco: first time?
			File.ChosenName = ChosenState.FirstName $ " " $ ChosenState.NickName $ " " $ ChosenState.LastName;
			ChosenDocs.AddItem(File);
		} else { // update info
			// ChosenDocs[Index].Strengths;
			// ChosenDocs[Index].Weaknesses;
			// check if they've been killed
			// ChosenDocs.bIsActive;
		}
			
	}
}