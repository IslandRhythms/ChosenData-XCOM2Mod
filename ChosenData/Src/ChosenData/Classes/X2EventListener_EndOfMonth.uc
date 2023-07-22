class X2EventListener_EndOfMonth extends X2EventListener;

//add the listener
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(DD_ChosenData_CreateListener_EndOfMonth());

	return Templates;
}

//create the listener
static function X2EventListenerTemplate DD_ChosenData_CreateListener_EndOfMonth()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'DD_ChosenData_EndOfMonth');

	Template.RegisterInTactical = false;	//listen during missions
	Template.RegisterInStrategy = true;		//listen during avenger

	//set to listen for event, do a thing, at this time
	Template.AddCHEvent('PostEndOfMonth', GetChosenInformation, ELD_OnStateSubmitted);

	return Template;
}

//what does the listener do when it hears a call?
static function EventListenerReturn GetChosenInformation(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	return ELR_NoInterrupt;
}