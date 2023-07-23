// This is an Unreal Script
class XComGameState_ChosenData extends XComGameState_BaseObject;


struct ChosenFiles {
	var array<String> Strengths; // might be easier to just have as an array of names like the data file.
	var array<String> Weaknesses;
	var bool bIsActive;
	var String ChosenIcon;
	var String ChosenLogo;
};

var array<ChosenFiles> ChosenDocs;


function UpdateChosenInformation() {

}