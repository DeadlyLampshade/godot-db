tool
extends Resource

enum DATA_TYPE {
	STRING=0,
	STRING_MULTILINE=1,
	NUMBER=2,
	BOOLEAN=3,
	REFERENCE=4,
	STRUCTURE=5,
	ARRAY=6,
	COLOR = 7
}

const DATA_TYPE_LIST = [
	["String", DATA_TYPE.STRING],
	["Multi-line String", DATA_TYPE.STRING_MULTILINE],
	["Number", DATA_TYPE.NUMBER],
	["Boolean", DATA_TYPE.BOOLEAN],
	["Color", DATA_TYPE.COLOR],
	#["Reference", DATA_TYPE.REFERENCE],
	#["Array", DATA_TYPE.ARRAY]
]