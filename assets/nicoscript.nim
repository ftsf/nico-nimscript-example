type ColorId* = int
type Pfloat* = float32
type Pint* = int

const maxPlayers* = 4

converter toPfloat*(x: int): Pfloat =
  x.Pfloat

converter toPint*(x: float32): Pint =
  x.Pint

type SpriteDraw* = object
  spriteSheet*,spriteIndex*,x*,y*,w*,h*: int
  flipX*,flipY*: bool

type NicoControllerKind* = enum
  Keyboard
  Gamepad

type NicoController* = ref object
  kind*: NicoControllerKind
  name*: string
  id*: int # -1 for keyboard
  axes*: array[NicoAxis, tuple[current, previous: float, hold: int]]
  buttons*: array[NicoButton, int]
  deadzone*: float
  invertX*: bool
  invertY*: bool
  useRightStick*: bool

type NicoButton* = enum
  pcLeft = "Left"
  pcRight = "Right"
  pcUp = "Up"
  pcDown = "Down"
  pcA = "A"
  pcB = "B"
  pcX = "X"
  pcY = "Y"
  pcL1 = "L1"
  pcL2 = "L2"
  pcL3 = "L3"
  pcR1 = "R1"
  pcR2 = "R2"
  pcR3 = "R3"
  pcStart = "Start"
  pcBack = "Back"


