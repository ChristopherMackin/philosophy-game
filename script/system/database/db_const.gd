extends Object

class_name DBConst

enum WorldSchema {
	STORY_PROGRESS = 0,
}
enum SceneSchema {}
enum DebateSchema {
	CURRENT_CARD = 0,
	CURRENT_POSE = 1,
	PREVIOUS_CARD = 2,
	PREVIOUS_POSE = 3,
	PLAYER = 4,
	COMPUTER = 5,
	ACTIVE_CONTESTANT = 6,
	CURRENT_TURN = 7,
}
enum CharacterSchema {
	DEBATES_FINISHED = 0,
	HAS_PLAYED_EVENT_0 = 1,
}

const world_schema_data : Array = [
	{
		"key" : "story_progress",
		"type" : TYPE_INT,
		"default" : 0,
		"description" : "The current story progression flag"
	}
]

const scene_schema_data : Array = []

const debate_schema_data : Array = [
	{
		"key" : "current_top",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The top that was played last"
	},
	{
		"key" : "current_pose",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The pose of the top that was played last"
	},
	{
		"key" : "previous_top",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The top that was played before last"
	},
	{
		"key" : "previous_pose",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The pose of the top that was played before last"
	},
	{
		"key" : "player",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The name of the player character"
	},
	{
		"key" : "computer",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The name of the computer character"
	},
	{
		"key" : "active_contestant",
		"type" : TYPE_STRING,
		"default" : "",
		"description" : "The top that was played last"
	},
	{
		"key" : "current_turn",
		"type" : TYPE_INT,
		"default" : "",
		"description" : "The current turn of the debate"
	},
]

const character_schema_data : Array = [
	{
		"key" : "debates_finished",
		"type" : TYPE_INT,
		"default" : 0,
		"description" : "The number of debates finished against this opponent"
	},
	{
		"key" : "has_played_event_0",
		"type" : TYPE_BOOL,
		"default" : false,
		"description" : "Has the event been played for this character"
	},
]

enum DBSchema {
	WORLD = 0,
	DEBATE = 1,
	SCENE = 2,
	CHARACTER = 3,
}

const db_schema_data : Array = [
	world_schema_data,
	debate_schema_data,
	scene_schema_data,
	character_schema_data
]

const db_schema : Array = [
	WorldSchema,
	DebateSchema,
	SceneSchema,
	CharacterSchema
]
