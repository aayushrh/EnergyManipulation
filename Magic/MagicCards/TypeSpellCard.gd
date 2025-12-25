extends Resource
class_name TypeSpellCard

@export var cardName : String
@export var cardDescription : String
@export var SpellObj : PackedScene
@export var color : Color
@export var icon : Texture2D
@export var cdMult : float
@export var costMult : float
@export var maxPowerTimeMult : float
@export var castingTimeMult : float
@export var contCostMult : float
@export var aimType : int
@export var attribute : Array[Attributes]
@export var values : Array[String]
@export var tags : Array[String]
var type : int = 2
